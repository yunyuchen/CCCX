//
//  YYInfomationViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2018/11/29.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYInfomationViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YYInfomationViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation YYInfomationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(YYInformationModel *)model
{
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,model.timg]]];
}

@end
