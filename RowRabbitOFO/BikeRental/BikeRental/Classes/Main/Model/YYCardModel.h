//
//  YYCardModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/9/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYCardModel : YYBaseModel

//cycle = 90;
//des = "\U94bb\U77f3";
//discount = "7.8";
//id = 3;
//price = 299;
@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy) NSString *viphour;

@property(nonatomic, copy) NSString *vip;

@property(nonatomic, copy) NSString *name;

@property(nonatomic, assign) CGFloat price;

@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, assign) CGFloat discount;

@property(nonatomic, copy) NSString *des;

@property(nonatomic, assign) NSInteger cycle;

@property(nonatomic, assign) BOOL recommend;

@end
