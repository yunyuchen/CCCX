//
//  YYMemberCardViewCell.h
//  BikeRental
//
//  Created by yunyuchen on 2017/11/22.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "YYCardModel.h"

@interface YYMemberCardViewCell : QMUITableViewCell

@property(nonatomic, strong) YYCardModel *model;

@property(nonatomic, copy) void (^priceClickBlock)(void);

@end
