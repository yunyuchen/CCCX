//
//  YYRegisterHBView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/30.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYRegisterHBView.h"

@interface YYRegisterHBView()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation YYRegisterHBView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (IBAction)okButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYRegisterHBView:didClickOKButton:)]) {
        [self.delegate YYRegisterHBView:self didClickOKButton:sender];
    }
    if (self.block) {
        self.block();
    }
    
}

-(void)setPrice:(CGFloat)price
{
    _price = price;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.0f",price];
    
    self.titleLabel.text = @"分享成功";
    
    self.desLabel.hidden = YES;
}


@end
