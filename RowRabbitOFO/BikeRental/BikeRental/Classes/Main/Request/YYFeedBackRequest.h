//
//  YYFeedBackRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/1.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYFeedBackRequest : YYBaseRequest

@property (nonatomic,copy) NSString *tel;

@property (nonatomic,copy) NSString *des;

@property (nonatomic,copy) NSString *img;

@property(nonatomic, copy) NSString *deviceid;

@property(nonatomic, copy) NSString *ids;

@end
