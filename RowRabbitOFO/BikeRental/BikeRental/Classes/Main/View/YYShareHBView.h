//
//  YYShareHBView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/30.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShareHBView;
@protocol ShareHBViewDelegate <NSObject>

-(void) YYShareHBView:(YYShareHBView *)shareHBView didClickShareButton:(UIButton *)shareButton;

-(void) YYShareHBView:(YYShareHBView *)shareHBView didClickCloseButton:(UIButton *)closeButton;

@end

@interface YYShareHBView : UIView

@property (nonatomic,weak) id<ShareHBViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
