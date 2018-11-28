//
//  YYReturnResultModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/25.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYReturnResultModel : YYBaseModel

@property (nonatomic,assign) CGFloat price;

@property (nonatomic,assign) NSInteger keep;

@property (nonatomic,assign) CGFloat extPrice;

@property (nonatomic,assign) CGFloat longitude;

@property (nonatomic,assign) CGFloat latitude;

@property(nonatomic, assign) CGFloat vip;

@property(nonatomic, copy) NSString *outtime;

@property(nonatomic, assign) BOOL vipstate;

@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy) NSString *des;

@property(nonatomic, assign) NSInteger cid;

@property(nonatomic, assign) CGFloat money;

@property(nonatomic, assign) CGFloat weekcut;

@property(nonatomic, assign) CGFloat movebike;

@property(nonatomic, assign) CGFloat insurance;

@property(nonatomic, assign) NSInteger reds;

@property(nonatomic, assign) CGFloat redSite;

@property(nonatomic, assign) NSInteger red;

@property(nonatomic, assign) CGFloat redBike;

@end
