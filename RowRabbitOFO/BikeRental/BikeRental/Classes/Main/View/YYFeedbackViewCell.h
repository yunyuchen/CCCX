//
//  YYFeedbackViewCell.h
//  YouXing
//
//  Created by yunyuchen on 2018/8/14.
//  Copyright © 2018年 RowRabbit. All rights reserved.
//

#import "QMUITableViewCell.h"

@class YYFeedbackModel;

@interface YYFeedbackViewCell : QMUITableViewCell

@property(nonatomic, strong) YYFeedbackModel *model;

@end
