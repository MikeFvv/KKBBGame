//
//  SVProgressHUD+Extension.m
//  BJCR
//
//  Created by HG on 2017/11/24.
//  Copyright © 2017年 HuangGuan. All rights reserved.
//

#import "SVProgressHUDExtension.h"

static NSTimeInterval const SVProgressHUDCommonDisplayDuration = 1.0;

@implementation SVProgressHUD (Extension)

+ (void)load
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom]; // 默认使用自定义主题
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.9]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumSize:(CGSize){100.0, 100.0 * 0.5}];
}

+ (void)sv_showSuccess:(NSString *)setString
{
    [SVProgressHUD showSuccessWithStatus:setString];
    [SVProgressHUD sv_delayDismiss];
}

+ (void)sv_showMessage:(NSString *)setString
{
    [SVProgressHUD showInfoWithStatus:setString];
    [SVProgressHUD sv_delayDismiss];
}

+ (void)sv_showError:(NSString *)setString
{
    [SVProgressHUD showErrorWithStatus:setString];
    [SVProgressHUD sv_delayDismiss];
}

+ (void)sv_showWithError:(NSError *)error
{
    NSString *message = error.localizedDescription ?: @"未知错误";
    [SVProgressHUD showErrorWithStatus:message];
    [SVProgressHUD sv_delayDismiss];
}

+ (void)sv_delayDismiss
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SVProgressHUDCommonDisplayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
