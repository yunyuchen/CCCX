//
//  YYRemoteViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/25.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYRemoteViewCell.h"
#import "UIImageView+WebCache.h"

@interface YYRemoteViewCell()

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation YYRemoteViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,model.img2]]];
}

- (IBAction)returnButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(RemoteViewCell:didClickReturnButton:)]) {
        [self.delegate RemoteViewCell:self didClickReturnButton:sender];
    }
}


@end
