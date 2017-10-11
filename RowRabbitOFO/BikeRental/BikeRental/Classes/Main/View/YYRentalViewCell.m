//
//  YYRentalViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYRentalViewCell.h"

@interface YYRentalViewCell()

//剩余电量
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
//行驶里程
@property (weak, nonatomic) IBOutlet UILabel *driveLabel;
//车辆ID
@property (weak, nonatomic) IBOutlet UILabel *driveIDLabel;


@end


@implementation YYRentalViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YYRentalModel *)model
{
    _model = model;
    
    self.batteryLabel.text = [NSString stringWithFormat:@"%.0f",model.last_percent * 100];
    self.driveLabel.text = [NSString stringWithFormat:@"%.0f",model.last_mileage];
    self.driveIDLabel.text = [NSString stringWithFormat:@"ID:%ld",model.deviceid];
}

@end
