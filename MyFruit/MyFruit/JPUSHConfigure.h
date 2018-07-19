//
//  JPUSHConfigure.h
//  MyFruit
//
//  Created by 恋康科技 on 2018/3/2.
//  Copyright © 2018年 BCTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JPUSHService.h"
#import "LGBCPromptView.h"
#import <UserNotifications/UserNotifications.h>


@interface JPUSHConfigure : NSObject


///** 初始化  */
+ (JPUSHConfigure *)__attribute__((optnone))sharedManager;

/**
 *  判断是否显示推送提醒 （如果未打开推送累计使用15次提醒一次）
 */
+ (void)__attribute__((optnone))JudgeNoticeIsOpen;
@end
