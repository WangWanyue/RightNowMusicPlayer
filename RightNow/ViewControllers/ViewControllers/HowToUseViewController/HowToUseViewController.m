//
//  HowToUseViewController.m
//  RightNow
//
//  Created by 薄荷 on 15/4/18.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "HowToUseViewController.h"

@interface HowToUseViewController ()

@end

@implementation HowToUseViewController

static HowToUseViewController *instance;

+ (void)pushToHowToUseViewControllerFrom:(UIViewController *)view WithAnimation:(BOOL)animation{
    if (instance == nil) {
        instance = [[HowToUseViewController alloc] initWithNibName:@"HowToUseViewController" bundle:nil];
    }
    [view presentViewController:instance animated:animation completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
