//
//  RNCircleProcessBar.h
//  RightNow
//
//  Created by 薄荷 on 15/4/14.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNCircleProcessBar : UIView

@property (nonatomic) CGFloat bufferPercent;
@property (nonatomic) CGFloat playPercent;

- (void)setBufferProcessPercent:(CGFloat )percent;
- (void)setPlayProcessPercent:(CGFloat )percent;

@end
