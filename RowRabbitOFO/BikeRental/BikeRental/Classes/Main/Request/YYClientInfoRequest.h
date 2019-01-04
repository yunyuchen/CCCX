//
//  YYClientInfoRequest.h
//  ShanHaWan
//
//  Created by yunyuchen on 2018/12/28.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYClientInfoRequest : YYBaseRequest

@property(nonatomic, copy) NSString *model;

@property(nonatomic, copy) NSString *osver;

@property(nonatomic, copy) NSString *appver;

@end

NS_ASSUME_NONNULL_END
