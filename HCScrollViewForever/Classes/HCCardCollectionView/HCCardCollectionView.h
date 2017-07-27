//
//  HCCardCollectionView.h
//  HCCardCosDemo
//
//  Created by UltraPower on 2017/7/21.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef UICollectionViewCell * (^HCConfigureCell)(UICollectionView *,NSIndexPath *, NSString *);
@interface HCCardCollectionView : UIView
@property (nonatomic, copy) HCConfigureCell configureCell;
@property (nonatomic, assign) CGFloat widthfactor;
@property (nonatomic, assign) CGFloat heightfactor;


- (void) scrollToItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (instancetype)initWithFrame:(CGRect)frame  registerClass:(Class)registerClass isHorizontal:(BOOL)isHorizontal;
- (void) setWidthFactor:(CGFloat)widthfactor heightFactor:(CGFloat)heightfactor;
@end
