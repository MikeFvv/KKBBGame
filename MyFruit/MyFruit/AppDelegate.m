//  AppDelegate.m
//  MyFruit
//  Created by 恋康科技 on 2018/1/16.
//  Copyright © 2018年 BCTeam. All rights reserved.

#import "AppDelegate.h"
#import "ViewController.h"
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "STCObfuscator.h"
@interface AppDelegate ()<JPUSHRegisterDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
#if (DEBUG == 1)
    // md5加盐
    [STCObfuscator obfuscatorManager].md5Salt = @"sdSXC5sw6";
    
    
    [STCObfuscator obfuscatorManager].unConfuseClassNames = [NSArray arrayWithObjects:@"JPUSHService",nil];
    [[STCObfuscator obfuscatorManager] confuseWithRootPath:[NSString stringWithFormat:@"%s", STRING(ROOT_PATH)] resultFilePath:[NSString stringWithFormat:@"%@/STCDefination.h", [NSString stringWithFormat:@"%s", STRING(ROOT_PATH)]] linkmapPath:[NSString stringWithFormat:@"%s", STRING(LINKMAP_FILE)]];
#endif
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController * vc = [[ViewController alloc] init];
    [vc setInitJPush:^(NSString * JpushAppKey) {
        
        // 设置角标为零
        application.applicationIconBadgeNumber = 0;
        //Required
        //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            // 可以添加自定义categories
            // NSSet<UNNotificationCategory *> *categories for iOS10 or later
            // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        }
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
        // Required
        // init Push
        // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
        // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
        [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey
                              channel:nil
                     apsForProduction:YES
                advertisingIdentifier:nil];
    }];
    
    // *** 初始化跟视图
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application{}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 设置角标为零
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - JPUSHRegisterDelegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *))
    {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
        {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    }
    else
    {}
    if (@available(iOS 10.0, *))
    {
        completionHandler(UNNotificationPresentationOptionAlert);
    }
    else{}
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *))
    {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
        {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    }
    else{}
    completionHandler();  // 系统要求执行这个方法
}
@end
