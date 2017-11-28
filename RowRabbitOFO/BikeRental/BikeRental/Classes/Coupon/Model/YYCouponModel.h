//
//  YYCouponModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/11/24.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYCouponModel : YYBaseModel

@property(nonatomic, assign) NSInteger uid;

@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, assign) NSInteger lday;

@property(nonatomic, assign) NSInteger condition;

@property(nonatomic, assign) NSInteger state;

@property(nonatomic, assign) CGFloat money;

@property(nonatomic, assign) NSInteger couid;

@property(nonatomic, copy) NSString *outtime;

@property(nonatomic, assign) BOOL selected;

@end
