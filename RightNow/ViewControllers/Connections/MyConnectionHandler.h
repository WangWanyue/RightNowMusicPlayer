//
//  MyConnectionHandler.h
//  RightNow
//
//  Created by 薄荷 on 15/5/4.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyConnectionHandler : NSObject

+ (AFHTTPRequestOperation *)getCategorySuccess:(RNNetworkSuccess)success
                                       failure:(RNNetworkFilure)failure;

+ (AFHTTPRequestOperation *)getMusicListWithParams:(NSDictionary *)params
                                           success:(RNNetworkSuccess)success
                                           failure:(RNNetworkFilure)failure;

+ (AFHTTPRequestOperation *)createUserWithParams:(NSDictionary *)params
                                           success:(RNNetworkSuccess)success
                                           failure:(RNNetworkFilure)failure;

+ (AFHTTPRequestOperation *)getIsFavoriteWithParams:(NSDictionary *)params
                                         success:(RNNetworkSuccess)success
                                         failure:(RNNetworkFilure)failure;

+ (AFHTTPRequestOperation *)setFavoriteWithParams:(NSDictionary *)params
                                          success:(RNNetworkSuccess)success
                                          failure:(RNNetworkFilure)failure;

@end
