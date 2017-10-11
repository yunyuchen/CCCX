//
//  YYCreateVipRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/9/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYCreateVipRequest : YYBaseRequest

@property(nonatomic, assign) NSInteger ptype;

@property(nonatomic, assign) NSInteger vipType;

@end
