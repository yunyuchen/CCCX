//
//  YYUserAreaRequest.h
//  BikeRental
//
//  Created by yunyuchen on 2019/1/24.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUserAreaRequest : YYBaseRequest

@property(nonatomic, assign) CGFloat lat;

@property(nonatomic, assign) CGFloat lng;

@end

NS_ASSUME_NONNULL_END
