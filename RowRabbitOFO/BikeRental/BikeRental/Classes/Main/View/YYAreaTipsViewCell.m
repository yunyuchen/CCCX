//
//  YYAreaTipsViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/1.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYAreaTipsViewCell.h"

@interface YYAreaTipsViewCell()

@property (weak, nonatomic) IBOutlet UILabel *poiNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;


@end

@implementation YYAreaTipsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPoi:(NSString *)poi
{
    _poi = poi;
    self.poiNameLabel.text = poi;
}

-(void)setArea:(NSString *)area
{
    _area = area;
    self.areaNameLabel.text = area;
}

@end
