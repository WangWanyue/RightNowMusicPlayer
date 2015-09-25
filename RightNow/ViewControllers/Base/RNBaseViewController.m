//
//  RNBaseViewController.m
//  RightNow
//
//  Created by 薄荷 on 15/4/15.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "RNBaseViewController.h"
#import "RNInternetErrorView.h"

@interface RNBaseViewController ()

@property (nonatomic,strong) RNInternetErrorView *myIEView;

@property (nonatomic,strong) MBProgressHUD *myprogressHUD;

@end

@implementation RNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myConnections = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)internetErrorSingleTap:(UIGestureRecognizer *)gesture{
    [self hideInternetErrorView];
}

//错误页面生命初始化
- (void)showInternetErrorView{
    if (self.myIEView == nil) {
        self.myIEView = [RNInternetErrorView instanceRNInternetErrorView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(internetErrorSingleTap:)];
        [self.myIEView addGestureRecognizer:singleTap];
    }
    self.myIEView.hidden = NO;
    [self.view addSubview:self.myIEView];
}

- (void)hideInternetErrorView{
    self.myIEView.hidden = YES;
}

//文字提示框（like／取消like）
- (void)showWithHUD:(UIView *)view message:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

//圆形提示框（loading）
- (void)showProgressHUD{
    self.myprogressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.myprogressHUD.mode = MBProgressHUDModeIndeterminate;
    self.myprogressHUD.margin = 10.f;
    self.myprogressHUD.removeFromSuperViewOnHide = YES;
}

- (void)hideProgressHUD{
    self.myprogressHUD.hidden = YES;
}

- (void)dealloc
{
    [self deinit];
}

- (void)deinit
{
    //断开网络连接
    for (AFHTTPRequestOperation *operation in self.myConnections) {
        [operation cancel];
    }
    self.myConnections = nil;
}

@end
