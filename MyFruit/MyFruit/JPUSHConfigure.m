//
//  JPUSHConfigure.m
//  MyFruit
//
//  Created by 恋康科技 on 2018/3/2.
//  Copyright © 2018年 BCTeam. All rights reserved.
//

#import "JPUSHConfigure.h"

@implementation JPUSHConfigure


+ (JPUSHConfigure *)__attribute__((optnone))sharedManager{
    static JPUSHConfigure *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

#pragma mark - 推送设置
+ (void)__attribute__((optnone))JudgeNoticeIsOpen{
    
    // *** 已经设置用不提醒
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"never_remind_notice"]) {
        return;
    }
    
    // *** 获取上一次应用使用次数
    int useCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"use_app_count"] intValue];
    // *** 当前次累计
    useCount ++;
    
    // *** 累计使用次数达11次时进行检测
    if (useCount > 14) {
        // *** 开始检测，使用次数置0
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"use_app_count"];
        
        // *** 判断应用是否打开推送功能
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if(UIUserNotificationTypeNone == setting.types) {
            NSLog(@"%@",@"aaa");
            // *** 未打开推送，显示提示信息
            LGBCPromptView * promptView = [[LGBCPromptView alloc] initAlertViewWithMessageStr:NSLocalizedString(@"MessageStr", @"") andFirstStr:NSLocalizedString(@"FirstStr", @"") andSecondStr:NSLocalizedString(@"SecondStr", @"") andThirdStr:NSLocalizedString(@"ThirdStr", @"")];
            [promptView showWithCompletion:^(NSInteger clickIndex) {
                if (clickIndex == 2) {
                    // *** 立即设置
                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }else if (clickIndex == 1){
                    // *** 不再提醒
                    [[NSUserDefaults standardUserDefaults] setObject:@"never_remind_notice" forKey:@"never_remind_notice"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }];
        }
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",useCount] forKey:@"use_app_count"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
