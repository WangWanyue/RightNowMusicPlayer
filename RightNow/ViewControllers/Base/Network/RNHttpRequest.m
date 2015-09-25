//
//  RNHttpRequest.m
//  RightNow
//
//  Created by 薄荷 on 15/5/3.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "RNHttpRequest.h"

@implementation RNHttpRequest
static RNHttpRequest *instance;

+ (id)getInstance{
    @synchronized(instance){
        if (instance == nil) {
            instance = [[RNHttpRequest alloc] init];
        }
        return instance;
    }
}

- (AFHTTPRequestOperation *)sendRequestWithUrl:(NSString *)urlStr
                                           params:(NSDictionary *)params
                                          success:(RNNetworkSuccess)success
                                          failure:(RNNetworkFilure)failure;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    return [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id response=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"response:%@",response);
        success(response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}


@end
