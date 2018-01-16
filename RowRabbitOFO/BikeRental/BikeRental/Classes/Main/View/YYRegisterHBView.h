//
//  YYRegisterHBView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/30.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYRegisterHBView;
@protocol RegisterHBViewDelegate <NSObject>

-(void) YYRegisterHBView:(YYRegisterHBView *)registerHBView didClickOKButton:(UIButton *)okButton;

@end

@interface YYRegisterHBView : UIView

typedef void(^okBlock)();

@property (nonatomic,weak) id<RegisterHBViewDelegate> delegate;

@property (nonatomic,copy) okBlock block;

@property(nonatomic, assign) BOOL fromLogin;

@property (nonatomic,assign) CGFloat price;

@end
