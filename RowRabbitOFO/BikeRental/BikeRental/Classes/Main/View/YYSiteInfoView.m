//
//  YYSiteInfoView.m
//  BikeRental
//
//  Created by yunyuchen on 2018/11/27.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYSiteInfoView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YYSiteInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}


-(void)setModel:(YYSiteModel *)model
{
    _model = model;
    self.siteNameLabel.text = model.name;
    self.remainCountLabel.text = [NSString stringWithFormat:@"%ld",(long)model.count];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",model.distance];
    [self.siteImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,model.img1]]];
    self.discountView.hidden = model.red == 0;
}


@end
