//
//  PrefixHeader.pch
//  LGH5FrameWork
//
//  Created by 恋康科技 on 2018/2/5.
//  Copyright © 2018年 BCTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGBCPromptView : UIView<UIAlertViewDelegate>{
    UIAlertView *myAlertView;
}
@property (nonatomic, copy) void (^clickIndexBlock)(NSInteger clickIndex);


/**
 *  网络加载出错
 */
- (instancetype)__attribute__((optnone))initAlertViewWithMessageStr:(NSString*)messageStr andSureStr:(NSString*)sureStr andCheckStr:(NSString *)checkStr;

/**
 *  推送提示框
 */
- (instancetype)__attribute__((optnone))initAlertViewWithMessageStr:(NSString*)messageStr andFirstStr:(NSString*)firstStr andSecondStr:(NSString*)secondStr andThirdStr:(NSString*)thirdStr;


/**
 *  显示弹出框
 */
- (void)__attribute__((optnone))showWithCompletion:(void (^)(NSInteger clickIndex))completeBlock;


@end
