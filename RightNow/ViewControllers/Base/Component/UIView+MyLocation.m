//
//  UIView+MyLocation.m
//  RightNow
//
//  Created by 薄荷 on 15/4/11.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "UIView+MyLocation.h"

@implementation UIView (MyLocation)

- (CGFloat)X
{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)X
{
    self.X = X;
}

- (CGFloat)Y
{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)Y
{
    self.Y = Y;
}

- (CGFloat)W
{
    return self.frame.size.width;
}
- (void)setW:(CGFloat)W
{
    self.W = W;
}

- (CGFloat)H
{
    return self.frame.size.height;
}
- (void)setH:(CGFloat)H
{
    self.H = H;
}

- (CGFloat)endX
{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setEndX:(CGFloat)endX
{
    self.endX = endX;
}

- (CGFloat)endY
{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setEndY:(CGFloat)endY
{
    self.endY = endY;
}

@end
