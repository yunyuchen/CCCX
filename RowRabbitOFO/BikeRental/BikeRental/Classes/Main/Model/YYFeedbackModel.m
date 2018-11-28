//
//  YYFeedbackModel.m
//  BikeRental
//
//  Created by yunyuchen on 2018/11/23.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYFeedbackModel.h"

@implementation YYFeedbackModel

-(CGFloat)cellHeight
{
    CGFloat normalTop = 79.5;
    CGFloat bottomMargin = 20;
    CGFloat contentHeight = [self.des boundingRectWithSize:CGSizeMake(kScreenWidth - 2 * 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    
    return contentHeight + normalTop + bottomMargin;
}


@end
