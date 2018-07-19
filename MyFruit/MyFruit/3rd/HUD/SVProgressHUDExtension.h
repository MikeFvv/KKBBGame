//
//  SVProgressHUD+Extension.h
//  BJCR
//
//  Created by HG on 2017/11/24.
//  Copyright © 2017年 HuangGuan. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (Extension)

+ (void)sv_showSuccess:(NSString *)setString;

+ (void)sv_showMessage:(NSString *)setString;

+ (void)sv_showError:(NSString *)setString;

+ (void)sv_showWithError:(NSError *)error;

@end
