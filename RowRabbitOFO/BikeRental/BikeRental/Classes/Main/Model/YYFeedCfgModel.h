//
//  YYFeedCfgModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/12/6.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@class YYCfgSubModel;
@interface YYFeedCfgModel : YYBaseModel

@property(nonatomic, copy) NSString *type;

@property(nonatomic, strong) NSArray<YYCfgSubModel *> *value;

@end

@interface YYCfgSubModel:YYBaseModel


@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, copy) NSString *des;

@property(nonatomic, assign) NSInteger type;

@end
