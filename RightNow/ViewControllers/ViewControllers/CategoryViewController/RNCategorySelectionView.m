//
//  RNCategorySelection.m
//  RightNow
//
//  Created by 薄荷 on 15/4/11.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "RNCategorySelectionView.h"

@interface RNCategorySelectionView(){
    CGRect preFrame;
}

@end

@implementation RNCategorySelectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (self.myCategoryBtnArr == nil) {
        self.myCategoryBtnArr = [NSArray arrayWithObjects:
                                 self.categoryBtn1,
                                 self.categoryBtn2,
                                 self.categoryBtn3,
                                 self.categoryBtn4,
                                 self.categoryBtn6,
                                 self.categoryBtn7,
                                 self.categoryBtn8,
                                 self.categoryBtn5,
                                 self.categoryBtn9,nil];
    }
    self.myCategoryArr = [NSArray array];
    self.myCategoryFromArr = [NSArray array];
}

//参数传递（下拉刷新类别动画）
- (void)setViewWithData:(NSArray *)arr animation:(BOOL)animation
{
    [self setAllBtnVisable];
    self.myCategoryFromArr = self.myCategoryArr;
    self.myCategoryArr = arr;
    NSURL *imageUrl = nil;
    if ( animation == NO ) {
        UIButton *tempBtn;
        for (int i = 0 ;i < self.myCategoryArr.count ; i ++) {
            tempBtn = self.myCategoryBtnArr[i];
            imageUrl = [NSURL URLWithString:[NSString stringWithFormat:
                                             @"%@/%@@2x.png",baseCateIconUrl,
                                             [self.myCategoryArr[i] objectForKey:@"categoryImgUrl"]]];
            [tempBtn setBackgroundImageForState:UIControlStateNormal withURL:imageUrl];
            [tempBtn setAlpha:1.0];
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            UIButton *tempBtn;
            for (int i = 0 ;i < self.myCategoryArr.count ; i ++) {
                tempBtn = self.myCategoryBtnArr[i];
                [tempBtn setAlpha:0.0];
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                UIButton *tempBtn;
                NSURL *image = nil;
                for (int i = 0 ;i < self.myCategoryArr.count ; i ++) {
                    tempBtn = self.myCategoryBtnArr[i];
                    image = [NSURL URLWithString:[NSString stringWithFormat:
                                                     @"%@/picture/category/%@@2x.png",baseUrl,
                                                     [self.myCategoryArr[i] objectForKey:@"categoryImgUrl"]]];
                    [tempBtn setBackgroundImageForState:UIControlStateNormal withURL:image];
                    [tempBtn setAlpha:1.0];
                }
            }];
        }];
    }
}

//点击类别动画
- (IBAction)categoryBtnClicked:(UIButton *)sender {
    [UIView animateWithDuration:1.0 animations:^{
        for (UIButton *tempBtn in self.myCategoryBtnArr) {
            if (tempBtn == sender) {
                sender.center = CGPointMake(self.W / 2, self.H / 2);
                continue;
            }
            [tempBtn setAlpha:0.0];
        }
    } completion:^(BOOL finished) {
        [self performSelector:@selector(animationDelay:) withObject:sender afterDelay:1.0];
    }];
}

- (void)animationDelay:(UIButton *)sender
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (sender == self.categoryBtn5) {//选中此刻
        [dic setObject:@-1 forKey:@"categoryID"];
    }else if (sender == self.categoryBtn9){//选中我最喜欢
        [dic setObject:@-2 forKey:@"categoryID"];
    }else{
        dic = self.myCategoryArr[sender.tag - 1001];
    }
    if ([self.delegate respondsToSelector:@selector(chooseCategory:)]) {
        [self.delegate performSelector:@selector(chooseCategory:) withObject:dic];
    }
}

- (void)setAllBtnVisable{
    for (UIButton *tempBtn in self.myCategoryBtnArr) {
        [tempBtn setAlpha:1.0];
    }
}

@end

@implementation CategoryIntroductionView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end

@implementation NextCategoryGroupsView

- (void)awakeFromNib
{
    [super awakeFromNib];
}
@end
