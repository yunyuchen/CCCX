//
//  YYReturnScheduleView.m
//  BikeRental
//
//  Created by yunyuchen on 2018/12/3.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYReturnScheduleView.h"
#import "DALabeledCircularProgressView.h"
#import <QMUIKit/QMUIKit.h>

@interface YYReturnScheduleView()

@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation YYReturnScheduleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.progressView.trackTintColor =[UIColor qmui_colorWithHexString:@"#FFC732"];
        self.progressView.progressTintColor = [UIColor whiteColor];
        self.progressView.innerTintColor = [UIColor qmui_colorWithHexString:@"#FBB157"];
        self.progressView.thicknessRatio = 0.2;
        self.progressView.progressLabel.font = [UIFont boldSystemFontOfSize:40];
        //[self.progressView setProgress:1 animated:YES initialDelay:0 withDuration:10];
        self.progressView.layer.shadowColor = [UIColor redColor].CGColor;
        self.progressView.layer.shadowOffset = CGSizeMake(0, -3);
        self.progressView.layer.shadowRadius = 3;
        self.containerView.layer.cornerRadius = 110;
        self.containerView.layer.masksToBounds = YES;
        self.progressView.progressLabel.text = @"0%";
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
      
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(change) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void) change
{
    [self.progressView setProgress:self.progressView.progress + 0.01];
    self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",self.progressView.progress * 100];
}

- (IBAction)retryButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYReturnScheduleView:didClickRetryButton:)]) {
        [self.delegate YYReturnScheduleView:self didClickRetryButton:sender];
    }
}

- (IBAction)bluetoothButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYReturnScheduleView:didClickBluetoothButton:)]) {
        [self.delegate YYReturnScheduleView:self didClickBluetoothButton:sender];
    }
}


-(void)reset
{
    self.progressView.progress = 0;
    self.progressView.progressLabel.text = @"0%";
}


@end
