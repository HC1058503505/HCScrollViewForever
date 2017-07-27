//
//  HCCollectionViewCell.m
//  HCCardCosDemo
//
//  Created by UltraPower on 2017/7/21.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import "HCCollectionViewCell.h"

@interface HCCollectionViewCell() <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIImageView *imageV;
@end

@implementation HCCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *imageV = [[UIImageView alloc] init];
    self.imageV = imageV;
    imageV.userInteractionEnabled = YES;
    [self.contentView addSubview:imageV];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    tap.delegate = self;
//    [imageV addGestureRecognizer:tap];
}

//- (void)tapAction:(UITapGestureRecognizer *)gesture {
//    if (self.selectedCell) {
//        self.selectedCell(gesture);
//    }
//}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    
//    NSLog(@"%d",CGRectContainsRect(self.superview.frame, [self convertRect:self.frame toView:self.superview]));
//    return YES;
//}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    if (_imageName) {
        self.imageV.image = [UIImage imageNamed:imageName];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageV.frame = self.bounds;
}
@end
