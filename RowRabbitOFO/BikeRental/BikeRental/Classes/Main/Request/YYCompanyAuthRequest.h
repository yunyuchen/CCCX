//
//  YYCompanyAuthRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/11/28.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYCompanyAuthRequest : YYBaseRequest

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSString *idcard;

@property(nonatomic, copy) NSString *company;

@property(nonatomic, copy) NSString *comnum;

@property(nonatomic, copy) NSString *comimg;

@end
