//
//  RNHttpRequest.h
//  RightNow
//
//  Created by 薄荷 on 15/5/3.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RNNetworkSuccess)(id response);
typedef void (^RNNetworkFilure)(void);

@interface RNHttpRequest : NSObject

+ (id)getInstance;

- (AFHTTPRequestOperation *)sendRequestWithUrl:(NSString *)urlStr
                                           params:(NSDictionary *)params
                                          success:(RNNetworkSuccess)success
                                          failure:(RNNetworkFilure)failure;

@end
