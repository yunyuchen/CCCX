//
//  YYSelectPayView.m
//  BikeRental
//
//  Created by yunyuchen on 2019/3/30.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import "YYSelectPayView.h"
#import <BEMCheckBox/BEMCheckBox.h>

@interface YYSelectPayView()


@property (weak, nonatomic) IBOutlet BEMCheckBox *wechatCheckBox;

@property (weak, nonatomic) IBOutlet BEMCheckBox *aliCheckBox;

@property (nonatomic,strong) BEMCheckBox *currentCheckBox;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation YYSelectPayView

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
    if ([self.delegate respondsToSelector:@selector(YYSelectPayView:didClickPayButton:)]) {
        [self.delegate YYSelectPayView:self didClickPayButton:sender];
    }
    
}

-(void)setPrice:(CGFloat)price
{
    _price = price;
    
    self.priceLabel.text = [NSString stringWithFormat:@"需要支付：%.2f",price];
}

@end
