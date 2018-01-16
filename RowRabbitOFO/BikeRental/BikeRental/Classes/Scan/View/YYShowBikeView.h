//
//  YYShowBikeView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/7/22.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYScanResult.h"

@class YYShowBikeView;
@protocol ShowBikeViewDelegate <NSObject>

-(void) YYShowBikeView:(YYShowBikeView *)showBikeView didClickCancelButton:(UIButton *)cancelButton;

-(void) YYShowBikeView:(YYShowBikeView *)showBikeView didClickOKButton:(UIButton *) okButton;

-(void) YYShowBikeView:(YYShowBikeView *)showBikeView didClickFeeButton:(UIButton *) okButton;
@end

@interface YYShowBikeView : UIView

@property (nonatomic,strong) YYScanResult *result;

@property (nonatomic,weak) id<ShowBikeViewDelegate> delegate;

@end
