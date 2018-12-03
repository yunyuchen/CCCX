//
//  EnvelopeView.m
//  BikeRental
//
//  Created by yunyuchen on 2018/11/24.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "EnvelopeView.h"

@interface EnvelopeView()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;



@end

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

-(void)setMoney:(NSString *)money
{
    _money = money;
    self.moneyLabel.text = money;
}

@end
