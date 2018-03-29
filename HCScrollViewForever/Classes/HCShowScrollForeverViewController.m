//
//  HCShowScrollForeverViewController.m
//  HCScrollViewForever
//
//  Created by UltraPower on 2017/7/26.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import "HCShowScrollForeverViewController.h"
#import "HCScrollForeverView.h"
#import "HCCollectionForeverView.h"
#import "HCCollectionForeverViewCell.h"
#import "HCShowImageViewController.h"
#import "HCCardCollectionView.h"
#import "HCCollectionViewCell.h"
#import "HCCardScrollView.h"

@interface HCShowScrollForeverViewController ()
@property (nonatomic, copy) NSArray *imagesGroup;
@property (nonatomic, weak) HCScrollForeverView *scrollV;
@property (nonatomic, weak) HCCollectionForeverView *cardCollectionV;
@end

@implementation HCShowScrollForeverViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.imagesGroup = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    
    if ([self.contentTypeStr isEqualToString:@"HCCollectionForeverView"]) {
        [self setupCollectionForeverView];
    } else if ([self.contentTypeStr isEqualToString:@"HCScrollForeverView"]) {
        [self setupScrollForeverView];
    } else if ([self.contentTypeStr isEqualToString:@"HCCardCollectionView"]){
        [self setupCardCollectionView];
    } else if ([self.contentTypeStr isEqualToString:@"HCCardScrollView"]) {
        [self setupCardScrollView];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.contentTypeStr isEqualToString:@"HCCollectionForeverView"]) {
        [self.cardCollectionV start];
    } else if ([self.contentTypeStr isEqualToString:@"HCScrollForeverView"]) {
        [self.scrollV start];
    } else {
        
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if(([self.navigationController.viewControllers indexOfObject:self] == NSNotFound ||self.navigationController.viewControllers.count == 0) && [self.contentTypeStr isEqualToString:@"HCCollectionForeverView"]){
        [self.cardCollectionV invalid];
        return;
    } else if(([self.navigationController.viewControllers indexOfObject:self] == NSNotFound || self.navigationController.viewControllers.count == 0) && [self.contentTypeStr isEqualToString:@"HCScrollForeverView"]) {
        [self.scrollV invalid];
        return;
    }
    
    if ([self.contentTypeStr isEqualToString:@"HCCollectionForeverView"]) {
        [self.cardCollectionV stop];
    } else if ([self.contentTypeStr isEqualToString:@"HCScrollForeverView"]) {
        [self.scrollV stop];
    }
}

- (void)setupCollectionForeverView {
    HCCollectionForeverView *cardCollectionV = [[HCCollectionForeverView alloc] initWithFrame:CGRectMake(10, 84, self.view.bounds.size.width - 20, 200) registerClass:[HCCollectionForeverViewCell class]];
    self.cardCollectionV = cardCollectionV;
    // 设置Cell
    cardCollectionV.configureCell = ^UICollectionViewCell *(UICollectionView *collection, NSIndexPath *indexP, NSString *reuseId) {
        HCCollectionForeverViewCell *cell = [collection dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexP];
        cell.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256) / 255.0) green:(arc4random_uniform(256) / 255.0) blue:(arc4random_uniform(256) / 255.0) alpha:1.0];
        cell.imageName = self.imagesGroup[indexP.row];
        cell.themeName = @"数字专辑";
        return cell;
    };
    
    __weak typeof(self) weakSelf = self;
    cardCollectionV.selectedItem = ^(NSInteger index) {
        HCShowImageViewController *showVC = [[HCShowImageViewController alloc] init];
        showVC.imageNames = weakSelf.imagesGroup[index];
        [weakSelf presentViewController:showVC animated:YES completion:nil];
    };
    cardCollectionV.imagesGroup = self.imagesGroup;
    [self.view addSubview:cardCollectionV];

}

- (void)setupScrollForeverView {
    HCScrollForeverView *scrollV = [[HCScrollForeverView alloc] initWithFrame:CGRectMake(10, 84, self.view.bounds.size.width - 20, 200)];
    self.scrollV = scrollV;
    scrollV.imagesArray = self.imagesGroup;
    __weak typeof(self) weakSelf = self;
    scrollV.didSelectedItem = ^(NSInteger index) {
        HCShowImageViewController *showVC = [[HCShowImageViewController alloc] init];
        showVC.imageNames = weakSelf.imagesGroup[index];
        [weakSelf presentViewController:showVC animated:YES completion:nil];
    };
    [self.view addSubview:scrollV];
}

- (void)setupCardCollectionView {
    
    HCCardCollectionView *cardCollectionVHoriontal = [[HCCardCollectionView alloc] initWithFrame:CGRectMake(10, 84, self.view.bounds.size.width - 20, 200) registerClass:[HCCollectionViewCell class] isHorizontal:YES];
    [cardCollectionVHoriontal setWidthFactor:-0.8 heightFactor:0.8];
    __weak typeof(self) weakSelf = self;
    // 设置Cell
    cardCollectionVHoriontal.configureCell = ^UICollectionViewCell *(UICollectionView *collection, NSIndexPath *indexP, NSString *reuseId) {
        HCCollectionViewCell *cell = [collection dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexP];
        cell.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256) / 255.0) green:(arc4random_uniform(256) / 255.0) blue:(arc4random_uniform(256) / 255.0) alpha:1.0];
        cell.imageName = weakSelf.imagesGroup[indexP.row];
        return cell;
    };
    
    [self.view addSubview:cardCollectionVHoriontal];
    
    HCCardCollectionView *cardCollectionV = [[HCCardCollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(cardCollectionVHoriontal.frame) + 20, self.view.bounds.size.width - 20, 200) registerClass:[HCCollectionViewCell class]isHorizontal:NO];
//    [cardCollectionV setWidthFactor:0.8 heightFactor:0.65]; 
    // 设置Cell
    cardCollectionV.configureCell = ^UICollectionViewCell *(UICollectionView *collection, NSIndexPath *indexP, NSString *reuseId) {
        HCCollectionViewCell *cell = [collection dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexP];
        cell.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256) / 255.0) green:(arc4random_uniform(256) / 255.0) blue:(arc4random_uniform(256) / 255.0) alpha:1.0];
        cell.imageName = weakSelf.imagesGroup[indexP.row];
        return cell;
    };
    
    [self.view addSubview:cardCollectionV];

}

- (void)setupCardScrollView {
    HCCardScrollView *cardScrollView = [[HCCardScrollView alloc] initWithFrame:CGRectMake(10, 84, self.view.bounds.size.width - 20, 200)];
    [self.view addSubview:cardScrollView];
}
@end
