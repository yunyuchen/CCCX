//
//  YYArroundAreaRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2018/11/23.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYArroundAreaRequest : YYBaseRequest

@property(nonatomic, assign) CGFloat lat;

@property(nonatomic, assign) CGFloat lng;


@end

NS_ASSUME_NONNULL_END
