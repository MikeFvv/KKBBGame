//
//  net.h
//  hgtysjb
//
//  Created by 住朋购友 on 2018/1/9.
//  Copyright © 2018年 com.comshijiebei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^XMCompletioBlock)(NSDictionary *dic, NSURLResponse *response, NSError *error);
typedef void (^XMSuccessBlock)(NSData *data);
typedef void (^XMFailureBlock)(NSError *error);

@interface NetworkRequest : NSObject
 
    
    
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock;


@end

