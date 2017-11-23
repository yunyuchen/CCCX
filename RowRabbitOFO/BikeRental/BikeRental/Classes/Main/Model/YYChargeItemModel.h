//
//  YYChargeItemModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/10/31.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYChargeItemModel : YYBaseModel

//"content": "送100",
//"title": "充200",
//"price": 200,
//"extprice": 100
@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, assign) CGFloat price;

@property(nonatomic, assign) CGFloat extprice;

@property(nonatomic, assign) NSInteger index;

@property(nonatomic, assign) BOOL selected;

@end
