//
//  YYScoreViewCell.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/24.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYScoreViewCell.h"

@interface YYScoreViewCell()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;


@end

@implementation YYScoreViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // init 时做的事情请写在这里
    }
    return self;
}

- (void)updateCellAppearanceWithIndexPath:(NSIndexPath *)indexPath {
    [super updateCellAppearanceWithIndexPath:indexPath];
    // 每次 cellForRow 时都要做的事情请写在这里
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

-(void)setModel:(YYScoreModel *)model
{
    _model = model;
    
    self.remarkLabel.text = model.des;
    self.timeLabel.text = model.ctime;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f",model.point];
}

@end
