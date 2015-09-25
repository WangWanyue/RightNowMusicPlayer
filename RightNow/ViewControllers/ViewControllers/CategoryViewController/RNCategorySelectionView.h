//
//  RNCategorySelection.h
//  RightNow
//
//  Created by 薄荷 on 15/4/11.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RNSelectionViewDelegate;
@interface RNCategorySelectionView : UIView

@property (nonatomic,strong) id<RNSelectionViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *categoryBtn1;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn2;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn3;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn4;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn5;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn6;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn7;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn8;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn9;


@property (strong, nonatomic) NSArray *myCategoryBtnArr;
@property (strong, nonatomic) NSArray *myCategoryFromArr;
@property (strong, nonatomic) NSArray *myCategoryArr;

- (void)setViewWithData:(NSArray *)arr animation:(BOOL)animation;

@end

@protocol RNSelectionViewDelegate <NSObject>

@optional

- (void)chooseCategory:(NSDictionary *)dic;

@end

@interface CategoryIntroductionView : UIView

@end

@interface NextCategoryGroupsView : UIView

@end
