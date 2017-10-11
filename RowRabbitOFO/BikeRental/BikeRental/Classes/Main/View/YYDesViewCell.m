//
//  YYDesViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/18.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYDesViewCell.h"
#import "UIImageView+WebCache.h"


@interface YYDesViewCell()

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation YYDesViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.goButton.layer.cornerRadius = 8;
    self.goButton.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YYSiteModel *)model
{
    _model = model;
    
    self.siteNameLabel.text = model.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fM",model.distance];
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,model.img1]]];
    //[self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,model.img2]]];
}

- (IBAction)goButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DesViewCell:didClickGoButton:)]) {
        [self.delegate DesViewCell:self didClickGoButton:sender];
    }
}


@end
