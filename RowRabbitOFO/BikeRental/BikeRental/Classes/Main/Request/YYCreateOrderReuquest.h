//
//  YYCreateOrderReuquest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/24.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYCreateOrderReuquest : YYBaseRequest

@property (nonatomic,assign) NSInteger sid;

@property (nonatomic,assign) NSInteger bid;

@property (nonatomic,assign) NSInteger deviceid;

@end
