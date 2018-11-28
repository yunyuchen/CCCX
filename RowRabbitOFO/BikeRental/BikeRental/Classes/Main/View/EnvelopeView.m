//
//  EnvelopeView.m
//  BikeRental
//
//  Created by yunyuchen on 2018/11/24.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "EnvelopeView.h"

@implementation EnvelopeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
     return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

@end
