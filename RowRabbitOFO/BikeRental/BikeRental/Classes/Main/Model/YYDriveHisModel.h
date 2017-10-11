//
//  YYDriveHisModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/27.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYDriveHisModel : YYBaseModel

//"price": 0,
//"rname": "科教城",
//"sname": "科教城",
//"ctime": "2017-05-27 10:12:50",
//"keep": 1

@property (nonatomic,assign) CGFloat price;

@property (nonatomic,copy) NSString *rname;

@property (nonatomic,copy) NSString *sname;

@property (nonatomic,copy) NSString *ctime;

@property (nonatomic,assign) NSInteger keep;

@end
