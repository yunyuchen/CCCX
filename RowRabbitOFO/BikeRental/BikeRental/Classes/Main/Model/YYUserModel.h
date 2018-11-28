//
//  YYUserModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/24.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYUserModel : YYBaseModel

@property (nonatomic,assign) CGFloat needDeposit;

@property (nonatomic,assign) CGFloat deposit;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *tel;

@property (nonatomic,assign) NSInteger state;

@property (nonatomic,assign) CGFloat money;

@property (nonatomic,copy) NSString *idcard;

@property (nonatomic,copy) NSString *hasorder;

@property (nonatomic,assign) NSInteger dstate;

@property (nonatomic,assign) CGFloat totalkeep;

@property (nonatomic,assign) NSInteger zmstate;

@property (nonatomic,assign) NSInteger ID;

@property(nonatomic, assign) NSInteger vip;

@property(nonatomic, copy) NSString *outtime;

@property(nonatomic, assign) NSInteger authtype;

@property(nonatomic, assign) NSInteger xstate;

@property(nonatomic, assign) NSInteger cstate;

@property(nonatomic, assign) BOOL vipstate;

@property(nonatomic, assign) NSInteger abid;

@property(nonatomic, copy) NSString *aouttime;

@end
