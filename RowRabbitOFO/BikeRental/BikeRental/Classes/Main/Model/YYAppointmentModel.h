//
//  YYAppointmentModel.h
//  BikeRental
//
//  Created by yunyuchen on 2018/11/28.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYAppointmentModel : YYBaseModel

//"bid": 610,
//"deviceid": 20602,
//"did": 20602,
//"earth_distance": 16.460807000269213,
//"last_mileage": 0.0,
//"outtime": "2018-11-28 11:19:27"

@property(nonatomic, assign) NSInteger bid;

@property(nonatomic, assign) NSInteger deviceid;

@property(nonatomic, assign) NSInteger did;

@property(nonatomic, assign) CGFloat earth_distance;

@property(nonatomic, assign) CGFloat last_mileage;

@property(nonatomic, copy) NSString *outtime;

@end

NS_ASSUME_NONNULL_END
