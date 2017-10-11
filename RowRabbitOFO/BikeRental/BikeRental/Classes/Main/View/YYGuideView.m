//
//  YYGuideView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/6.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYGuideView.h"

@interface YYGuideView()

@property (nonatomic,strong) UIImageView *guideImageView;

@property (nonatomic,assign) BOOL canRemove;

@end

@implementation YYGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UIImageView *guideImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:guideImageView];
        self.guideImageView = guideImageView;
        self.guideImageView.userInteractionEnabled = YES;
        self.guideImageView.image = [UIImage imageNamed:@"引导01"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.guideImageView addGestureRecognizer:tap];
    }
    return self;
}

-(void) tapAction:(UITapGestureRecognizer *)tap
{
    if (self.canRemove) {
        [self removeFromSuperview];
    }
    self.guideImageView.image = [UIImage imageNamed:@"引导02"];
    self.canRemove = YES;
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:kFirstLoadKey];
}

@end
