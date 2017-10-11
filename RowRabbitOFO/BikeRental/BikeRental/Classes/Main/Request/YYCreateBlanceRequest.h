//
//  YYCreateBlanceRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYCreateBlanceRequest : YYBaseRequest

@property (nonatomic,assign) NSInteger ptype;

@property (nonatomic,assign) CGFloat price;

@end
