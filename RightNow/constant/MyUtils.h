//
//  MyUtils.h
//  RightNow
//
//  Created by 薄荷 on 15/4/11.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtils : NSObject

+ (CGFloat)getScreenWidth;
+ (CGFloat)getScreenHeight;

+ (UIColor *)color:(NSString *)hexColor;

+ (CGRect)getTopFrame:(CGRect)frame;
+ (CGRect)getButtomFrame:(CGRect)frame;

+ (NSArray *)getMusicCategoryData;

+ (NSArray *)getMusicData;

+ (NSString *)getToken;
+ (NSString *)createToken;
+ (void)saveToken:(NSString *)token;

+ (BOOL)getIsFirstLaunche;
+ (void)setFirstLaunche;
@end
