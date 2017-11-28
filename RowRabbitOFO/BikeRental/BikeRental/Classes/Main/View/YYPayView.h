//
//  YYPayView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/11/23.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPayView;

@protocol YYPayViewDelegate<NSObject>

@optional

- (void) YYPayView:(YYPayView *)payView didClickPayButton:(UIButton *)sender;

@end


@interface YYPayView : UIView

@property(nonatomic, assign) CGFloat price;

@property(nonatomic, assign) NSInteger payType;

@property(nonatomic, assign) NSInteger vipId;

@property(nonatomic, weak) id<YYPayViewDelegate> delegate;



@end
