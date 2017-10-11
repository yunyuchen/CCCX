//
//  YYNetStartView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/14.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYNetStartView.h"

@implementation YYNetStartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (IBAction)openButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(NetStartView:didClickOpenButton:)]) {
        [self.delegate NetStartView:self didClickOpenButton:sender];
    }
}

- (IBAction)closeButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(NetStartView:didClickColseButton:)]) {
        [self.delegate NetStartView:self didClickColseButton:sender];
    }
}

- (IBAction)connectBluetoothButtonClick:(id)sender {
//    #define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
//    //宏定义，判断是否是 iOS10.0以上
//    
//    
//    NSString * urlStr = @"App-Prefs:root=Bluetooth";
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
//        if (iOS10) {
//            //iOS10.0以上  使用的操作
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
//        } else
//        {
//            //iOS10.0以下  使用的操作
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//        }
//    }
}

@end
