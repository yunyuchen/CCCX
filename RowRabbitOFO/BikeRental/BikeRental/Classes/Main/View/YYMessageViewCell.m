//
//  YYMessageViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/8.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYMessageViewCell.h"

@interface YYMessageViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end


@implementation YYMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YYMsgModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.ctime;
    self.contentLabel.text = model.content;
}

@end
