//
//  YYReturnFeedbackView.m
//  BikeRental
//
//  Created by yunyuchen on 2018/9/19.
//  Copyright © 2018年 xinghu. All rights reserved.
//

#import "YYReturnFeedbackView.h"
#import "QMUIKit.h"

@interface YYReturnFeedbackView()



@end

@implementation YYReturnFeedbackView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)cancelButtonClick:(UIButton *)sender {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

- (IBAction)confirmButtonClick:(UIButton *)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (IBAction)addPhotoButtonClick:(id)sender {
    if (self.addPhotoBlock) {
        self.addPhotoBlock();
    }
}

@end
