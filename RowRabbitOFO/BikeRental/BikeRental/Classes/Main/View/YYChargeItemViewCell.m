//
//  YYChargeItemViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/10/31.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYChargeItemViewCell.h"
#import <QMUIKit/QMUIKit.h>

@interface YYChargeItemViewCell()

@property (weak, nonatomic) IBOutlet UIButton *chargeButton;

@property (weak, nonatomic) IBOutlet UIImageView *recommendImageView;

@end

@implementation YYChargeItemViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.chargeButton.layer.cornerRadius = 5;
    self.chargeButton.layer.masksToBounds = YES;
    self.chargeButton.layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
    self.chargeButton.layer.borderWidth = 2;
}

-(void)setModel:(YYChargeItemModel *)model
{
    _model = model;
    if (model.index == 0) {
        self.recommendImageView.hidden = NO;
    }else{
        self.recommendImageView.hidden = YES;
    }
    if (model.selected) {
        self.chargeButton.layer.borderColor = [UIColor qmui_colorWithHexString:@"#FF5500"].CGColor;
    }else{
       self.chargeButton.layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
    }
    [self.chargeButton setNeedsDisplay];
    //没有赠送金额
    if (model.extprice == 0) {
        [self.chargeButton setAttributedTitle:nil forState:UIControlStateNormal];
        [self.chargeButton setTitle:model.title forState:UIControlStateNormal];
    }else{
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",model.title,model.content]];
        [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor qmui_colorWithHexString:@"#F08300"]
                    range:NSMakeRange(model.title.length + 1, model.content.length)];
        [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:12]
                    range:NSMakeRange(model.title.length + 1, model.content.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [paragraphStyle setLineSpacing:5];
        [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraphStyle
                    range:NSMakeRange(0, attrStr.length)];
        [self.chargeButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        self.chargeButton.titleLabel.numberOfLines = 0;
    }
    
}

- (IBAction)chargeButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYChargeItemViewCell:didClickCurrentButton:)]) {
        [self.delegate YYChargeItemViewCell:self didClickCurrentButton:sender];
    }
}


@end
