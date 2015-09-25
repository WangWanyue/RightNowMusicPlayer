//
//  RNInternetErrorView.m
//  RightNow
//
//  Created by 薄荷 on 15/5/8.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "RNInternetErrorView.h"

@implementation RNInternetErrorView


+ (RNInternetErrorView *)instanceRNInternetErrorView{
    NSArray *array  = [[NSBundle mainBundle] loadNibNamed:@"RNInternetErrorView" owner:self options:nil];
    return array[0];
}

@end
