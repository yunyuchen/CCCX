//
//  YYBikeInfoViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/14.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBikeInfoViewCell.h"

@interface YYBikeInfoViewCell()

@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property (weak, nonatomic) IBOutlet UILabel *keelLabel;

@end

@implementation YYBikeInfoViewCell

NSString *ID = @"BikeInfoViewCell";
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    YYBikeInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)useButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bikeInfoViewCell:didClickUseButton:)]) {
        [self.delegate bikeInfoViewCell:self didClickUseButton:sender];
    }
}


-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 5;
    [super setFrame:frame];
}

-(void)setModel:(YYRentalModel *)model
{
    _model = model;
    
    self.idLabel.text = [NSString stringWithFormat:@"ID:%ld",(long)model.deviceid];
    self.keelLabel.text = [NSString stringWithFormat:@"%.0f",model.last_mileage];

}

@end
