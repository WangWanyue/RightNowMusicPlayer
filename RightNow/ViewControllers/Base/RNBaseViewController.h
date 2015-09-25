//
//  RNBaseViewController.h
//  RightNow
//
//  Created by 薄荷 on 15/4/15.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNBaseViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *myConnections;

- (void)showWithHUD:(UIView *)view message:(NSString *)message;

- (void)deinit;

- (void)internetErrorSingleTap:(UIGestureRecognizer *)gesture;

- (void)showInternetErrorView;

- (void)hideInternetErrorView;

- (void)showProgressHUD;

- (void)hideProgressHUD;

@end
