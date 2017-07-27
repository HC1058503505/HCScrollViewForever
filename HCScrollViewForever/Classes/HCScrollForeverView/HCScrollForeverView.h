//
//  HCScrollForeverView.h
//  HCScrollViewForever
//
//  Created by UltraPower on 2017/7/20.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HCDidSelectedItem)(NSInteger);
@interface HCScrollForeverView : UIView
@property (nonatomic, copy) NSArray *imagesArray;
@property (nonatomic, copy) HCDidSelectedItem didSelectedItem;
- (void)start;
- (void)stop;
- (void)invalid;
@end
