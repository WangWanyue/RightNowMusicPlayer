//
//  UIButton+WebCache.m
//  RightNow
//
//  Created by 薄荷 on 15/5/3.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "UIButton+WebCache.h"

@implementation UIButton(WebCache)

NSMutableData *urlData;
NSURLConnection *myConnection;
NSURLResponse *urlResponse;

- (void)setBackgroundImageWithUrl:(NSString *)url
{
    NSURL *myUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *myUrlRequest = [[NSURLRequest alloc] initWithURL:myUrl];
    myConnection =[[NSURLConnection alloc] initWithRequest:myUrlRequest
                                                  delegate:self
                                          startImmediately:YES];
    if ( myConnection == nil) {
        return ;
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response{
    urlData = [[NSMutableData alloc] init];
    //保存接收到的响应对象，以便响应完毕后的状态。
    urlResponse = response;
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [urlData appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
    //请求异常，在此可以进行出错后的操作，如给UIImageView设置一张默认的图片等。
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    //加载成功，在此的加载成功并不代表图片加载成功，需要判断HTTP返回状态。
    NSHTTPURLResponse *response=(NSHTTPURLResponse*)urlResponse;
    if(response.statusCode == 200){
        //请求成功
        UIImage *img=[UIImage imageWithData:urlData];
        [self setBackgroundImage:img forState:UIControlStateNormal];
    }
}

@end
