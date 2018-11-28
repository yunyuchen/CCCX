//
//  YYBikeInfoView.h
//  BikeRental
//
//  Created by yunyuchen on 2018/11/28.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBikeModel.h"
#import "YYAppointmentModel.h"
#import "MZTimerLabel.h"

NS_ASSUME_NONNULL_BEGIN

@class YYBikeInfoView;
@protocol YYBikeInfoViewDelegate <NSObject>

@optional

- (void) YYBikeInfoView:(YYBikeInfoView *)bikeView didClickAppointmentButton:(UIButton *)button;

- (void) YYBikeInfoView:(YYBikeInfoView *)bikeView didClickSearchButton:(UIButton *)button;

@end

@interface YYBikeInfoView : UIView

@property(nonatomic, strong) YYBikeModel *model;

@property(nonatomic, strong) YYAppointmentModel *appModel;

@property(nonatomic, weak) id<YYBikeInfoViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *countDownView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countDownHeightCons;
@property (weak, nonatomic) IBOutlet MZTimerLabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *appoimentButton;
@end

NS_ASSUME_NONNULL_END
