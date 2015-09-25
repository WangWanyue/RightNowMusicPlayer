//
//  RNSpringAnimationManager.m
//  RightNow
//
//  Created by 薄荷 on 15/4/16.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "RNSpringAnimationManager.h"

@implementation RNSpringAnimationManager


//spring动画方法
+ (void)popSringAnimationView:(UIView *)view
                    FromValue:(NSValue *)fromValue
                      ToValue:(NSValue *)toValue
            WithAnimationName:(NSString *)name
{
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.springBounciness = 12.0f;
    animation.springSpeed = 20.0f;
    animation.removedOnCompletion = YES;
    [view pop_addAnimation:animation forKey:name];
}

@end
