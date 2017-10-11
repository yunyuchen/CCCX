//
//  YYWalkDetailView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/13.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYWalkDetailView.h"

@class YYWalkDetailView;
@interface YYWalkDetailView()

@property (weak, nonatomic) IBOutlet UIButton *siteNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property (weak, nonatomic) IBOutlet UILabel *keepLabel;

@end

@implementation YYWalkDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
         self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds= YES;
}

- (IBAction)rentalButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(YYWalkDetailView:didClickRentalButton:)]){
        [self.delegate YYWalkDetailView:self didClickRentalButton:sender];
    }
}

- (IBAction)addressButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(walkDetail:didClickAddressButton:)]) {
        [self.delegate walkDetail:self didClickAddressButton:sender];
    }
}

-(void)setModel:(YYYSiteModel *)model
{
    _model = model;
    [self.siteNameLabel setTitle:model.name forState:UIControlStateNormal];
    if (model.distance < 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"距离:%.2fM",model.distance];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"距离:%.2fKM",model.distance / 1000.0];
    }
    
    self.idLabel.text = [NSString stringWithFormat:@"ID:%ld",(long)model.deviceid];
    self.keepLabel.text = [NSString stringWithFormat:@"%.0f",model.last_mileage];
}



@end
