//
//  YYWalletViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/18.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYWalletViewCell.h"

@interface YYWalletViewCell()

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end


@implementation YYWalletViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YYRecordModel *)model
{
    _model = model;
    
    self.desLabel.text = model.des;
    self.timeLabel.text = model.ctime;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",model.money];
}

@end
