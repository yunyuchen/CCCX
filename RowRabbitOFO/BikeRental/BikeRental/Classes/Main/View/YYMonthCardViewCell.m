//
//  YYMonthCardViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2019/3/30.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import "YYMonthCardViewCell.h"
#import <QMUIKit/QMUIKit.h>

@interface YYMonthCardViewCell()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation YYMonthCardViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.masksToBounds = YES;
}

-(void)setModel:(YYCardModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.des;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.0f",model.price];
    if (model.selected) {
        //self.contentView.backgroundColor = [UIColor qmui_colorWithHexString:@"#FF7700"];
        self.nameLabel.textColor =  [UIColor qmui_colorWithHexString:@"#FF7700"];
        self.priceLabel.textColor =  [UIColor qmui_colorWithHexString:@"#FF7700"];
        self.contentView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#FF7700"].CGColor;
    }else{
        //self.contentView.backgroundColor = [UIColor qmui_colorWithHexString:@"#999999"];
        self.nameLabel.textColor =  [UIColor qmui_colorWithHexString:@"#999999"];
        self.priceLabel.textColor =  [UIColor qmui_colorWithHexString:@"#999999"];
        self.contentView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#999999"].CGColor;
    }
}

@end
