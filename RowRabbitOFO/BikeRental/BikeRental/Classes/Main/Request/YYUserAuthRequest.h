//
//  YYUserAuthRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/23.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYUserAuthRequest : YYBaseRequest

@property (nonatomic,copy) NSString *idcard;

@property (nonatomic,copy) NSString *name;

@end
