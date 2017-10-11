//
//  YYActViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/21.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYActViewCell.h"
#import "UIImageView+WebCache.h"

@interface YYActViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *actImageView;

@end

@implementation YYActViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.actImageView.layer.cornerRadius = 4;
    self.actImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YYActModel *)model
{
    _model = model;
    
    [self.actImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,model.img]] placeholderImage:[UIImage imageNamed:@"actP"]];
}

@end
