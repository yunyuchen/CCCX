//
//  YYChargeItemViewCell.h
//  BikeRental
//
//  Created by yunyuchen on 2017/10/31.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYChargeItemModel.h"

@class YYChargeItemViewCell;
@protocol ChargeItemDelegate<NSObject>

- (void) YYChargeItemViewCell:(YYChargeItemViewCell *)cell didClickCurrentButton:(UIButton *)sender;

@end

@interface YYChargeItemViewCell : UICollectionViewCell

@property(nonatomic, strong) YYChargeItemModel *model;

@property(nonatomic, weak)  id<ChargeItemDelegate> delegate;

@end
