//
//  YYScanResult.h
//  BikeRental
//
//  Created by yunyuchen on 2017/7/22.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYScanResult : YYBaseModel

@property (nonatomic,copy) NSString *bleid;

@property (nonatomic,assign) NSInteger deviceid;

@property (nonatomic,assign) NSInteger did;

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger isonline;

@property (nonatomic,assign) CGFloat last_mileage;

@property (nonatomic,assign) CGFloat last_percent;

@property (nonatomic,copy) NSString *lat;

@property (nonatomic,copy) NSString *lon;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) NSInteger sid;

@property(nonatomic, copy) NSString *red;

@property(nonatomic, copy) NSString *redmoney;

@end
