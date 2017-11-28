//
//  YYScoreModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/11/24.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYScoreModel : YYBaseModel

//"uid": 4,
//"id": 32,
//"point": 0,
//"des": "骑行成功还车 +0.5",
//"ctime": "2017-11-23 14:14:12"

@property(nonatomic, assign) NSInteger uid;

@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, assign) NSInteger point;

@property(nonatomic, copy) NSString *des;

@property(nonatomic, copy) NSString *ctime;

@end
