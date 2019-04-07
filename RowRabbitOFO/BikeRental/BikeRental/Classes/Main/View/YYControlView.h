//
//  YYControlView.h
//  TianYou
//
//  Created by yunyuchen on 2018/1/22.
//  Copyright © 2018年 tianyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import "MZTimerLabel.h"

@class YYControlView,YYRentalModel;
@protocol YYControlViewDelegate<NSObject>

- (void) YYControlView:(YYControlView *)controlView didClickStartButton:(UIButton *)sender;

- (void) YYControlView:(YYControlView *)controlView didClickSoundButton:(UIButton *)sender;

- (void) YYControlView:(YYControlView *)controlView didClickMapButton:(UIButton *)sender;

- (void) YYControlView:(YYControlView *)controlView didClickBluetoothButton:(UIButton *)sender;

- (void) YYControlView:(YYControlView *)controlView didClickReturnButton:(UIButton *)sender;
@end

@interface YYControlView : UIView

@property(nonatomic, weak) id<YYControlViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet QMUIButton *bluetoothButton;

@property(nonatomic, assign) NSInteger bluetoothState;

@property (weak, nonatomic) IBOutlet UILabel *last_mileageLabel;

@property (weak, nonatomic) IBOutlet MZTimerLabel *daysLabel;

@property(nonatomic, strong) YYRentalModel *model;

@property (weak, nonatomic) IBOutlet QMUIButton *mapFindButton;

@property (weak, nonatomic) IBOutlet QMUIButton *soundFindButton;

@property (weak, nonatomic) IBOutlet UILabel *tipStateLabel;
@end
