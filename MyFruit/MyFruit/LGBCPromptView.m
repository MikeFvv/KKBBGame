//
//  PrefixHeader.pch
//  LGH5FrameWork
//
//  Created by 恋康科技 on 2018/2/5.
//  Copyright © 2018年 BCTeam. All rights reserved.
//

#import "LGBCPromptView.h"

@implementation LGBCPromptView

- (instancetype)__attribute__((optnone))initAlertViewWithMessageStr:(NSString *)messageStr andSureStr:(NSString *)sureStr andCheckStr:(NSString *)checkStr{

    self = [super init];
    myAlertView = [[UIAlertView alloc] initWithTitle:messageStr message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:sureStr,checkStr, nil];
    return self;
}

- (instancetype)__attribute__((optnone))initAlertViewWithMessageStr:(NSString *)messageStr andFirstStr:(NSString *)firstStr andSecondStr:(NSString *)secondStr andThirdStr:(NSString *)thirdStr{

    self = [super init];
    myAlertView = [[UIAlertView alloc] initWithTitle:messageStr message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:firstStr,secondStr,thirdStr, nil];
    return self;
    
}



- (void)__attribute__((optnone))showWithCompletion:(void (^)(NSInteger))completeBlock{
    
    [myAlertView show];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.clickIndexBlock = completeBlock;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.clickIndexBlock) {
        self.clickIndexBlock(buttonIndex);
    }
    
    [self removeFromSuperview];
    
}




@end
