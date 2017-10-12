//
//  YYWarmPromptView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/10/10.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYWarmPromptView.h"
#import "YYFileCacheManager.h"
#import <QMUIKit/QMUIKit.h>

@interface YYWarmPromptView()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation YYWarmPromptView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        if ([YYFileCacheManager readUserDataForKey:@"config"][@"tipmsg"] != nil) {
              self.tipsLabel.text = [YYFileCacheManager readUserDataForKey:@"config"][@"tipmsg"];
        }

    }
    return self;
}

- (IBAction)closeButtonClick:(id)sender {
    [QMUIModalPresentationViewController hideAllVisibleModalPresentationViewControllerIfCan];
}


@end
