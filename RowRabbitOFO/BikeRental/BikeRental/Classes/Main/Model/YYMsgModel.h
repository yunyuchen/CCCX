//
//  YYMsgModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/7/8.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYMsgModel : YYBaseModel

//content = "\U60a8\U7684\U8f66\U8f86\U5df2\U5f52\U8fd8\U6210\U529f, \U611f\U8c22\U60a8\U4f7f\U7528\U884c\U8fd0\U5154\U51fa\U884c\U7535\U5355\U8f66, \U6b22\U8fce\U4e0b\U6b21\U5149\U4e34";
//ctime = "2017-07-08 16:14:20";
//id = 10;
//state = 0;
//title = "";
//type = 0;
//uid = 4;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *ctime;

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger state;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,copy) NSString *url;

@end
