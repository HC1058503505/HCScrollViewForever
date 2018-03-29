//
//  HCScrollForeverView.m
//  HCScrollViewForever
//
//  Created by UltraPower on 2017/7/20.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import "HCScrollForeverView.h"

@interface HCScrollForeverView () <UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *scrollV;

@property (weak,nonatomic) UIImageView *imageVLeft;
@property (weak,nonatomic) UIImageView *imageVCenter;
@property (weak,nonatomic) UIImageView *imageVRight;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat beginDragScrollOffSet;
@property (nonatomic, assign) NSInteger centerImageIndex;
@end

@implementation HCScrollForeverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupTimer];
    }
    return self;
}

- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    if (_imagesArray.count > 0) {
        self.imageVLeft.image = [UIImage imageNamed:self.imagesArray.lastObject];
        self.imageVCenter.image = [UIImage imageNamed:self.imagesArray.firstObject];
        self.imageVRight.image = [UIImage imageNamed:self.imagesArray[1]];
    }
}

- (void)setupUI {
    
    // 避免导航的影响而下移
    [self addSubview:[[UIView alloc] init]];
    
    CGFloat scrollVWidth  = self.frame.size.width;
    CGFloat scrollVHeight = self.frame.size.height;
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollV];
    self.scrollV = scrollV;
    self.currentIndex = 1;
    self.scrollV.contentSize = CGSizeMake(scrollVWidth * 3.0, scrollVHeight);
    self.scrollV.delegate = self;
    self.scrollV.contentOffset = CGPointMake(scrollVWidth, 0);
    self.scrollV.pagingEnabled = YES;
    self.scrollV.showsVerticalScrollIndicator = NO;
    self.scrollV.showsHorizontalScrollIndicator = NO;
    
    UIImageView *imageVLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollVWidth, scrollVHeight)];
    self.imageVLeft = imageVLeft;
    [self.scrollV addSubview:imageVLeft];
    
    UIImageView *imageVCenter = [[UIImageView alloc] initWithFrame:CGRectMake(scrollVWidth, 0, scrollVWidth, scrollVHeight)];
    self.imageVCenter = imageVCenter;
    imageVCenter.userInteractionEnabled = YES;
    [self.scrollV addSubview:imageVCenter];
    
    UIImageView *imageVRight = [[UIImageView alloc] initWithFrame:CGRectMake(scrollVWidth * 2.0, 0, scrollVWidth, scrollVHeight)];
    self.imageVRight = imageVRight;
    [self.scrollV addSubview:imageVRight];

    
    // 添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [imageVCenter addGestureRecognizer:tapGesture];
}

- (void)tapAction {
    if (self.didSelectedItem) {
        self.didSelectedItem(self.centerImageIndex);
    }
}

- (void)setupTimer {
    
    // 改变UIScrollView的contentOffSet
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)timerAction {
    CGFloat scrollVWidth  = self.scrollV.frame.size.width;
    [self.scrollV setContentOffset:CGPointMake(2 * scrollVWidth, 0) animated:YES];
}

- (void)start {
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
}

- (void)stop {
    [self.timer setFireDate:[NSDate distantFuture]];   
}

- (void)invalid {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginDragScrollOffSet = scrollView.contentOffset.x;
    [self stop];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.x - self.beginDragScrollOffSet;
    if (offset > 0) { // 向右
        self.centerImageIndex += 1;
    } else if (offset < 0){ // 向左
        self.centerImageIndex -= 1;
    }
    
    if (self.centerImageIndex < 0) {
        self.centerImageIndex = self.imagesArray.count - 1;
    } else if (self.centerImageIndex > (self.imagesArray.count - 1)) {
        self.centerImageIndex = 0;
    }
    
    [self setImage];
    [self start];
}


// called when setContentOffset
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    self.centerImageIndex += 1;
    if (self.centerImageIndex > self.imagesArray.count - 1) {
        self.centerImageIndex = 0;
    }
    
    [self setImage];
}

- (void)setImage {
    if (self.imagesArray.count == 0) {
        return;
    }
    CGFloat scrollVWidth  = self.scrollV.frame.size.width;
    NSInteger imageIndexRight = (self.centerImageIndex + 1) % self.imagesArray.count;
    NSInteger imageIndexLeft = self.centerImageIndex == 0 ? self.imagesArray.count - 1 : (self.centerImageIndex - 1) % self.imagesArray.count;
    
    self.imageVRight.image = [UIImage imageNamed:self.imagesArray[imageIndexRight]];
    self.imageVCenter.image = [UIImage imageNamed:self.imagesArray[self.centerImageIndex]];
    self.imageVLeft.image = [UIImage imageNamed:self.imagesArray[imageIndexLeft]];
    
    [self.scrollV setContentOffset:CGPointMake(scrollVWidth, 0) animated:NO];
}

- (void)dealloc {
    NSLog(@"%@",self.timer);
}
@end
