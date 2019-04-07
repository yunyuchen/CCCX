//
//  WeiXinPayModel.h
//  BikeRental
//
//  Created by yunyuchen on 2019/3/23.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeiXinPayModel : NSObject

@property(nonatomic, copy) NSString *partnerid;

@property(nonatomic, copy) NSString *prepayid;

@property(nonatomic, copy) NSString *noncestr;

@property(nonatomic, copy) NSString *timestamp;

@property(nonatomic, copy) NSString *package;

@property(nonatomic, copy) NSString *sign;

@end

NS_ASSUME_NONNULL_END
