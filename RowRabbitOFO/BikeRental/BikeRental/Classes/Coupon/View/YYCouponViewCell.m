//
//  YYCouponViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/22.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYCouponViewCell.h"
#import <DateTools/DateTools.h>

@interface YYCouponViewCell()

@property (weak, nonatomic) IBOutlet UILabel *couponPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *couponRemarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *couponConditionLabel;

@property (weak, nonatomic) IBOutlet UILabel *outTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *extLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;


@end

@implementation YYCouponViewCell

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

-(void)setModel:(YYCouponModel *)model
{
    _model = model;

    if (model.selected) {
        self.selectedImageView.hidden = NO;
    }else{
        self.selectedImageView.hidden = YES;
    }
    
    self.couponPriceLabel.text = [NSString stringWithFormat:@"%.1f",model.money];
    self.couponConditionLabel.text = [NSString stringWithFormat:@"满%ld元可用",model.condition];
    NSDate *time = [NSDate dateWithString:model.outtime formatString:@"yyyy-MM-dd HH:mm:ss"];
    self.outTimeLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld到期",[time year],[time month],[time day]];
    self.extLabel.text = [NSString stringWithFormat:@"仅剩%ld天",model.lday];
}

@end
