//
//  RNCircleProcessBar.m
//  RightNow
//
//  Created by 薄荷 on 15/4/14.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//  圆形进度条

#import "RNCircleProcessBar.h"


@interface RNCircleProcessBar()
{
    CGFloat oldFrameWidth;
}

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat lineWidth;

@property (nonatomic, strong) UIColor *playColor;
@property (nonatomic, strong) UIColor *bufferColor;
@property (nonatomic, strong) UIColor *progressBackgroundColor;

@end

@implementation RNCircleProcessBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.radius = self.W / 2;
        oldFrameWidth = self.radius;
        self.lineWidth = 3.0;
        self.backgroundColor = [UIColor clearColor];
        self.bufferPercent = 0.0;
        self.playPercent = 0.0;
        self.playColor = [MyUtils color:@"FEDD46"];
        self.bufferColor = [MyUtils color:@"888888"];
        self.progressBackgroundColor = [MyUtils color:@"666666"];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = self.W;
    if (w == 0) {
        return;
    }
    if (oldFrameWidth == 0) {
        oldFrameWidth = w;
        return;
    }
    CGFloat scale = w/oldFrameWidth;
    if (scale != 1.0) {
        self.lineWidth *= scale;
    }
    oldFrameWidth = w;

}

- (void)drawRect:(CGRect)rect {
    [self drawBackground];
    [self drawBufferProcess];
    [self drawMainProcess];
}

- (void)drawBackground //画圆形进度条背景
{
    CGFloat innerRadius = self.radius - self.lineWidth / 2;
    [self drawCircleWithStartAngle:0.0f
                          endAngle:2 * M_PI
                            radius:innerRadius
                         backColor:self.progressBackgroundColor];
}

- (void)drawBufferProcess//画缓冲进度条
{
    CGFloat innerRadius = self.radius - self.lineWidth / 2;
    CGFloat beginAngle = - M_PI_2;
    CGFloat endAngle = beginAngle + self.bufferPercent * 2 * M_PI;
    [self drawCircleWithStartAngle:beginAngle endAngle:endAngle radius:innerRadius backColor:self.bufferColor];
}

- (void)drawMainProcess//画黄色进度条
{
    CGFloat innerRadius = self.radius - self.lineWidth / 2;
    CGFloat beginAngle = - M_PI_2;
    CGFloat endAngle = beginAngle + self.playPercent * 2 * M_PI;
    [self drawCircleWithStartAngle:beginAngle endAngle:endAngle radius:innerRadius backColor:self.playColor];
}

- (void)drawCircleWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius backColor:(UIColor *)color
{
    UIBezierPath *processCircle = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                 radius:radius
                                                             startAngle:startAngle
                                                               endAngle:endAngle
                                                              clockwise:YES];
    [color setStroke];
    processCircle.lineWidth = self.lineWidth;
    [processCircle stroke];
}

- (void)setBufferProcessPercent:(CGFloat )percent{
    if ( percent >= 0.0 && percent <= 1.0) {
        self.bufferPercent = percent;
        [self setNeedsDisplay];
    }
}
- (void)setPlayProcessPercent:(CGFloat )percent{
    if ( percent >= 0.0 && percent <= 1.0) {
        self.playPercent = percent;
        [self setNeedsDisplay];
    }
}

- (CGFloat )radius
{
    return self.W / 2;
}

- (void)setRadius:(CGFloat)radius
{
    self.frame = CGRectMake(self.X, self.Y, radius *2.0f, radius *2.0f);
}

@end
