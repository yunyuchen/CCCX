//
//  YYGetYBikeRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/15.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYGetYBikeRequest : YYBaseRequest

@property (nonatomic,assign) NSInteger sid;

@property (nonatomic,assign) CGFloat lon;

@property (nonatomic,assign) CGFloat lat;

@end
