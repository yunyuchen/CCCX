//
//  YYNetStartView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/14.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYNetStartView;
@protocol NetStartViewDelegate <NSObject>

@optional

-(void) NetStartView:(YYNetStartView *)netStartView didClickOpenButton:(UIButton *)openButton;

-(void) NetStartView:(YYNetStartView *)netStartView didClickColseButton:(UIButton *)CloseButton;

-(void) NetStartView:(YYNetStartView *)netStartView didClickConnectBluetoothButton:(UIButton *)ConnectBluetoothButton;

@end

@interface YYNetStartView : UIView

@property (nonatomic,weak) id<NetStartViewDelegate> delegate;

@end
