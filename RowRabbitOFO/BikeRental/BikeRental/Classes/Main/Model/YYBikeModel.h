//
//  YYBikeModel.h
//  BikeRental
//
//  Created by yunyuchen on 2018/3/3.
//  Copyright © 2018年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYBikeModel : YYBaseModel

//bleid = G2AF600003220E5XH;
//"curr_milleage" = 0;
//deviceid = 3220;
//did = 3220;
//discount = 0;
//isonline = 1;
//"last_mileage" = "5.41";
//"last_percent" = "0.13223934";
//lat = "31.6804851987304";
//lon = "119.969173835711";
//name = "";
//state = 0;
//"total_milleage" = 0;

@property(nonatomic, copy) NSString *bleid;

@property(nonatomic, assign) NSInteger curr_milleage;

@property(nonatomic, assign) NSInteger deviceid;

@property(nonatomic, assign) NSInteger did;

@property(nonatomic, assign) NSInteger discount;

@property(nonatomic, assign) NSInteger isonline;

@property(nonatomic, copy) NSString *last_mileage;

@property(nonatomic, copy) NSString *last_percent;

@property(nonatomic, assign) CGFloat lat;

@property(nonatomic, assign) CGFloat lon;

@property(nonatomic, copy) NSString *name;

@property(nonatomic, assign) NSInteger state;

@property(nonatomic, copy) NSString *total_milleage;

@property(nonatomic, copy) NSString *redBike;

@property(nonatomic, assign) CGFloat userLat;

@property(nonatomic, assign) CGFloat userLon;

@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, assign) NSInteger red;

@end
