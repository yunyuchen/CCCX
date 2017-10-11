//
//  YYYSiteModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/15.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYYSiteModel : YYBaseModel

@property (nonatomic, assign) CGFloat last_percent;

@property (nonatomic, assign) CGFloat distance;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger did;

@property (nonatomic, assign) NSInteger deviceid;

@property (nonatomic, assign) CGFloat lon;

@property (nonatomic, assign) NSInteger sid;

@property (nonatomic, assign) CGFloat last_mileage;

@property (nonatomic, assign) CGFloat lat;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *bleid;

@end
