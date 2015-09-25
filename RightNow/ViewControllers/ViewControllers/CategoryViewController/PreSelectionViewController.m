//
//  PreSelectionViewController.m
//  RightNow
//
//  Created by 薄荷 on 15/4/11.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "PreSelectionViewController.h"
#import "RNCategorySelectionView.h"
#import "MyPlayerViewController.h"
#import "MyConnectionHandler.h"

@interface PreSelectionViewController ()<RNSelectionViewDelegate>
{
    int reconnectFlag;
}

@property (nonatomic,strong) RNCategorySelectionView *myCategorySelectionView;
@property (nonatomic,strong) CategoryIntroductionView *myCategoryIntroView;
@property (nonatomic,strong) NSArray *myCategoryArr;
@property (nonatomic,strong) NSArray *loadSelectionViews;

@property (nonatomic,strong) NSString *myToken;
@property (nonatomic,strong) NSDictionary *myChoosedCategory;

@property (nonatomic,strong) UIImageView *guideView;

@end

@implementation PreSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.myCategoryArr = [NSMutableArray array];
        self.loadSelectionViews = [[NSBundle mainBundle] loadNibNamed:@"RNCategorySelectionView" owner:self options:nil];
        reconnectFlag = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [MyUtils color:ViewBgColor];
    [self getUser];
    [self addMyRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark -- 第一次登陆的时候注册用户

- (void)getUser{
    [self showProgressHUD];
    if ([MyUtils getToken] == nil && [MyUtils getToken].length == 0) {
        self.myToken = [MyUtils createToken];
        [self registerUserConnection];
    }else{
        [self getCategoryConnection];
    }
}


#pragma mark-- 点击网络连接错误页面事件

- (void)internetErrorSingleTap:(UIGestureRecognizer *)gesture{
    [self showProgressHUD];
    [super internetErrorSingleTap:gesture];
    switch (reconnectFlag) {
        case 1:
            [self registerUserConnection];
            break;
        case 2:
            [self getCategoryConnection];
            break;
        case 3:
            [self getMusicListConnection:self.myChoosedCategory];
            break;
        default:
            break;
    }
}

#pragma mark -- 初始化界面元素

- (void)getCurrentCategoryData{
    self.myCategoryArr = [MyUtils getMusicCategoryData];
    [self initWithView];
}

- (void)initWithView
{
    if (self.myCategorySelectionView == nil) {
        self.myCategorySelectionView = self.loadSelectionViews[0];
        self.myCategorySelectionView.center = CGPointMake([MyUtils getScreenWidth] / 2, self.myCategorySelectionView.H / 2 + 92);
        self.myCategorySelectionView.delegate = self;
        [self.view addSubview:self.myCategorySelectionView];
    }
    
    if (self.myCategorySelectionView != nil) {
        [self.myCategorySelectionView setViewWithData:self.myCategoryArr animation:NO];
    }
    
    if (self.myCategoryIntroView == nil) {
        self.myCategoryIntroView = self.loadSelectionViews[1];
        self.myCategoryIntroView.center = CGPointMake( [MyUtils getScreenWidth] / 2 , self.myCategorySelectionView.endY + self.myCategoryIntroView.H / 2 + 35);
        [self.view addSubview:self.myCategoryIntroView];
    }
  
//手势引导1
    if ([MyUtils getIsFirstLaunche]) {
        self.guideView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.guideView setImage:[UIImage imageNamed:@"guide1"]];
        [self.guideView setUserInteractionEnabled:YES];
        [self.view addSubview:self.guideView];
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(guideExit:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        [self.guideView addGestureRecognizer:swipeDown];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideExit:)];
        [self.guideView addGestureRecognizer:singleTap];
    }
}

#pragma mark - 手势事件
- (void)addMyRecognizer
{
    UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeCategoryGroup:)];
    swipDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipDown];
}

- (void)changeCategoryGroup:(UIGestureRecognizer *)gesture
{
    self.myCategoryArr = [MyUtils getMusicCategoryData];
    if (self.myCategorySelectionView != nil) {
        [self.myCategorySelectionView setViewWithData:self.myCategoryArr animation:YES];
    }
}

- (void)guideExit:(UIGestureRecognizer *)gesture{
    [self.guideView removeFromSuperview];
    self.guideView = nil;
}

#pragma mark -- 选择类别代理
- (void)chooseCategory:(NSDictionary *)dic
{
    self.myChoosedCategory = dic;
    NSLog(@"click categoryID:%d",[[dic objectForKey:@"categoryID"] intValue]);
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:CATEGORY_CURRENT];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[dic objectForKey:@"categoryID"] forKey:@"categoryID"];
    [params setObject:[MyUtils getToken] forKey:@"token"];
    [self getMusicListConnection:params];
}


#pragma mark -- 网络连接

- (void)registerUserConnection{//创建用户网络连接
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.myToken forKey:@"token"];
    AFHTTPRequestOperation *operation = [MyConnectionHandler createUserWithParams:dic success:^(id response) {
        [MyUtils saveToken:self.myToken];
        [self getCategoryConnection];
    } failure:^{
        reconnectFlag = 1;
        [self hideProgressHUD];
        [self showInternetErrorView];
    }];
    [self.myConnections addObject:operation];
}

//获取所有类别
- (void)getCategoryConnection{
    AFHTTPRequestOperation *operation = [MyConnectionHandler getCategorySuccess:^(id response) {
        [self getCurrentCategoryData];
        [self hideProgressHUD];
    } failure:^{
        reconnectFlag = 2;
        [self hideProgressHUD];
        [self showInternetErrorView];
    }];
    [self.myConnections addObject:operation];
}


- (void)getMusicListConnection:(NSDictionary *)dic{
    AFHTTPRequestOperation *operation = [MyConnectionHandler getMusicListWithParams:dic success:^(id response) {
        [MyPlayerViewController pushToMyPlayerViewControllerFrom:self WithAnimation:NO];
    } failure:^{
        reconnectFlag = 3;
        [self showInternetErrorView];
    }];
    [self.myConnections addObject:operation];
}
#pragma mark - 清理工作
- (void)deinit
{
    [super deinit];
    self.myCategorySelectionView = nil;
    self.myCategoryIntroView = nil;
    self.myCategoryArr = nil;
    self.loadSelectionViews = nil;
}

@end
