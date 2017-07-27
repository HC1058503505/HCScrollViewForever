//
//  HCCollectionViewCell.h
//  HCCardCosDemo
//
//  Created by UltraPower on 2017/7/21.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HCSelectedCell)(UITapGestureRecognizer *);
@interface HCCollectionForeverViewCell : UICollectionViewCell
@property (nonatomic, copy) HCSelectedCell selectedCell;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *themeName;
@end
