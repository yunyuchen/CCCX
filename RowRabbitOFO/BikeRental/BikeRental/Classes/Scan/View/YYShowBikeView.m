//
//  YYShowBikeView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/22.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYShowBikeView.h"

@interface YYShowBikeView()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *IDLabel;

@property (weak, nonatomic) IBOutlet UILabel *last_mileageLabel;


@end

@implementation YYShowBikeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setResult:(YYScanResult *)result
{
    _result = result;
    
    self.nameLabel.text = result.name;
    self.IDLabel.text = [NSString stringWithFormat:@"ID:%ld",(long)result.deviceid];
    self.last_mileageLabel.text = [NSString stringWithFormat:@"%.1f",result.last_mileage];
}

- (IBAction)okButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYShowBikeView:didClickOKButton:)]) {
        [self.delegate YYShowBikeView:self didClickOKButton:sender];
    }
}

- (IBAction)cancelButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYShowBikeView:didClickCancelButton:)]) {
        [self.delegate YYShowBikeView:self didClickCancelButton:sender];
    }
}

- (IBAction)feeButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYShowBikeView:didClickFeeButton:)]) {
        [self.delegate YYShowBikeView:self didClickFeeButton:sender];
    }
}


@end
