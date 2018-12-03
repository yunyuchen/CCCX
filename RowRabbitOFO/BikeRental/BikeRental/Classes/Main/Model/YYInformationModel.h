//
//  YYInformationModel.h
//  BikeRental
//
//  Created by yunyuchen on 2018/11/29.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYInformationModel : YYBaseModel

//"cimg": "/htm/cimg.png",
//"ctime": "2018-11-29 09:28:45",
//"id": 1,
//"state": 0,
//"timg": "/htm/timg.png"

@property(nonatomic, copy) NSString *cimg;

@property(nonatomic, copy) NSString *ctime;

@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, assign) NSInteger state;

@property(nonatomic, copy) NSString *timg;


@end

NS_ASSUME_NONNULL_END
