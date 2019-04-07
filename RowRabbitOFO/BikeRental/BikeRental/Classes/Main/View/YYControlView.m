//
//  YYControlView.m
//  TianYou
//
//  Created by yunyuchen on 2018/1/22.
//  Copyright © 2018年 tianyou. All rights reserved.
//

#import "YYControlView.h"
#import "YYFileCacheManager.h"
#import "YYRentalModel.h"
#import "KKPopTooltip.h"
#import <DateTools/DateTools.h>

@interface YYControlView()




@end

@implementation YYControlView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.mapFindButton.imagePosition = QMUIButtonImagePositionTop;
        self.mapFindButton.spacingBetweenImageAndTitle = 3;
        self.soundFindButton.imagePosition = QMUIButtonImagePositionTop;
        self.soundFindButton.spacingBetweenImageAndTitle = 3;
        self.bluetoothButton.imagePosition = QMUIButtonImagePositionTop;
        self.bluetoothButton.spacingBetweenImageAndTitle = 6;
        self.daysLabel.timeFormat = @"HH:mm";
        self.daysLabel.shouldCountBeyondHHLimit = YES;
//        if ([YYFileCacheManager readUserDataForKey:kSwitchState] != nil) {
//            if ([[YYFileCacheManager readUserDataForKey:kSwitchState] isEqualToString:@"1"]) {
//               
//                
//            }else{
//               
//            }
//           
//        }
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

-(void)setModel:(YYRentalModel *)model
{
    _model = model;
    if (self.model.ctime != nil) {
        NSDate *startDate = [NSDate dateWithString:self.model.ctime formatString:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval time = [[NSDate date] secondsFrom:startDate];
        [self.daysLabel setCountDownTime:time];
    }
    [self.daysLabel start];
    self.last_mileageLabel.text = [NSString stringWithFormat:@"%.2f",model.last_mileage];
}

- (IBAction)startButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(YYControlView:didClickStartButton:)]) {
        [self.delegate YYControlView:self didClickStartButton:sender];
    }
}
- (IBAction)soundButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYControlView:didClickSoundButton:)]) {
        [self.delegate YYControlView:self didClickSoundButton:sender];
    }
}

- (IBAction)mapButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYControlView:didClickMapButton:)]) {
        [self.delegate YYControlView:self didClickMapButton:sender];
    }
}

- (IBAction)bluetoothButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYControlView:didClickBluetoothButton:)]) {
        [self.delegate YYControlView:self didClickBluetoothButton:sender];
    }
}

- (IBAction)returnButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYControlView:didClickReturnButton:)]) {
        [self.delegate YYControlView:self didClickReturnButton:sender];
    }
}

@end
