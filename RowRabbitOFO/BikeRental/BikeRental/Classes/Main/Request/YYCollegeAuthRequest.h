//
//  YYCollegeAuthRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/10/11.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYCollegeAuthRequest : YYBaseRequest

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSString *idcard;

@property(nonatomic, copy) NSString *college;

@property(nonatomic, copy) NSString *colnum;

@property(nonatomic, copy) NSString *img;

@end
