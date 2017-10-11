//
//  YYOrderInfoRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/25.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYOrderInfoRequest : YYBaseRequest

@property (nonatomic,assign) NSInteger rsid;

@property (nonatomic,assign) CGFloat error;

@property (nonatomic,assign) CGFloat lng;

@property (nonatomic,assign) CGFloat lat;

@end
