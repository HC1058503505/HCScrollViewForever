//
//  HCCardCollectionView.h
//  HCCardCosDemo
//
//  Created by UltraPower on 2017/7/21.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef UICollectionViewCell * (^HCConfigureCell)(UICollectionView *,NSIndexPath *, NSString *);
typedef void(^HCDidSelectedItem)(NSInteger);
@interface HCCollectionForeverView : UIView
@property (nonatomic, copy) HCConfigureCell configureCell;
@property (nonatomic, copy) HCDidSelectedItem selectedItem;
@property (nonatomic, copy) NSArray *imagesGroup;

- (instancetype)initWithFrame:(CGRect)frame  registerClass:(Class)registerClass;
- (void)invalid;
- (void)start;
- (void)stop;
@end
