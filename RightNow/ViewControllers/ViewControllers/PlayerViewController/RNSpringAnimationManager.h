//
//  RNSpringAnimationManager.h
//  RightNow
//
//  Created by 薄荷 on 15/4/16.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNSpringAnimationManager : NSObject

+ (void)popSringAnimationView:(UIView *)view
                    FromValue:(NSValue *)fromValue
                      ToValue:(NSValue *)toValue
            WithAnimationName:(NSString *)name;

@end
