//
//  YYSignSuccessView.m
//  BikeRental
//
//  Created by yunyuchen on 2019/3/8.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import "YYSignSuccessView.h"
#import <QMUIKit/QMUIKit.h>

@interface YYSignSuccessView()


@end


@implementation YYSignSuccessView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)closeButtonClick:(id)sender {
    [QMUIModalPresentationViewController hideAllVisibleModalPresentationViewControllerIfCan];
}

@end
