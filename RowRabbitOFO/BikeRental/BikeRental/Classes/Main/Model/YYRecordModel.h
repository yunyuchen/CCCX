//
//  YYRecordModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/24.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYRecordModel : YYBaseModel

//"des": "押金充值",
//"money": "1",
//"ctime": "2017-05-23 15:21:30"

@property (nonatomic,copy) NSString *des;

@property (nonatomic,copy) NSString *money;

@property (nonatomic,copy) NSString *ctime;

@end
