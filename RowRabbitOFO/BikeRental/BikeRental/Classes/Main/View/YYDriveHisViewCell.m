//
//  YYDriveHisViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/27.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYDriveHisViewCell.h"

@interface YYDriveHisViewCell()

@property (weak, nonatomic) IBOutlet UILabel *keepLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *rnameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dnameLabel;


@end

@implementation YYDriveHisViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YYDriveHisModel *)model
{
    _model = model;
    
    self.keepLabel.text = [NSString stringWithFormat:@"%ld小时%ld分",self.model.keep/60,self.model.keep % 60];
    self.rnameLabel.text = model.sname;
    self.dnameLabel.text = model.rname;
    self.timeLabel.text = model.ctime;
}

@end
