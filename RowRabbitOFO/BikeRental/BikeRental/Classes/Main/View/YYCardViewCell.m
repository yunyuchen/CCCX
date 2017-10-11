//
//  YYCardViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/9/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYCardViewCell.h"

@interface YYCardViewCell()
//卡名称
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
//卡描述
@property (weak, nonatomic) IBOutlet UILabel *cardDescriptionLabel;
//价格标准
@property (weak, nonatomic) IBOutlet UILabel *cardFeeLabel;
//现价
@property (weak, nonatomic) IBOutlet UILabel *cardPriceLabel;
//卡背景
@property (weak, nonatomic) IBOutlet UIImageView *cardBgImageView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation YYCardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 20;
    
    [super setFrame:frame];
}


-(void)setModel:(YYCardModel *)model
{
    _model = model;
    self.cardNameLabel.text = model.name;
    self.cardDescriptionLabel.text = model.content;
    self.cardPriceLabel.text = model.vip;
    self.cardFeeLabel.text = [NSString stringWithFormat:@"限时%@小时/月",model.viphour];
    if ([self.model.name isEqualToString:@"月卡"]) {
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#4CD964"];
    }else if ([self.model.name isEqualToString:@"季卡"]){
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#F98574"];
    }else if ([self.model.name isEqualToString:@"年卡"]){
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#0080FF"];
    }
}


@end
