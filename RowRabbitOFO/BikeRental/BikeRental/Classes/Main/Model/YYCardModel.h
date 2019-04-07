//
//  YYCardModel.h
//  BikeRental
//
//  Created by yunyuchen on 2019/3/30.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYCardModel : YYBaseModel

@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, assign) CGFloat price;

@property(nonatomic, assign) NSInteger cycle;

@property(nonatomic, copy) NSString *des;

@property(nonatomic, copy) NSString *vip;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) CGFloat discount;
@property(nonatomic, assign) BOOL recommend;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *viphour;
@property(nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
