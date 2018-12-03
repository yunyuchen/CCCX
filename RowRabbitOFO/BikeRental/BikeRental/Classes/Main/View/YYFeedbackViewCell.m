//
//  YYFeedbackViewCell.m
//  YouXing
//
//  Created by yunyuchen on 2018/8/14.
//  Copyright © 2018年 RowRabbit. All rights reserved.
//

#import "YYFeedbackViewCell.h"
#import "YYFeedbackModel.h"

@interface YYFeedbackViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end


@implementation YYFeedbackViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YYFeedbackModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.ctime;
    self.contentLabel.text = model.content;
    self.stateLabel.text = model.stateStr;
}

@end
