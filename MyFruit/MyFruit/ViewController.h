//  ViewController.h
//  MyFruit
//  Created by 恋康科技 on 2018/1/16.
//  Copyright © 2018年 BCTeam. All rights reserved.

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/** 结果回调 */
@property (nonatomic ,copy) void (^InitJPush)(NSString *);
@end

