//  Created by 住朋购友 on 2018/1/9.
//  Copyright © 2018年 com.comshijiebei. All rights reserved.

#import "NetworkRequest.h"
#import "getUUID.h"

@implementation NetworkRequest

//GET 
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(XMSuccessBlock)successBlock failure:(XMFailureBlock)failureBlock
{
    NSString *URLCODE = parameters[@"urlcode"];
    NSString *CONFIGID = parameters[@"configid"];
    NSString *XLCID = parameters[@"lcid"];
    NSString *XLCKEY = parameters[@"lckey"];
    NSString *newurl=[NSString stringWithFormat:@"https://%@.api.lncld.net/1.1/classes/config/%@",URLCODE,CONFIGID];
    //NSLog(@"%@", newurl);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newurl]];
    [urlRequest setValue:XLCID forHTTPHeaderField:@"X-LC-Id"];
    [urlRequest setValue:XLCKEY forHTTPHeaderField:@"X-LC-Key"];
    urlRequest.timeoutInterval = 5.0;
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            failureBlock(error);
        }
        else
        {
            // NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(data);
        }
    }];
    [dataTask resume];
}

@end
