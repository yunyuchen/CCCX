//
//  YYCardModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/9/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYCardModel : YYBaseModel

//"content": "随开随用 去哪都方便",
//"viphour": "90",
//"vip": "499",
//"name": "季卡"
@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy) NSString *viphour;

@property(nonatomic, copy) NSString *vip;

@property(nonatomic, copy) NSString *name;

@end
