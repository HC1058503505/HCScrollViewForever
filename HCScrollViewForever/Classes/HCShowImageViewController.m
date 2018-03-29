//
//  HCShowImageViewController.m
//  HCCardCosDemo
//
//  Created by UltraPower on 2017/7/26.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import "HCShowImageViewController.h"

@interface HCShowImageViewController ()
@property (nonatomic, weak) UIImageView *imageV;
@end

@implementation HCShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon_cross_close"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    btn.frame = CGRectMake(20, 20, 20, 20);
    [self.view addSubview:btn];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 64, self.view.frame.size.width - 40, 200)];
    imageV.backgroundColor = [UIColor orangeColor];
    self.imageV = imageV;
    imageV.image = [UIImage imageNamed:self.imageNames];
    [self.view addSubview:self.imageV];
}

- (void)btnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
