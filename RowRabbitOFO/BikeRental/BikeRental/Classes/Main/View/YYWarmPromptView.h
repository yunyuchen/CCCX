//
//  YYWarmPromptView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/10/10.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYWarmPromptView;
@protocol YYWarmPromptViewDelegate <NSObject>

-(void) YYWarmPromptView:(YYWarmPromptView *)view didClickShowButton:(UIButton *)btn;

@end

@interface YYWarmPromptView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *tipsLabel;
@property(nonatomic, weak) id<YYWarmPromptViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end
