//
//  YYReturnScheduleView.h
//  BikeRental
//
//  Created by yunyuchen on 2018/12/3.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YYReturnScheduleView;
@protocol YYReturnScheduleViewDelegate <NSObject>


- (void) YYReturnScheduleView : (YYReturnScheduleView *)scheduleView didClickRetryButton:(UIButton *)button;

- (void) YYReturnScheduleView : (YYReturnScheduleView *)scheduleView didClickBluetoothButton:(UIButton *)button;

@end

@interface YYReturnScheduleView : UIView

@property (weak, nonatomic) IBOutlet UIView *failureView;

@property(nonatomic, weak)  id<YYReturnScheduleViewDelegate> delegate;

- (void) reset;


@end

NS_ASSUME_NONNULL_END
