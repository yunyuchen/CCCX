//
//  YYBuyRecordModel.h
//  ShanHaWan
//
//  Created by yunyuchen on 2018/12/24.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYBuyRecordModel : YYBaseModel

@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, copy) NSString *des;

@property(nonatomic, assign) CGFloat price;

@property(nonatomic, copy) NSString *ctime;

@end

NS_ASSUME_NONNULL_END
