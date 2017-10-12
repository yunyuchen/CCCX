//
//  YYShareHBView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/30.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYShareHBView.h"
#import <QMUIKit/QMUIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@implementation YYShareHBView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxd3abf6d7a0449600" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    }
    return self;
}

- (IBAction)shareButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYShareHBView:didClickShareButton:)]) {
        [self.delegate YYShareHBView:self didClickShareButton:sender];
    }
}

- (IBAction)closeButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYShareHBView:didClickCloseButton:)]) {
        [self.delegate YYShareHBView:self didClickCloseButton:sender];
    }
}


@end