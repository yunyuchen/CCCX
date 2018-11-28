//
//  YYSiteView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/7.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYSiteView.h"
#import "UIImageView+WebCache.h"

@interface YYSiteView()

@property (weak, nonatomic) IBOutlet UIImageView *siteImageView;

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *siteDistanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *siteBikeCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *lable1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UIButton *nearLabel;

@end

@implementation YYSiteView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.nearLabel.layer.cornerRadius = 1
    ;
    self.nearLabel.layer.borderColor = [UIColor colorWithHexString:@"#FA684D"].CGColor;
    self.nearLabel.layer.borderWidth = 1;
    self.nearLabel.layer.masksToBounds = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        if (kScreenHeight <= 568) {
            self.siteDistanceLabel.font = self.siteBikeCountLabel.font  = self.lable1.font = self.label2.font = self.label3.font = self.label4.font  = [UIFont systemFontOfSize:10];
           
        }
       
    }
    return self;
}

- (IBAction)returnButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addressView:didClickReturnButton:)]) {
        [self.delegate addressView:self didClickReturnButton:sender];
    }
}

-(void)setModel:(YYSiteModel *)model
{
    _model = model;
    //self.nearLabel.hidden = !model.nearest;
    self.siteNameLabel.text = model.name;
    self.siteDistanceLabel.text = [NSString stringWithFormat:@"%.2f",model.distance];
    self.siteBikeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)model.count];
    [self.siteImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,model.img1]] placeholderImage:[UIImage imageNamed:@"Bitmap"]];
}

@end
