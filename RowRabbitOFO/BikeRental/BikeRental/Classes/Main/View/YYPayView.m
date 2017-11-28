//
//  YYPayView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/23.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYPayView.h"
#import <BEMCheckBox/BEMCheckBox.h>

@interface YYPayView()


@property (weak, nonatomic) IBOutlet BEMCheckBox *wechatCheckBox;

@property (weak, nonatomic) IBOutlet BEMCheckBox *aliCheckBox;

@property (nonatomic,strong) BEMCheckBox *currentCheckBox;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation YYPayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.frame = frame;
        self.currentCheckBox = self.wechatCheckBox;
        self.payType = 0;
    }
    return self;
}


- (IBAction)selectButtonClick:(BEMCheckBox *)sender {
    [self.currentCheckBox setOn:NO animated:NO];
    [sender setOn:YES animated:YES];
    self.currentCheckBox = sender;
    if (self.currentCheckBox == self.wechatCheckBox) {
        self.payType = 0;
    }else{
        self.payType = 1;
    }
}

- (IBAction)payButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYPayView:didClickPayButton:)]) {
        [self.delegate YYPayView:self didClickPayButton:sender];
    }
    
}

-(void)setPrice:(CGFloat)price
{
    _price = price;
    
    self.priceLabel.text = [NSString stringWithFormat:@"需要支付：%.2f",price];
}


@end
