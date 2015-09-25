//
//  MyPlayerViewController.m
//  RightNow
//
//  Created by 薄荷 on 15/4/11.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "MyPlayerViewController.h"
#import "RNPlayerView.h"
#import "FXBlurView.h"
#import "RNCategorySelectionView.h"
#import "RNRoundRectButton.h"
#import "HowToUseViewController.h"
#import "AboutUsViewController.h"
#import "DOUAudioStreamer.h"
#import "MusicModel.h"
#import "MyConnectionHandler.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface MyPlayerViewController ()<UIGestureRecognizerDelegate,RNSelectionViewDelegate>
{
    BOOL isPause;
    int musicIndex;//音乐的顺序问题
    int guideInex;
}

//播放器界面元素
@property (strong,nonatomic) UIView *myPlayerLayer;
@property (strong,nonatomic) RNPlayerView *myPlayerView;
@property (strong,nonatomic) RNSongInfoView *mySongInfoView;
@property (strong,nonatomic) RNFavoriteButton *myFavoriteButton;
@property (nonatomic,strong) UIImageView *guideView;
//下拉选择类别界面元素
@property (strong,nonatomic) FXBlurView *blurSelectionLayer;
@property (strong,nonatomic) RNCategorySelectionView *myCategorySelectionView;
//上拉选择分享的界面元素
@property (strong,nonatomic) FXBlurView *blurShareLayer;
@property (strong,nonatomic) RNShareView *myShareView;
@property (strong,nonatomic) RNRoundRectButton *myIntroductionBtn;
@property (strong,nonatomic) RNRoundRectButton *aboutUsBtn;
//下拉以及上拉界面载入数组
@property (strong,nonatomic) NSArray *loadPalyerNidArr;
@property (strong,nonatomic) NSArray *loadSelectionNidArr;
//界面数据信息
@property (strong,nonatomic) NSArray *myCategoryArr;
@property (strong,nonatomic) NSArray *musicArr;
@property (strong,nonatomic) NSTimer *progressTimer;
//流媒体播放器
@property (strong,nonatomic) DOUAudioStreamer *myDSPlayer;
@property (strong,nonatomic) NSNumber *currentMusicID;
//时间
@property (strong,nonatomic) NSTimer *systemTimer;
@property (strong,nonatomic) NSDateFormatter *format;

@end

@implementation MyPlayerViewController

static MyPlayerViewController *instance;

+ (void)pushToMyPlayerViewControllerFrom:(UIViewController *)view WithAnimation:(BOOL)animation
{
    if (instance == nil) {
        instance = [[MyPlayerViewController alloc] initWithNibName:@"MyPlayerViewController" bundle:nil];
    }
    [view presentViewController:instance animated:animation completion:nil];
}

//初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.loadPalyerNidArr = [[NSBundle mainBundle] loadNibNamed:@"RNPlayerView" owner:self options:nil];
        self.loadSelectionNidArr = [[NSBundle mainBundle] loadNibNamed:@"RNCategorySelectionView" owner:self options:nil];
        self.musicArr = [NSArray array];
        self.myCategoryArr = [NSArray array];
        guideInex = 0;
    }
    return self;
}

//生命周期中布局的方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [MyUtils color:ViewBgColor];
    self.myPlayerLayer = [[UIView alloc] initWithFrame:self.view.frame];
    self.myPlayerLayer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.myPlayerLayer];
    [self addMyRecognizer];
    [self initWithMyPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化播放界面

- (void)initWithView
{
    if (self.myPlayerView == nil) {
        self.myPlayerView = self.loadPalyerNidArr[0];
        self.myPlayerView.center = CGPointMake([MyUtils getScreenWidth]/2 ,self.myPlayerView.H / 2 + 110 );
        [self.myPlayerLayer addSubview:self.myPlayerView];
    }
    NSDictionary *currentCategory = [[NSUserDefaults standardUserDefaults] objectForKey:CATEGORY_CURRENT];
    if ([[currentCategory objectForKey:@"categoryID"] intValue]  == -1) {
        if (self.systemTimer == nil) {
            self.systemTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        }
        if (self.systemTimer != nil) {
            [self.systemTimer setFireDate:[NSDate date]];
        }
    }else{
        //[self.view setBackgroundColor:[MyUtils color:ViewBgColor]];
        [self.systemTimer setFireDate:[NSDate distantFuture]];
    }
    if (self.myPlayerView != nil) {
        [self.myPlayerView setBackgroundImg:currentCategory];
    }
    
    if (self.mySongInfoView == nil) {
        self.mySongInfoView = self.loadPalyerNidArr[1];
        self.mySongInfoView.center = CGPointMake([MyUtils getScreenWidth]/2 , self.myPlayerView.endY + self.mySongInfoView.H/2 + 30);
        [self.myPlayerLayer addSubview:self.mySongInfoView];
    }
    
    if (self.myFavoriteButton == nil) {
        self.myFavoriteButton = self.loadPalyerNidArr[2];
        self.myFavoriteButton.center = CGPointMake([MyUtils getScreenWidth]/2, self.mySongInfoView.endY + self.myFavoriteButton.H/2 + 45);
        [self.myFavoriteButton addTarget:self action:@selector(favoriteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.myPlayerLayer addSubview:self.myFavoriteButton];
    }
    
    //手势操作引导页面    
    if ([MyUtils getIsFirstLaunche] && guideInex == 0) {
        guideInex ++;
        self.guideView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.guideView setImage:[UIImage imageNamed:@"guide2"]];
        [self.guideView setUserInteractionEnabled:YES];
        [self.view addSubview:self.guideView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideExit:)];
        [self.guideView addGestureRecognizer:singleTap];
    }
}

- (void)initWithMyPlayer{
    self.musicArr = [MyUtils getMusicData];
    if (self.musicArr.count > 0) {
        [self initWithView];
        musicIndex = 0;
        isPause = false;
        [self playMusic];
    }
}

- (void)updateTime:(NSTimer *)timer{
    _format = [[NSDateFormatter alloc] init];
    [_format setDateFormat:@"HH:mm:ss"];
    NSString *timeStr = [_format stringFromDate:[NSDate date]];
    if (self.myPlayerView.timerView != nil) {
        [self.myPlayerView.timerView setText:timeStr];
    }
}

#pragma mark-- 流媒体播放器操作
//播放音乐
- (void)playMusic{
    MusicModel *mm = self.musicArr[musicIndex % self.musicArr.count];
    [self.mySongInfoView setViewWithSongName:mm.musicTitle singer:mm.artist];
    self.currentMusicID = [mm.musicID copy];
    
    [self getIsFavoriteConnection];
    
    self.myDSPlayer = [DOUAudioStreamer streamerWithAudioFile:mm];
    NSLog(@"musicID:%@  musicIndex:%d",mm.musicID,musicIndex);
    [self.myDSPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [self.myDSPlayer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [self.myDSPlayer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
    [self.myDSPlayer play];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 24.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    musicIndex ++;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//播放状态（暂停／播放／结束／下一曲／错误）
- (void)updateStatus
{
    switch ([self.myDSPlayer status]) {
        case DOUAudioStreamerPlaying:
            [self.myPlayerView setPlay];
            isPause = false;
            break;
            
        case DOUAudioStreamerPaused:
            [self.myPlayerView setPause];
            isPause = true;
            break;
            
        case DOUAudioStreamerIdle:
            break;
            
        case DOUAudioStreamerFinished:
            [self cancelStreamer];
            [self playMusic];
            break;
            
        case DOUAudioStreamerBuffering:
            break;
            
        case DOUAudioStreamerError:
            break;
    }
}

- (void)updateBufferingStatus
{
    [self.myPlayerView setBufferPercent:[self.myDSPlayer bufferingRatio]];
    NSLog(@"bufferPercent:%f", [self.myDSPlayer bufferingRatio]);
    if ([self.myDSPlayer bufferingRatio] >= 1.0) {
        NSLog(@"sha256: %@", [self.myDSPlayer sha256]);
    }
}

//播放时长 进度条
- (void)timerAction:(id)timer
{
    if ([self.myDSPlayer duration] == 0.0) {
        [self.myPlayerView setPlayPercent:0.0];
    }
    else {
        [self.myPlayerView setPlayPercent:[self.myDSPlayer currentTime] / [self.myDSPlayer duration]];
    }
}

- (void)cancelStreamer
{
    if (self.myDSPlayer != nil) {
        [self.myDSPlayer pause];
        [self.myDSPlayer removeObserver:self forKeyPath:@"status"];
        [self.myDSPlayer removeObserver:self forKeyPath:@"duration"];
        [self.myDSPlayer removeObserver:self forKeyPath:@"bufferingRatio"];
        self.myDSPlayer = nil;
    }
    if (self.progressTimer != nil) {
        [self.progressTimer setFireDate:[NSDate distantFuture]];
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}


#pragma mark - 播放界面手势
//添加手势
- (void)addMyRecognizer
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playLayerDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.myPlayerLayer addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playLayerSingleTap:)];
    [self.myPlayerView addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playLayerSwipLeft:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.myPlayerLayer addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playLayerSwipRight:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myPlayerLayer addGestureRecognizer:swipRight];
    
    UISwipeGestureRecognizer *swipUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playLayerSwipUp:)];
    swipUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.myPlayerLayer addGestureRecognizer:swipUp];
    
    UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playLayerSwipDown:)];
    swipDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.myPlayerLayer addGestureRecognizer:swipDown];
}

- (void)guideExit:(UIGestureRecognizer *)gesture{
    [self.guideView removeFromSuperview];
    self.guideView = nil;
}

- (void)playLayerSingleTap:(UIGestureRecognizer *)gesture
{
    NSLog(@"Single Tap");
}

- (void)playLayerDoubleTap:(UIGestureRecognizer *)gesture
{
    NSLog(@"Double Tap");
    if (self.myDSPlayer == nil) {
        return;
    }
    isPause = !isPause;
    if (isPause == YES) {
        [self.myPlayerView setPause];
        [self.myDSPlayer pause];
    }
    else{
        [self.myPlayerView setPlay];
        [self.myDSPlayer play];
    }
    
}

//左滑
- (void)playLayerSwipLeft:(UIGestureRecognizer *)gesture
{
    NSLog(@"Swip Left");
    if (self.musicArr.count < 1) {
        return;
    }
    //切换歌曲动画
    [UIView animateWithDuration:0.5f animations:^{
        self.myPlayerView.center = CGPointMake(- [MyUtils getScreenWidth] / 2, self.myPlayerView.H / 2 + 110);
    } completion:^(BOOL finished) {
        self.myPlayerView.center = CGPointMake([MyUtils getScreenWidth] * 3/2, self.myPlayerView.H / 2 + 110);
        [UIView animateWithDuration:0.5f animations:^{
            self.myPlayerView.center = CGPointMake([MyUtils getScreenWidth] / 2, self.myPlayerView.H / 2 + 110);
            [self cancelStreamer];
            [self playMusic];
        }];
    }];
}

//右滑
- (void)playLayerSwipRight:(UIGestureRecognizer *)gesture
{
    NSLog(@"Swip Right");
    if (self.musicArr.count < 1) {
        return;
    }
    [UIView animateWithDuration:0.5f animations:^{
        self.myPlayerView.center = CGPointMake([MyUtils getScreenWidth] * 3/2, self.myPlayerView.H / 2 + 110);
    } completion:^(BOOL finished) {
        self.myPlayerView.center = CGPointMake(- [MyUtils getScreenWidth] / 2, self.myPlayerView.H / 2 + 110);
        [UIView animateWithDuration:0.5f animations:^{
            self.myPlayerView.center = CGPointMake([MyUtils getScreenWidth] / 2, self.myPlayerView.H / 2 + 110);
            [self cancelStreamer];
            [self playMusic];
        }];
    }];
}

//上滑
- (void)playLayerSwipUp:(UIGestureRecognizer *)gesture
{
    NSLog(@"Swip Up");
    [self initShareView];
}

- (void)playLayerSwipDown:(UIGestureRecognizer *)gesture
{
    NSLog(@"Swip Down");
    [self initWithSelectionView];
}

//点击like按钮
- (void)favoriteBtnClicked:(UIButton *)button{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.currentMusicID forKey:@"musicID"];
    [dic setObject:[MyUtils getToken] forKey:@"token"];
    AFHTTPRequestOperation *operation = [MyConnectionHandler setFavoriteWithParams:dic success:^(id response) {
        [self showWithHUD:self.myPlayerLayer message:[response objectForKey:@"result"]];
    } failure:^{
        
    }];
    [self.myConnections addObject:operation];
}

#pragma mark - 下拉选择层界面
- (void)initWithSelectionView //初始化
{
    self.myCategoryArr = [MyUtils getMusicCategoryData];
    
    if (self.blurSelectionLayer == nil) {
        self.blurSelectionLayer = [[FXBlurView alloc] init];
        self.blurSelectionLayer.tintColor = [MyUtils color:ViewBgColor];
        self.blurSelectionLayer.blurRadius = 20.0;
        [self.view addSubview:self.blurSelectionLayer];
    }
    if (self.blurSelectionLayer != nil) {
        self.blurSelectionLayer.frame = [MyUtils getTopFrame:self.view.frame];
    }
    [self.blurSelectionLayer setBlurEnabled:YES];
    
    if (self.myCategorySelectionView == nil) {
        self.myCategorySelectionView = self.loadSelectionNidArr[0];
        self.myCategorySelectionView.center = CGPointMake([MyUtils getScreenWidth]/2, self.myCategorySelectionView.H/2 + 102);
        self.myCategorySelectionView.delegate = self;
    }
    
    if (self.myCategorySelectionView != nil) {
        [self.myCategorySelectionView setViewWithData:self.myCategoryArr animation:NO];
        [self.blurSelectionLayer addSubview:self.myCategorySelectionView];
    }
    
    [self addSelectionRecognizer];
    
    [RNSpringAnimationManager
     popSringAnimationView:self.blurSelectionLayer
     FromValue:[NSValue valueWithCGRect:self.blurSelectionLayer.frame]
     ToValue:[NSValue valueWithCGRect:self.view.frame]
     WithAnimationName:@"SelectionViewAppearAnimation"];
}

#pragma mark 选择类别层手势操作

- (void)addSelectionRecognizer
{
    UISwipeGestureRecognizer *swipUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectionLayerSwipUp:)];
    swipUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.blurSelectionLayer addGestureRecognizer:swipUp];
    
    UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectionLayerSwipDown:)];
    swipDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.blurSelectionLayer addGestureRecognizer:swipDown];
}

//上划回到主界面
- (void)selectionLayerSwipUp:(UIGestureRecognizer *)gesture
{
    [self removeWithSelectionView:YES];
}


//下滑刷新类别
- (void)selectionLayerSwipDown:(UIGestureRecognizer *)gesture
{
    self.myCategoryArr = [MyUtils getMusicCategoryData];
    [self.myCategorySelectionView setViewWithData:self.myCategoryArr animation:YES];
}

#pragma mark 选择类别代理
- (void)chooseCategory:(NSDictionary *)dic
{//点击类别按钮
    NSLog(@"click categoryID:%d",[[dic objectForKey:@"categoryID"] intValue]);
    [self removeWithSelectionView:NO];
    NSNumber *fromCategoryID =
    [[[NSUserDefaults standardUserDefaults] objectForKey:CATEGORY_CURRENT] objectForKey:@"categoryID"];
    NSNumber *toCategoryID = [dic objectForKey:@"categoryID"];
    if (fromCategoryID.intValue == toCategoryID.intValue) {
        //do nothing
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:toCategoryID forKey:@"categoryID"];
        [params setObject:[MyUtils getToken] forKey:@"token"];
        AFHTTPRequestOperation *operation = [MyConnectionHandler getMusicListWithParams:params success:^(id response) {
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:CATEGORY_CURRENT];
            [self cancelStreamer];
            [self initWithMyPlayer];
        } failure:^{
        }];
        [self.myConnections addObject:operation];
    }
}

#pragma mark- 选择类别层下拉动画

- (void)removeWithSelectionView:(BOOL)animation
{
    if (animation == YES) {
        [RNSpringAnimationManager
         popSringAnimationView:self.blurSelectionLayer
         FromValue:[NSValue valueWithCGRect:self.blurSelectionLayer.frame]
         ToValue:[NSValue valueWithCGRect:[MyUtils getTopFrame:self.view.frame]]
         WithAnimationName:@"SelectionViewDisAppearAnimation"];

    }else
    {
        self.blurSelectionLayer.center = CGPointMake([MyUtils getScreenWidth] / 2, -[MyUtils getScreenHeight] / 2);
    }
    //取消高斯模糊！！！！
    [self.blurSelectionLayer setBlurEnabled:NO];
}

#pragma mark - 分享层（播放界面上拉）

- (void)initShareView
{
    if (self.blurShareLayer == nil) {
        self.blurShareLayer = [[FXBlurView alloc] init];
        //self.blurShareLayer.backgroundColor = [UIColor clearColor];
        self.blurShareLayer.tintColor = [MyUtils color:ViewBgColor];
        self.blurShareLayer.blurRadius = 20.0;
        self.blurShareLayer.frame = [MyUtils getButtomFrame:self.view.frame];
        [self.view addSubview:self.blurShareLayer];
    }
    [self.blurShareLayer setBlurEnabled:YES];
    if (self.myShareView == nil) {
        self.myShareView = self.loadPalyerNidArr[3];
        self.myShareView.center = CGPointMake([MyUtils getScreenWidth]/2, self.myShareView.H/2 + 223);
        [self.blurShareLayer addSubview:self.myShareView];
    }
    
    if (self.myIntroductionBtn == nil) {
        self.myIntroductionBtn = [RNRoundRectButton btnWithBackgroung:@"howToUseBtn"];
        self.myIntroductionBtn.center = CGPointMake([MyUtils getScreenWidth]/2, self.myShareView.endY + self.myIntroductionBtn.H/2 + 125);
        [self.myIntroductionBtn addTarget:self action:@selector(toHowToUseUsVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.blurShareLayer addSubview:self.myIntroductionBtn];
    }
    
    if (self.aboutUsBtn == nil) {
        self.aboutUsBtn = [RNRoundRectButton btnWithBackgroung:@"aboutusBtn"];
        self.aboutUsBtn.center = CGPointMake([MyUtils getScreenWidth]/2, self.myIntroductionBtn.endY + self.aboutUsBtn.H/2 + 19);
        [self.aboutUsBtn addTarget:self action:@selector(toAboutUsVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.blurShareLayer addSubview:self.aboutUsBtn];
    }
    
    UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shareLayerSwipDown:)];
    swipDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.blurShareLayer addGestureRecognizer:swipDown];
    
    [RNSpringAnimationManager
     popSringAnimationView:self.blurShareLayer
     FromValue:[NSValue valueWithCGRect:self.blurShareLayer.frame]
     ToValue:[NSValue valueWithCGRect:self.view.frame]
     WithAnimationName:@"ShareViewAppearAnimation"];
}

- (void)shareLayerSwipDown:(NSNotification *)notification
{
    [self removeShareView];
}

- (void)removeShareView
{
    [RNSpringAnimationManager
        popSringAnimationView:self.blurShareLayer
     FromValue:[NSValue valueWithCGRect:self.blurShareLayer.frame]
     ToValue:[NSValue valueWithCGRect:[MyUtils getButtomFrame:self.view.frame]]
     WithAnimationName:@"ShareViewDisAppearAnimation"];
    [self.blurShareLayer setBlurEnabled:NO];
}

- (void)toHowToUseUsVC:(UIButton *)button{
    [self removeShareView];
    [HowToUseViewController pushToHowToUseViewControllerFrom:self WithAnimation:NO];
}

- (void)toAboutUsVC:(UIButton*)button{
    [self removeShareView];
    [AboutUsViewController pushToAboutUsViewControllerFrom:self WithAnimation:NO];
}

#pragma mark-- 网络连接

- (void)getIsFavoriteConnection{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.currentMusicID forKey:@"musicID"];
    [dic setObject:[MyUtils getToken] forKey:@"token"];
    AFHTTPRequestOperation *operation = [MyConnectionHandler getIsFavoriteWithParams:dic success:^(id response) {
        NSDictionary *result = response;
        if ([[result objectForKey:@"result"] isEqualToString:@"success"]) {
            if (self.myFavoriteButton != nil) {
                [self.myFavoriteButton setSelected:YES];
            }
        }else if([[result objectForKey:@"result"] isEqualToString:@"failure"]){
            if (self.myFavoriteButton != nil) {
                [self.myFavoriteButton setSelected:NO];
            }
        }
    } failure:^{
        //do nothing
    }];
    [self.myConnections addObject:operation];
}

#pragma mark -- 释放内存

- (void)deinit{
    [super deinit];
    self.myPlayerView = nil;
    self.mySongInfoView = nil;
    self.myFavoriteButton = nil;
    self.myPlayerLayer = nil;
    
    self.myCategorySelectionView = nil;
    self.blurSelectionLayer = nil;
    
    self.myShareView = nil;
    self.myIntroductionBtn = nil;
    self.aboutUsBtn = nil;
    self.blurShareLayer = nil;
    
    self.loadPalyerNidArr = nil;
    self.loadSelectionNidArr = nil;
    
    self.myCategoryArr = nil;
    self.musicArr = nil;
    self.progressTimer = nil;
    [self cancelStreamer];

}

@end
