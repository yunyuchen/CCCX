//
//  YYSelectPayView.h
//  BikeRental
//
//  Created by yunyuchen on 2019/3/30.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YYSelectPayView;

@protocol YYSelectPayViewDelegate<NSObject>

@optional

- (void) YYSelectPayView:(YYSelectPayView *)payView didClickPayButton:(UIButton *)sender;

@end

@interface YYSelectPayView : UIView

@property(nonatomic, assign) CGFloat price;

@property(nonatomic, assign) NSInteger payType;

@property(nonatomic, assign) NSInteger vipId;

@property(nonatomic, assign) NSInteger cardid;

@property(nonatomic, weak) id<YYSelectPayViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
