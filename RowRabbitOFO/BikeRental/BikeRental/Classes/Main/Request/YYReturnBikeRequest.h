//
//  YYReturnBikeRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/24.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYReturnBikeRequest : YYBaseRequest

@property (nonatomic,assign) NSInteger rsid;

@property(nonatomic, assign) CGFloat error;

@property (nonatomic,assign) CGFloat lng;

@property (nonatomic,assign) CGFloat lat;

@end
