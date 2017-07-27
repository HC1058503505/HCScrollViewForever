//
//  HCCardScrollView.m
//  HCScrollViewForever
//
//  Created by UltraPower on 2017/7/27.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import "HCCardScrollView.h"

@interface HCCardScrollView ()
@property (nonatomic, weak) UIScrollView *scrollV;

@property (nonatomic, weak) UIImageView *imageLeft;
@property (nonatomic, weak) UIImageView *imageCenter;
@property (nonatomic, weak) UIImageView *imageRight;
@end

@implementation HCCardScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (CGFloat)widthFactor {
    return _widthFactor == 0 ? 0.65 : _widthFactor;
}

- (CGFloat)heightFactor {
    return _heightFactor == 0 ? 0.8 : _heightFactor;
}


- (void)setup {
    // 避免导航栏的影响而下移
    [self addSubview:[[UIView alloc] init]];
    
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollV.contentSize = CGSizeMake(self.bounds.size.width * 3.0, self.bounds.size.height);
    scrollV.pagingEnabled = YES;
    [self addSubview:scrollV];
    
    
    UIImageView *imageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.imageLeft = imageLeft;
    imageLeft.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256) / 255.0) green:(arc4random_uniform(256) / 255.0) blue:(arc4random_uniform(256) / 255.0) alpha:1.0];
    
    [scrollV addSubview:imageLeft];
    
    UIImageView *imageCenter = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    self.imageCenter = imageCenter;
    imageCenter.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256) / 255.0) green:(arc4random_uniform(256) / 255.0) blue:(arc4random_uniform(256) / 255.0) alpha:1.0];
    [scrollV addSubview:imageCenter];
    
    
    UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 2.0, 0, self.bounds.size.width, self.bounds.size.height)];
    imageRight.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256) / 255.0) green:(arc4random_uniform(256) / 255.0) blue:(arc4random_uniform(256) / 255.0) alpha:1.0];
    self.imageRight = imageRight;
    [scrollV addSubview:imageRight];
}

@end
