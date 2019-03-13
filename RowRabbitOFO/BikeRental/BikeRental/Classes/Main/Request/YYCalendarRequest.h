//
//  YYCalendarRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2019/3/8.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYCalendarRequest : YYBaseRequest

@property(nonatomic, assign) int year;

@property(nonatomic, assign) int month;

@end

NS_ASSUME_NONNULL_END
