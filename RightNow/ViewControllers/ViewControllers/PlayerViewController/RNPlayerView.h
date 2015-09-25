//
//  RNPlayerView.h
//  RightNow
//
//  Created by 薄荷 on 15/4/12.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNCircleProcessBar.h"

@interface RNPlayerView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *playBackGroundImg;
@property (strong, nonatomic) RNCircleProcessBar *processBar;
@property (weak, nonatomic) IBOutlet UILabel *timerView;

- (void)setBackgroundImg:(NSDictionary *)dic;

- (void)setBufferPercent:(CGFloat )bufferPercent;

- (void)setPlayPercent:(CGFloat )playPercent;

- (void)setPause;
- (void)setPlay;

@end


@interface RNSongInfoView : UIView

- (void)setViewWithSongName:(NSString *)name singer:(NSString *)singger;

@end

@interface RNFavoriteButton : UIButton

- (void)setViewWithIsFavorite:(BOOL)isFavorite;

@end

@interface RNShareView : UIView

@end
