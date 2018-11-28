//
//  YYBikeInfoView.m
//  BikeRental
//
//  Created by yunyuchen on 2018/11/28.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYBikeInfoView.h"
#import "YYBikeModel.h"



@interface YYBikeInfoView()<MZTimerLabelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bikeIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimateTripLabel;


@property (weak, nonatomic) IBOutlet UIButton *searchBikeButton;
@property (weak, nonatomic) IBOutlet UIView *discountView;



@end

@implementation YYBikeInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.countDownView.hidden = YES;
        self.countDownHeightCons.constant = 0;
        self.countDownLabel.timerType = MZTimerLabelTypeTimer;
        self.countDownLabel.delegate = self;
        [self.countDownLabel setTimeFormat:@"mm:ss"];
    }
    return self;
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    self.countDownView.hidden = YES;
    self.countDownHeightCons.constant = 0;
}

-(void)setModel:(YYBikeModel *)model
{
    _model = model;
    self.discountView.hidden = model.red == 0;
    self.bikeIdLabel.text = [NSString stringWithFormat:@"ID:%ld",model.deviceid];
    self.distanceLabel.text = model.last_mileage;
}

-(void)setAppModel:(YYAppointmentModel *)appModel
{
    _appModel = appModel;
    self.bikeIdLabel.text = [NSString stringWithFormat:@"%ld",appModel.did];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",appModel.earth_distance];
    self.estimateTripLabel.text = [NSString stringWithFormat:@"%.2f",appModel.last_mileage];
    self.countDownView.hidden = NO;
    self.countDownHeightCons.constant = 0;
}

- (IBAction)appointmentButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYBikeInfoView:didClickAppointmentButton:)]) {
        [self.delegate YYBikeInfoView:self didClickAppointmentButton:sender];
    }
}


- (IBAction)searchButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYBikeInfoView:didClickSearchButton:)]) {
        [self.delegate YYBikeInfoView:self didClickAppointmentButton:sender];
    }
}

@end
