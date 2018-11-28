//
//  YYSiteModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/22.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYSiteModel : YYBaseModel

//address = "\U5e38\U5dde\U79d1\U6559\U57ce\U56fd\U9645\U521b\U65b0\U57fa\U5730510\U5927\U9053";
//count = 1;
//distance = "21.10105603022349";
//id = 33;
//img1 = "/upload/site/20170906/yuls.jpg";
//latitude = "31.680724";
//longitude = "119.968802";
//name = "2A1302\U529e\U516c\U5ba4";
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) CGFloat distance;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) CGFloat longitude;

@property (nonatomic,assign) CGFloat latitude;

@property (nonatomic,copy) NSString *img1;

@property(nonatomic, assign) NSInteger red;

@end
