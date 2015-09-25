//
//  AboutUsViewController.m
//  RightNow
//
//  Created by 薄荷 on 15/4/19.
//  Copyright (c) 2015年 薄荷. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

static AboutUsViewController *instance;

+ (void)pushToAboutUsViewControllerFrom:(UIViewController *)view WithAnimation:(BOOL)animation{
    if (instance == nil) {
        instance = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    }
    [view presentViewController:instance animated:animation completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [MyUtils color:ViewBgColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backToPlayerClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
