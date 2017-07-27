//
//  HCCardCollectionView.m
//  HCCardCosDemo
//
//  Created by UltraPower on 2017/7/21.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import "HCCardCollectionView.h"

@interface HCCardCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionV;
@property (nonatomic, assign) CGFloat beginContentOffSet;
@property (nonatomic, assign) BOOL isHorizontal;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

#define kCollectionViewReuseId @"CardCollectionViewID"
#define kCollectionViewWidth self.bounds.size.width
#define kCollectionViewHeight self.bounds.size.height
@implementation HCCardCollectionView

- (instancetype)initWithFrame:(CGRect)frame  registerClass:(Class)registerClass isHorizontal:(BOOL)isHorizontal
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isHorizontal = isHorizontal;
        [self setup:registerClass];
    }
    return self;
}

- (void)configureFlowLayoutWithWidthFactor:(CGFloat)widthfactor heightFactor:(CGFloat)heightfactor {
    self.flowLayout.scrollDirection = self.isHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    self.flowLayout.itemSize = CGSizeMake(kCollectionViewWidth * widthfactor, kCollectionViewHeight * heightfactor);
    
    self.flowLayout.minimumLineSpacing = self.isHorizontal ? (kCollectionViewWidth - kCollectionViewWidth * widthfactor) / 4.0 : (kCollectionViewHeight - kCollectionViewHeight * heightfactor) / 4.0;
    
    CGFloat inset = self.isHorizontal ? (kCollectionViewWidth - kCollectionViewWidth * widthfactor) / 2.0 : (kCollectionViewHeight - kCollectionViewHeight * heightfactor) / 2.0;
    
    self.flowLayout.sectionInset = self.isHorizontal ? UIEdgeInsetsMake(0, inset, 0, inset) : UIEdgeInsetsMake(inset, 0, inset, 0);

}

- (void)setWidthFactor:(CGFloat)widthfactor heightFactor:(CGFloat)heightfactor {
    if (widthfactor <= 0) {
        widthfactor = self.isHorizontal ? 0.65 : 0.8;
    }
    
    if (heightfactor <= 0) {
        heightfactor = self.isHorizontal ? 0.8 : 0.65;
    }
    
    [self configureFlowLayoutWithWidthFactor:widthfactor heightFactor:heightfactor];
}

- (void)setup:(Class)registerClass {
    // 避免受导航栏的影响而偏移
    [self addSubview:[[UIView alloc] init]];
    CGFloat widthfactor = self.isHorizontal ? 0.65 : 0.8;
    CGFloat heightfactor = self.isHorizontal ? 0.8 : 0.65;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    [self configureFlowLayoutWithWidthFactor:widthfactor heightFactor:heightfactor];
    
    // 添加UICollectionView
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionV = collectionV;
    collectionV.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256) / 255.0) green:(arc4random_uniform(256) / 255.0) blue:(arc4random_uniform(256) / 255.0) alpha:1.0];
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.showsVerticalScrollIndicator = NO;
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.decelerationRate = 0;
    collectionV.pagingEnabled = YES;
    [collectionV registerClass:registerClass forCellWithReuseIdentifier:kCollectionViewReuseId];
    
    [self addSubview:collectionV];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = nil;
    if (self.configureCell) {
         cell = self.configureCell(collectionView,indexPath,kCollectionViewReuseId);
    }
    
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewReuseId forIndexPath:indexPath];
    }
    
    [self calculateCellSize:cell];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self scrollToItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginContentOffSet = self.isHorizontal ? scrollView.contentOffset.x : scrollView.contentOffset.y;
}

// 再拖即将减速或即将接受拖拽是进行计算，如果结束后计算会有一个回复效果，比较难看
// 在WillEndDragging，WillBeginDecelerating计算时在到完全结束有一个过渡，看起来和自然

// WillEndDragging适用于平稳柔和的拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.collectionV.pagingEnabled) return;
    [self reloayout:scrollView];
}

// WillBeginDecelerating适用于较为快速激烈的拖拽，最后会有一个减速的过程
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self reloayout:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSArray *collectionCells = self.collectionV.visibleCells;
    
    for (UICollectionViewCell *cell in collectionCells){
        [self calculateCellSize:cell];
    }
}


// 计算cell的size
- (void)calculateCellSize:(UICollectionViewCell *)cell {
    
    //获取卡片所在index
    //获取ScrollView滚动的位置
    CGFloat scrollOffset = self.isHorizontal ? self.collectionV.contentOffset.x : self.collectionV.contentOffset.y;
    //获取卡片中间位置滚动的相对位置
    CGFloat cardCenterX = self.isHorizontal ? cell.center.x - scrollOffset : cell.center.y - scrollOffset;
    //获取卡片中间位置和父视图中间位置的间距，目标是间距越大卡片越短
    CGFloat apartLength = self.isHorizontal ? fabs(self.bounds.size.width/2.0f - cardCenterX) : fabs(self.bounds.size.height / 2.0f - cardCenterX);
    //移动的距离和屏幕宽度的的比例
    CGFloat apartScale = self.isHorizontal ? apartLength / self.bounds.size.width : apartLength / self.bounds.size.height;
    //把卡片移动范围固定到 -π/4到 +π/4这一个范围内
    CGFloat scale = fabs(cos(apartScale * M_PI/4));
    //设置卡片的缩放
    cell.transform = self.isHorizontal ? CGAffineTransformMakeScale(1.0, scale) : CGAffineTransformMakeScale(scale, 1.0);

}

// item居中显示
- (void)reloayout:(UIScrollView *)scrollView {
    // 在视野中的cell中，计算那个距离中点的距离，最近的就要居中
    NSArray *collectionCells = self.collectionV.visibleCells;
    CGFloat centerX = 0;
    if (self.isHorizontal) {
        centerX = scrollView.contentOffset.x + self.bounds.size.width * 0.5;
    } else {
        centerX = scrollView.contentOffset.y + self.bounds.size.height * 0.5;
    }
    
    CGFloat minDistance = 0;
    UICollectionViewCell *centerCell = nil;
    NSInteger index = 0;
    for (UICollectionViewCell *cell in collectionCells) {
        CGFloat distance = 0;
        if (self.isHorizontal) {
            distance = fabs(centerX - cell.center.x);
        } else {
            distance = fabs(centerX - cell.center.y);
        }
        
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
        UICollectionViewScrollPosition scrollPoisition = self.isHorizontal ? UICollectionViewScrollPositionCenteredHorizontally : UICollectionViewScrollPositionCenteredVertically;
        [self.collectionV scrollToItemAtIndexPath:[self.collectionV indexPathForCell:centerCell] atScrollPosition:scrollPoisition animated:YES];
    }

}

// 滚动到指定的item
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated{
    UICollectionViewScrollPosition scrollPoisition = self.isHorizontal ? UICollectionViewScrollPositionCenteredHorizontally : UICollectionViewScrollPositionCenteredVertically;
    [self.collectionV scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPoisition animated:animated];
}

@end
