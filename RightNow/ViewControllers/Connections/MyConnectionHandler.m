//
//  MyConnectionHandler.m
//  RightNow
//
//  Created by 薄荷 on 15/5/4.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "MyConnectionHandler.h"

@implementation MyConnectionHandler

//获取类别信息
+ (AFHTTPRequestOperation *)getCategorySuccess:(RNNetworkSuccess)success
                                       failure:(RNNetworkFilure)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,getCategoryUrl];
    AFHTTPRequestOperation *operation = [[RNHttpRequest getInstance] sendRequestWithUrl:url params:nil success:^(id response) {
        if ([response isKindOfClass:[NSArray class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:CATEGORY_ALL_ARR];
            success(response);
        }
    } failure:^{
        failure();
    }];
    return operation;
}

//获取歌单网络连接
+ (AFHTTPRequestOperation *)getMusicListWithParams:(NSDictionary *)params
                                           success:(RNNetworkSuccess)success
                                           failure:(RNNetworkFilure)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,getMusicListUrl];
    AFHTTPRequestOperation *operation = [[RNHttpRequest getInstance] sendRequestWithUrl:url params:params success:^(id response) {
        if ([response isKindOfClass:[NSArray class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:CURRENT_MUSIC_ARR];
            success(response);
        }
    } failure:^{
        failure();
    }];
    return operation;

}

//创建用户网络连接
+ (AFHTTPRequestOperation *)createUserWithParams:(NSDictionary *)params
                                         success:(RNNetworkSuccess)success
                                         failure:(RNNetworkFilure)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,createUserUrl];
    AFHTTPRequestOperation *operation = [[RNHttpRequest getInstance] sendRequestWithUrl:url params:params success:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            success(response);
        }
    } failure:^{
        failure();
    }];
    return operation;
}

//取消like的网络连接
+ (AFHTTPRequestOperation *)getIsFavoriteWithParams:(NSDictionary *)params
                                            success:(RNNetworkSuccess)success
                                            failure:(RNNetworkFilure)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,getIsFavoriteUrl];
    AFHTTPRequestOperation *operation = [[RNHttpRequest getInstance] sendRequestWithUrl:url params:params success:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            success(response);
        }
    } failure:^{
        failure();
    }];
    return operation;
}

//like的网路连接
+ (AFHTTPRequestOperation *)setFavoriteWithParams:(NSDictionary *)params
                                          success:(RNNetworkSuccess)success
                                          failure:(RNNetworkFilure)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,setFavoriteUrl];
    AFHTTPRequestOperation *operation = [[RNHttpRequest getInstance] sendRequestWithUrl:url params:params success:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            success(response);
        }
    } failure:^{
        failure();
    }];
    return operation;
}

@end
