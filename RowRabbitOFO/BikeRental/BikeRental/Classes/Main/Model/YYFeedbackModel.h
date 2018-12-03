//
//  YYFeedbackModel.h
//  BikeRental
//
//  Created by yunyuchen on 2018/11/23.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYFeedbackModel : YYBaseModel

@property(nonatomic, copy) NSString *img2;

@property(nonatomic, copy) NSString *img1;

@property(nonatomic, copy) NSString *des;

@property(nonatomic, copy) NSString *tel;

@property(nonatomic, assign) NSInteger state;

@property(nonatomic, copy) NSString *stateStr;

@property(nonatomic, copy) NSString *img;

@property(nonatomic, copy) NSString *type;

@property(nonatomic, copy) NSString *ctime;

@property(nonatomic, assign) NSInteger deviceid;

@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *pdes;

@property(nonatomic, copy) NSString *ptel;

@property(nonatomic, copy) NSString *ptime;

@property(nonatomic, assign) CGFloat cellHeight;

@property(nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
