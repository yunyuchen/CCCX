//
//  YYInviteRuleView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYInviteRuleView.h"

@interface YYInviteRuleView()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation YYInviteRuleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.contentView.layer.cornerRadius = 12;
        self.contentView.layer.masksToBounds = YES;
    }
    return self;
}

- (IBAction)closeButtonClick:(id)sender {
    if (self.myBlock) {
        self.myBlock();
    }
}

@end
