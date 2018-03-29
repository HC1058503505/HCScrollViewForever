//
//  HCCardCollectionView.m
//  HCCardCosDemo
//
//  Created by UltraPower on 2017/7/21.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import "HCCollectionForeverView.h"
#import "HCCollectionForeverViewCell.h"
@interface HCCollectionForeverView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionV;
@property (nonatomic, assign) CGFloat beginContentOffSet;
@property (nonatomic, assign) NSInteger currentIndexHC;
@property (nonatomic, weak) HCCollectionForeverViewCell *rightCell;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UIPageControl *pageControl;
@end

#define kCollectionViewReuseId @"CardCollectionViewID"
#define kCollectionViewWidth self.bounds.size.width
#define kCollectionViewHeight self.bounds.size.height
@implementation HCCollectionForeverView

- (instancetype)initWithFrame:(CGRect)frame  registerClass:(Class)registerClass
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndexHC = 1;
        [self setup:registerClass];
        [self setupTimer];
    }
    return self;
}

- (void)setupTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] animated:YES];
}

- (void)stop {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)start {
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
}
- (void)invalid {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setup:(Class)registerClass {
    // 避免受导航栏的影响而偏移
    [self addSubview:[[UIView alloc] init]];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(kCollectionViewWidth , kCollectionViewHeight );
    flowLayout.minimumLineSpacing = 0;
    
    
    
    // 添加UICollectionView
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionV = collectionV;
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor whiteColor];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.decelerationRate = 0;
    collectionV.pagingEnabled = YES;
    [collectionV registerClass:registerClass forCellWithReuseIdentifier:kCollectionViewReuseId];
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:NO];
    [self addSubview:collectionV];
    
    
    // 添加pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
    self.pageControl = pageControl;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor orangeColor];
    [self addSubview:pageControl];
}

- (void)setImagesGroup:(NSArray *)imagesGroup {
    _imagesGroup = imagesGroup;
    if (_imagesGroup) {
        self.pageControl.numberOfPages = _imagesGroup.count;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = nil;
    if (self.configureCell) {
         cell = self.configureCell(collectionView,indexPath,kCollectionViewReuseId);
    }
    
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewReuseId forIndexPath:indexPath];
    }
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // itemSpacing = 0
    if (indexPath.row == 0) { // 右边
        NSInteger imageIndexLeft = self.currentIndexHC == 0 ? self.imagesGroup.count - 1 : (self.currentIndexHC - 1) % self.imagesGroup.count;
        HCCollectionForeverViewCell *hcCell = (HCCollectionForeverViewCell *)cell;
        hcCell.imageName = self.imagesGroup[imageIndexLeft];
        
    } else if (indexPath.row == 2) { // 左边
        NSInteger imageIndexRight = (self.currentIndexHC + 1) % self.imagesGroup.count;
        HCCollectionForeverViewCell *hcCell = (HCCollectionForeverViewCell *)cell;
        hcCell.imageName = self.imagesGroup[imageIndexRight];
    }
    
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedItem) {
        self.selectedItem(self.currentIndexHC);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginContentOffSet = scrollView.contentOffset.x;
    [self stop];
}

// 再拖即将减速或即将接受拖拽是进行计算，如果结束后计算会有一个回复效果，比较难看
// 在WillEndDragging，WillBeginDecelerating计算时在到完全结束有一个过渡，看起来和自然
// WillBeginDecelerating适用于较为快速激烈的拖拽，最后会有一个减速的过程
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self reloayout:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self start];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x - self.beginContentOffSet;
    // itemSpacing = 0
    if (x > 0) { // 左
        self.pageControl.currentPage = self.currentIndexHC;
        self.currentIndexHC = self.currentIndexHC + 1 > self.imagesGroup.count - 1 ? 0 : self.currentIndexHC + 1;
    } else if (x < 0){ // 右
        self.currentIndexHC = self.currentIndexHC - 1 < 0 ? self.imagesGroup.count - 1 : self.currentIndexHC - 1;
        
        self.pageControl.currentPage = self.currentIndexHC-1 < 0 ? self.imagesGroup.count - 1:self.currentIndexHC - 1;
    } else {
        return;
    }
    HCCollectionForeverViewCell *centerCell = self.collectionV.visibleCells.firstObject;
    centerCell.imageName = self.imagesGroup[self.currentIndexHC];
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] animated:NO];
    

}



// item居中显示
- (void)reloayout:(UIScrollView *)scrollView {
    // 在视野中的cell中，计算那个距离中点的距离，最近的就要居中
    NSArray *collectionCells = self.collectionV.visibleCells;
    CGFloat centerX = scrollView.contentOffset.x + self.bounds.size.width * 0.5;
    CGFloat minDistance = 0;
    UICollectionViewCell *centerCell = nil;
    NSInteger index = 0;
    for (UICollectionViewCell *cell in collectionCells) {
        CGFloat distance = fabs(centerX - cell.center.x);
        
        if (index == 0) {
            centerCell = cell;
            minDistance = distance;
        } else {
            if (minDistance > distance) {
                centerCell = cell;
                minDistance = distance;
            }
        }
        
        index ++;
    }
    

    if (centerCell) {
        [self scrollToItemAtIndexPath:[self.collectionV indexPathForCell:centerCell] animated:YES];
    }

}

// 滚动到指定的item
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated{

    [self.collectionV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

@end
