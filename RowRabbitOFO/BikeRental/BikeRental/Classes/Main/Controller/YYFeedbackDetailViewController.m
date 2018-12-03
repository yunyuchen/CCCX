//
//  YYFeedbackDetailViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2018/11/29.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYFeedbackDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface YYFeedbackDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *image;


@end

@implementation YYFeedbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.model.title;
    self.contentLabel.text = self.model.content;
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,self.model.img]]];
    
    self.title = @"通知";
}


@end
