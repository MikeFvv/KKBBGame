//  ViewController.m
//  MyFruit
//  Created by 恋康科技 on 2018/1/16.
//  Copyright © 2018年 BCTeam. All rights reserved.

#import "ViewController.h"
#import "NetworkRequest.h"
#import "BottomToolbar.h"
#import "SVProgressHUDExtension.h"
#import <WebKit/WebKit.h>
#import "Reachability.h"
#import "JPUSHConfigure.h"

/*H5路径  日期  是否横屏*/
#define HTMLSTRING  @"%@/gameF"       //H5路径
#define DTATSTRING  @"2018-06-19"  // 天数-月份-年份
//我的LN:Air-Fruit
#define AVOSAPPKEY    @"BS0StOrXIsWxOuXwaa2G5x6T-gzGzoHsz"
#define AVOSCLIENTKEY @"jr9sw55X2mD9hAGgWYh97Jwm"
#define CONFIGID      @"5ad95842ee920a3f733ffe27"  //DB配置id
/** 屏幕宽度 */
#define YLScreenW [[UIScreen mainScreen] bounds].size.width
/** 屏幕高度 */
#define YLScreenH (([[UIScreen mainScreen] bounds].size.height == 812)?([[UIScreen mainScreen] bounds].size.height-34):[[UIScreen mainScreen] bounds].size.height)

@interface ViewController ()<UIWebViewDelegate,BottomToolbarDelegate>
@property(nonatomic, strong) UIWebView               *fdWebView;
@property(nonatomic, strong) UIImageView             *loadingImageView;
@property(nonatomic, strong) UILabel                 *loadingLabel;
@property(nonatomic, assign) BOOL                    fdLandscape;
@property(nonatomic, strong) BottomToolbar           *bar;
@property(nonatomic, strong) Reachability            *conn;
@property(nonatomic, strong) UIActivityIndicatorView *myActivityView;
@property(nonatomic, strong) NSString                *homeUrlstring;
@property(nonatomic, assign) BOOL                    isReview;
@property(nonatomic, assign) BOOL                    fdIsHorizontal;
@property(nonatomic, assign) int                     fdNumber;
@property(atomic,    strong) NSTimer                 *fdTimer;
@end

@implementation ViewController

#pragma mark - viewLoad
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _fdWebView.frame=self.view.bounds;
    _myActivityView.frame = CGRectMake(YLScreenW / 2 - 30, YLScreenH / 2 - 60, 60, 60);
    _loadingLabel.frame = CGRectMake(YLScreenW / 2 - 150, YLScreenH / 2 - 15 , 300, 30);
    _loadingImageView.frame = self.view.bounds;
    
    [self setWebFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.fdLandscape = YES;    //如果竖屏为NO  横屏为YES
    self.isReview = NO;
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    [self.view addSubview:self.fdWebView];
    [self.view addSubview:self.loadingImageView];
    
    if ([self sjPduan] == 1)
    {
        [self fGame];//加载游戏
    }
    else
    {
        //走请求的时候再加载菊花
        // *** 加载指示器
        self.myActivityView = [[UIActivityIndicatorView alloc] init];
        self.myActivityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.myActivityView.color = [UIColor blackColor];
        [self.loadingImageView addSubview:self.myActivityView];
        [self.myActivityView startAnimating];
        [self.view addSubview:self.loadingLabel];
        //走请求
        [self myGame];
        
        // 生成一个初始百分比
        self.fdNumber = arc4random() % 30;
        
        // 创建定时器
        self.fdTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getPercentage) userInfo:nil repeats:YES];
    }
}

#pragma mark - 时间判断
- (int)__attribute__((optnone))sjPduan
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime=[dateFormatter stringFromDate:[NSDate date]];
    NSDate *currendate = [dateFormatter dateFromString:dateTime];
    NSDate *date = [dateFormatter dateFromString:DTATSTRING];
    NSComparisonResult result = [date compare:currendate];
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

//加载游戏
- (void)__attribute__((optnone))fGame
{
    if (self.fdLandscape)
    {
        [self rotateOrientation:UIInterfaceOrientationLandscapeRight];
    }
    _loadingImageView.image = [UIImage imageNamed:@"loading"];
    if (self.myActivityView != nil)
    {
        [self.myActivityView stopAnimating];
    }
    [self loadGame];
}
#pragma mark - loadGame
- (void)__attribute__((optnone))loadGame
{
    NSString * mainbundlepath = [[NSBundle mainBundle ] bundlePath];
    NSString *basepath = [NSString stringWithFormat:HTMLSTRING ,mainbundlepath];
    NSURL *baseurl = [NSURL fileURLWithPath:basepath isDirectory:YES];
    NSString * htmlpath = [NSString stringWithFormat:@"%@/fruit.html",basepath];
    NSString * htmlstring = [NSString stringWithContentsOfFile:htmlpath encoding:NSUTF8StringEncoding error:nil];
    [self.fdWebView loadHTMLString:htmlstring baseURL:baseurl ];
}

#pragma mark - 加载资源
//自己活
- (void)__attribute__((optnone))myGame
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    NSString *URLCODE = [AVOSAPPKEY substringToIndex:8];//截取掉下标5之前的字符串
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          URLCODE,@"urlcode",
                          AVOSAPPKEY,@"lcid" ,
                          AVOSCLIENTKEY,@"lckey",
                          CONFIGID,@"configid"
                          , nil];
    [NetworkRequest getWithUrlString:@"" parameters:dict success:^(NSData *data) {
        [SVProgressHUD dismiss];
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // NSString *aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            // NSLog("%@",aStr);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if(dic)
            {
                NSNumber *isOpen = dic[@"isOpen"];
                NSString *openUrl = dic[@"openUrl"];
                NSString *jpushKey = dic[@"jpushKey"];
                
                if(isOpen == NULL || openUrl == NULL || jpushKey == NULL)
                {
                    [self fGame];
                    return;
                }
                
                if(isOpen.boolValue == YES)
                {
                    [self woDeQian:jpushKey jumpUrl:openUrl];
                }
                else
                {
                    [self fGame];
                }
                return;
            }
            [self fGame];
        });
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self netWorkFaild];
    }];
}
- (void)__attribute__((optnone))woDeQian:(NSString *)jpushKey jumpUrl:(NSString *)jumpUrl
{
    if (self.InitJPush)
    {
        self.InitJPush(jpushKey);
    }
    [JPUSHConfigure JudgeNoticeIsOpen];
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        safeAreaInsets = self.view.safeAreaInsets;
    }
    //是否hiddenbottomBar
    
    self.fdWebView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44.0 - safeAreaInsets.bottom);
    [self.view addSubview:self.bar];
    
    self.isReview = YES; //修改状态
    //如果此时为横屏则改成竖屏
    if (self.fdLandscape)
    {
        self.fdLandscape = NO;
        [self rotateOrientation:UIInterfaceOrientationPortrait];
    }
    //加载url
    self.homeUrlstring = [NSString stringWithString:jumpUrl];
    NSURL *htmlURL = [NSURL URLWithString:jumpUrl];
    //NSLog(@"---------------2---------------%@", jpushKey);
    //NSLog(@"---------------3---------------%@", jumpUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL];
    [self.fdWebView loadRequest:request];
}

//获取百分比
- (void)getPercentage
{
    //NSLog(@"%d",self.fdNumber);
    if (self.fdNumber >= 100)
    {
        self.fdNumber = 100;
    }
    else
    {
        int percentage = arc4random() % 15;
        self.fdNumber = self.fdNumber + percentage;
    }
    if (self.fdNumber < 100)
    {
        self.loadingLabel.text = [NSString stringWithFormat:@"Loading %d%%",self.fdNumber];
    }
    else
    {
        self.loadingLabel.text = @"Loading...";
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 屏幕操作
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //没过
    if (!self.isReview)
    {
        //执行下列屏幕旋转操作
        if (self.fdLandscape)
        {
            return UIInterfaceOrientationMaskLandscape;
        }
        return UIInterfaceOrientationMaskPortrait;
    }
    else
    {
        //过了审核
        return UIInterfaceOrientationMaskAll;
    }
}
- (void)__attribute__((optnone))rotateOrientation:(UIInterfaceOrientation)orientation
{
    //横屏
    if (self.fdLandscape)
    {
        //NSLog(@"执行了1");
        NSNumber *orientationUnknown = [NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInteger:orientation];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
    //竖屏
    else
    {
        //NSLog(@"执行了2");
        NSNumber *orientationUnknown = [NSNumber numberWithInteger:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInteger:orientation];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}
/* 判断当前屏幕状态 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    switch (interfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
            //NSLog(@"home在下");
            self.fdIsHorizontal = NO;
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            //NSLog(@"home在上");
            self.fdIsHorizontal = NO;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            //NSLog(@"home在左");
            self.fdIsHorizontal = YES;
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            //NSLog(@"home在右");
            self.fdIsHorizontal = YES;
            break;
            
        default:
            break;
    }
    [self setWebFrame];
}

- (void)setWebFrame
{
    if (_isReview && !_fdIsHorizontal)
    {
        //NSLog(@"不是横屏");
        UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *)) {
            safeAreaInsets = self.view.safeAreaInsets;
        }
        CGRect frame = CGRectMake(0.0, CGRectGetHeight(self.view.bounds) - 44.0 - safeAreaInsets.bottom, CGRectGetWidth(self.view.bounds), 44.0);
        _bar.frame=frame;
        [_bar setHidden:NO];
        self.fdWebView.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44.0 - safeAreaInsets.bottom - [[UIApplication sharedApplication] statusBarFrame].size.height);
    }
    else
    {
        _fdWebView.frame=self.view.bounds;
        [_bar setHidden:YES];
    }
}

#pragma mark - 网络失败
- (void)__attribute__((optnone))netWorkFaild
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"title", @"")
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self myGame];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - bottomBarDelegate
- (void)__attribute__((optnone))toolbar:(BottomToolbar *)webToolbar event:(LKToolbarEvent)event
{
    switch (event)
    {
        case BottomToolbarHomeEvent:
            //NSLog(@"回到首页");
            [self backHome];
            break;
        case BottomToolbarBackEvent:
            if ([self.fdWebView canGoBack])
            {
                [self.fdWebView goBack];
            }
            break;
        case BottomToolbarNextEvent:
            if ([self.fdWebView canGoForward])
            {
                [self.fdWebView goForward];
            }
            break;
        case BottomToolbarRefreshEvent:
            [self.fdWebView reload];
            break;
        case BottomToolbarClearEvent:
            [self removeWebCache];
            break;
    }
}

#pragma mark - 回到主页
- (void)__attribute__((optnone))backHome
{
    NSURL *htmlURL = [NSURL URLWithString:self.homeUrlstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL];
    [self.fdWebView loadRequest:request];
}
//判断底部操作栏状态
- (void)__attribute__((optnone))adjustState
{
    if (_bar)
    {
        self.bar.backButton.enabled = [self.fdWebView canGoBack];
        self.bar.forwardButton.enabled = [self.fdWebView canGoForward];
    }
}

#pragma mark - 清除缓存
- (void)__attribute__((optnone))removeWebCache
{
    if (@available(iOS 9.0, *))
    {
        NSSet *websiteDataTypes= [NSSet setWithArray:@[
                                                       WKWebsiteDataTypeDiskCache,
                                                       WKWebsiteDataTypeOfflineWebApplicationCache,
                                                       WKWebsiteDataTypeMemoryCache,
                                                       //WKWebsiteDataTypeCookies,
                                                       WKWebsiteDataTypeSessionStorage,
                                                       WKWebsiteDataTypeIndexedDBDatabases,
                                                       WKWebsiteDataTypeWebSQLDatabases
                                                       ]];
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            [SVProgressHUD sv_showSuccess:@"clear"];
        }];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
    else
    {
        //先删除cookie
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        
        NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        //        NSString *webKitFolderInCachesfs = [NSString
        //                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        NSError *error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        [SVProgressHUD sv_showSuccess:@"clear"];
    }
}

#pragma mark - webviewdelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* reqUrl = request.URL.absoluteString;
    //支付宝
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"])
    {
        if (@available(iOS 10.0, *))
        {
            [[UIApplication sharedApplication] openURL:request.URL options:@{@"":@""} completionHandler:nil];
        }
        else
        {
            BOOL bsucces = [[UIApplication sharedApplication] openURL:request.URL];
        }
    }
    if ([reqUrl hasPrefix:@"weixin://"])
    {
        if (@available(iOS 10.0, *))
        {
            [[UIApplication sharedApplication] openURL:request.URL options:@{@"":@""} completionHandler:nil];
        }
        else
        {
            BOOL bsucces = [[UIApplication sharedApplication] openURL:request.URL];
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.myActivityView != nil) {
        [self.myActivityView stopAnimating];
    }
    if (self.loadingLabel != nil) {
        [self.loadingLabel setHidden:YES];
    }
    self.loadingImageView.hidden = YES;//hidden loadingImage
    if (self.myActivityView != nil) {
        [self.myActivityView stopAnimating];
    }
    if (_bar) [self adjustState];

    //取消定时器
    [self.fdTimer invalidate];
    self.fdTimer = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.myActivityView != nil)
    {
        [self.myActivityView stopAnimating];
    }
    if (self.loadingLabel != nil)
    {
        [self.loadingLabel setHidden:YES];
    }
    self.loadingImageView.hidden = YES;//hidden loadingImage
    if (_bar) [self adjustState];
    //取消定时器
    [self.fdTimer invalidate];
    self.fdTimer = nil;
}


#pragma mark - 懒加载
- (UIImageView *)loadingImageView
{
    if (!_loadingImageView)
    {
        _loadingImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _loadingImageView.contentMode = UIViewContentModeScaleAspectFit;
        _loadingImageView.backgroundColor = [UIColor whiteColor]; // color
        _loadingImageView.alpha = 1.0;
    }
    return _loadingImageView;
}
- (UILabel *)loadingLabel
{
    if (!_loadingLabel)
    {
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        _loadingLabel.font = [UIFont boldSystemFontOfSize:17];
        _loadingLabel.textColor = [UIColor blackColor];
        //_loadingLabel.text = @"  加载中...";
    }
    return _loadingLabel;
}
- (BottomToolbar *)bar
{
    if (!_bar)
    {
        UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *))
        {
            safeAreaInsets = self.view.safeAreaInsets;
        }
        CGRect frame = CGRectMake(0.0, CGRectGetHeight(self.view.bounds) - 44.0 - safeAreaInsets.bottom, CGRectGetWidth(self.view.bounds), 44.0);
        _bar = [[BottomToolbar alloc] initWithFrame:frame];
        _bar.delegate = self;
    }
    return _bar;
}

- (UIWebView *)fdWebView
{
    if (!_fdWebView)
    {
        _fdWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _fdWebView.backgroundColor = [UIColor whiteColor];
        _fdWebView.scrollView.bounces = NO;
        _fdWebView.delegate = self;
    }
    return _fdWebView;
}

@end
