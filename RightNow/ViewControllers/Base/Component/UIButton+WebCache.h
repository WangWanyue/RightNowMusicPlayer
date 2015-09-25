//
//  UIButton+WebCache.h
//  RightNow
//
//  Created by 薄荷 on 15/5/3.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(WebCache)<NSURLConnectionDelegate>

- (void)setBackgroundImageWithUrl:(NSString *)url;

@end
