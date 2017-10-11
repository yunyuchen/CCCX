//
//  YYRecommendViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/21.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYRecommendViewCell.h"

@interface YYRecommendViewCell()

@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property (weak, nonatomic) IBOutlet UILabel *keelLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;




@end

@implementation YYRecommendViewCell

NSString *cellId = @"YYRecommendViewCell";
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
    YYRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        if (kScreenHeight <= 568) {
            cell.nameLabel.font = [UIFont systemFontOfSize:10];
            cell.keelLabel.font = [UIFont systemFontOfSize:14];
            cell.label1.font = [UIFont systemFontOfSize:8];
            cell.label2.font = [UIFont systemFontOfSize:8];
            cell.idLabel.font = [UIFont systemFontOfSize:12];
        }
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
    if ([self.delegate respondsToSelector:@selector(RecommendViewCell:didClickUseButton:)]) {
        [self.delegate RecommendViewCell:self didClickUseButton:sender];
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
    self.nameLabel.text = model.name;
}

-(void)setSiteModel:(YYYSiteModel *)siteModel
{
    _siteModel = siteModel;
    
    self.idLabel.text = [NSString stringWithFormat:@"ID:%ld",(long)siteModel.deviceid];
    self.keelLabel.text = [NSString stringWithFormat:@"%.0f",siteModel.last_mileage];
    self.nameLabel.text = siteModel.name;
}

@end
