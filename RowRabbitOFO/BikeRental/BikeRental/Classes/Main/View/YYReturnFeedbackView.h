//
//  YYReturnFeedbackView.h
//  BikeRental
//
//  Created by yunyuchen on 2018/9/19.
//  Copyright © 2018年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYReturnFeedbackView : UIView

@property(nonatomic, copy) void (^addPhotoBlock)(void);

@property(nonatomic, copy) void (^confirmBlock)(void);

@property(nonatomic, copy) void (^cancleBlock)(void);

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end

NS_ASSUME_NONNULL_END
