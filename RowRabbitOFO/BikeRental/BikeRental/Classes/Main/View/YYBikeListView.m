//
//  YYBikeListView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/14.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBikeListView.h"
#import "YYBikeInfoViewCell.h"
#import "YYGetBikeRequest.h"
#import "YYRentalModel.h"

@interface YYBikeListView()<UITableViewDelegate,UITableViewDataSource,BikeInfoViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray<YYRentalModel *> *rentalArray;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;


@end

@implementation YYBikeListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 59;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        //必须给effcetView的frame赋值,因为UIVisualEffectView是一个加到UIIamgeView上的子视图.
        effectView.frame = self.bounds;
        [self insertSubview:effectView atIndex:0];
        
    }
    return self;
}

-(void)setSid:(NSInteger)sid
{
    _sid = sid;
    [self getBikeRequest];
}

-(void)setDistance:(CGFloat)distance
{
    _distance = distance;
    
    if (distance < 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"距离%.2fM",distance];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"距离%.2fKM",distance / 1000.0];
    }
    
}

-(void)setSiteName:(NSString *)siteName
{
    _siteName = siteName;
    
    self.siteNameLabel.text = siteName;
}

- (IBAction)closeButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(BikeListView:didClickCloseButton:)]) {
        [self.delegate BikeListView:self didClickCloseButton:sender];
    }
}


//获取站点车辆信息
-(void) getBikeRequest
{
    YYGetBikeRequest *request = [[YYGetBikeRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kGetBikeBysidAPI];
    request.sid = self.sid;
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.rentalArray = [YYRentalModel modelArrayWithDictArray:response];
            
            [weak_self.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rentalArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYBikeInfoViewCell *cell = [YYBikeInfoViewCell cellWithTableView:tableView];
    cell.model = self.rentalArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(BikeListView:didClickUseButtonCell:)]) {
        [self.delegate BikeListView:self didClickUseButtonCell:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

-(void)bikeInfoViewCell:(YYBikeInfoViewCell *)bikeInfoViewCell didClickUseButton:(UIButton *)useButton
{
    if ([self.delegate respondsToSelector:@selector(BikeListView:didClickUseButtonCell:)]) {
        [self.delegate BikeListView:self didClickUseButtonCell:bikeInfoViewCell];
    }
}

@end
