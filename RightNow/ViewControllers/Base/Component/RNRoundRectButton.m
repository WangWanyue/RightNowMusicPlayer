//
//  RNRoundRectButton.m
//  RightNow
//
//  Created by 薄荷 on 15/4/13.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "RNRoundRectButton.h"

@implementation RNRoundRectButton

+ (id)btnWithBackgroung:(NSString *)img
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"RNRoundRectButton" owner:self options:nil];
    RNRoundRectButton *newButton = views[0];
    [newButton setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    return newButton;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}
@end
