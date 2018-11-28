//
//  YYWarmPromptView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/10/10.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYWarmPromptView.h"
#import "YYFileCacheManager.h"
#import "UIImageView+WebCache.h"
#import <QMUIKit/QMUIKit.h>

@interface YYWarmPromptView()



@end

@implementation YYWarmPromptView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        if ([YYFileCacheManager readUserDataForKey:@"config"][@"tipImg"] != nil) {
            NSLog(@"%@",[YYFileCacheManager readUserDataForKey:@"config"][@"tipImg"]);
            [self.tipsLabel sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,[YYFileCacheManager readUserDataForKey:@"config"][@"tipImg"]]] placeholderImage:[UIImage imageNamed:@"提示"]];
        }

    }
    return self;
}

- (IBAction)closeButtonClick:(id)sender {
    [QMUIModalPresentationViewController hideAllVisibleModalPresentationViewControllerIfCan];
}


@end
