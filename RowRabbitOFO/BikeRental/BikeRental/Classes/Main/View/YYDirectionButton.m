//
//  YYDirectionButton.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/15.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYDirectionButton.h"

@implementation YYDirectionButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.width = self.width * 0.4;
    self.imageView.height = self.width * 0.4;
    self.imageView.centerX = self.width * 0.5;
    self.imageView.centerY = self.height * 0.45;
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.width, self.height - CGRectGetMaxY(self.imageView.frame));
    self.titleLabel.textAlignment =  NSTextAlignmentCenter;

}

@end
