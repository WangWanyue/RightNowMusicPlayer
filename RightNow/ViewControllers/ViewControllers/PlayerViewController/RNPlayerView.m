//
//  RNPlayerView.m
//  RightNow
//
//  Created by 薄荷 on 15/4/12.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "RNPlayerView.h"

@interface RNPlayerView()

@property (nonatomic,strong) NSDictionary *categoryDic;

@end

@implementation RNPlayerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.processBar = [[RNCircleProcessBar alloc] initWithFrame:self.frame];
    [self addSubview:self.processBar];
}

- (void)setBackgroundImg:(NSDictionary *)dic{
    self.categoryDic = dic;
    [self setPlay];
}

- (void)setPlay
{
    int categoryID = [[self.categoryDic objectForKey:@"categoryID"] intValue];
    if (categoryID == -1) {
        self.playBackGroundImg.hidden = YES;
        self.timerView.hidden = NO;
    }else if(categoryID == -2){
        self.playBackGroundImg.hidden = NO;
        self.timerView.hidden = YES;
        [self.playBackGroundImg setImage:[UIImage imageNamed:@"myFavoriteImg"]];
    }else{
        self.playBackGroundImg.hidden = NO;
        self.timerView.hidden = YES;
        NSString *url = [NSString stringWithFormat:
                         @"%@/%@@2x.png",basePlayPicUrl,
                         [self.categoryDic objectForKey:@"categoryImgUrl"]];
        [self.playBackGroundImg setImageWithURL:[NSURL URLWithString:url]];
    }

}

- (void)setPause
{
    self.timerView.hidden = YES;
    self.playBackGroundImg.hidden = NO;
    [self.playBackGroundImg setImage:[UIImage imageNamed:@"playPauseImg"]];
}

- (void)setBufferPercent:(CGFloat )bufferPercent
{
    [self.processBar setBufferProcessPercent:bufferPercent];
}

- (void)setPlayPercent:(CGFloat )playPercent
{
    [self.processBar setPlayProcessPercent:playPercent];
}

@end


#pragma mark -- 歌曲名和歌手名
@interface RNSongInfoView()

@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singgerLabel;

@end

@implementation RNSongInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setViewWithSongName:(NSString *)name singer:(NSString *)singger
{
    [self.songNameLabel setText:name];
    [self.singgerLabel setText:singger];
}
@end

#pragma mark -- 喜欢按钮

@implementation RNFavoriteButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setViewWithIsFavorite:(BOOL)isFavorite
{
    self.selected = isFavorite;
}

- (void)buttonClicked:(UIButton *)button
{
    self.selected = !self.selected;
}

@end

#pragma mark - 分享
@interface RNShareView()

@end

@implementation RNShareView

- (void)awakeFromNib
{
    [super awakeFromNib];
}
@end