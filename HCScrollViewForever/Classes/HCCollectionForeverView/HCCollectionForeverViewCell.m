//
//  HCCollectionViewCell.m
//  HCCardCosDemo
//
//  Created by UltraPower on 2017/7/21.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import "HCCollectionForeverViewCell.h"

@interface HCCollectionForeverViewCell() <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *themeLabel;
@end

@implementation HCCollectionForeverViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // 图片
    UIImageView *imageV = [[UIImageView alloc] init];
    self.imageV = imageV;
    [self.contentView addSubview:imageV];

    
    // 标签
    UILabel *themeLabel = [[UILabel alloc] init];
    self.themeLabel = themeLabel;
    themeLabel.backgroundColor = [UIColor blackColor];
    themeLabel.hidden = YES;
    themeLabel.font = [UIFont systemFontOfSize:13];
    themeLabel.textAlignment = NSTextAlignmentCenter;
    themeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:themeLabel];
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    if (_imageName) {
        self.imageV.image = [UIImage imageNamed:imageName];
    }
}

- (void)setThemeName:(NSString *)themeName {
    _themeName = themeName;
    if (_themeName) {
        self.themeLabel.hidden = NO;
        self.themeLabel.text = themeName;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageV.frame = self.bounds;
    CGSize size = [self.themeName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
    self.themeLabel.frame = CGRectMake(self.frame.size.width - size.width - 10, 10, size.width + 10, 20);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.themeLabel.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.themeLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.themeLabel.layer.mask = maskLayer;
}
@end
