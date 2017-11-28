//
//  YYMemberCardViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/22.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYMemberCardViewCell.h"

@interface YYMemberCardViewCell()

//推荐
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
//卡名称
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
//折扣
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//价格
@property (weak, nonatomic) IBOutlet UIButton *priceButton;

@end

@implementation YYMemberCardViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // init 时做的事情请写在这里
    }
    return self;
}

- (void)updateCellAppearanceWithIndexPath:(NSIndexPath *)indexPath {
    [super updateCellAppearanceWithIndexPath:indexPath];
    // 每次 cellForRow 时都要做的事情请写在这里
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

-(void)setModel:(YYCardModel *)model
{
    _model = model;
    if (model.recommend) {
        self.recommendButton.hidden = NO;
    }else{
        self.recommendButton.hidden = YES;
    }
    self.cardNameLabel.text = model.des;
    self.discountLabel.text = [NSString stringWithFormat:@"%.1f折",model.discount];
    self.timeLabel.text = [NSString stringWithFormat:@"%ld天内到期",model.cycle];
    [self.priceButton setTitle:[NSString stringWithFormat:@"¥ %.0f",model.price] forState:UIControlStateNormal];
    
}

- (IBAction)priceButtonClick:(id)sender {
    if (self.priceClickBlock) {
        self.priceClickBlock();
    }
}


@end
