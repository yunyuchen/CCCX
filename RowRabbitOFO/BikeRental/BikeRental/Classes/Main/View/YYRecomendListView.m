//
//  YYRecomendListView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/21.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYRecomendListView.h"
#import "YYRecommendViewCell.h"
#import "YYGetBikeRequest.h"
#import "YYRentalModel.h"

@interface YYRecomendListView()<UITableViewDelegate,UITableViewDataSource,RecommendViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *siteDistanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *siteImageView;


@end

@implementation YYRecomendListView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

-(NSArray<YYRentalModel *> *)rentalArray
{
    if (_rentalArray == nil) {
        _rentalArray = [NSArray array];
    }
    return _rentalArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = 0;

        if (kScreenHeight <= 568) {
            self.siteImageView.size = CGSizeMake(self.siteImageView.width * 0.5, self.siteImageView.height * 0.5);
            self.siteNameLabel.font = [UIFont systemFontOfSize:12];
            self.siteDistanceLabel.font = [UIFont systemFontOfSize:8];
        }
    }
    return self;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYRecommendViewCell *cell = [YYRecommendViewCell cellWithTableView:tableView];
    cell.model = self.array[indexPath.row];
    if (indexPath.row == 0) {
        cell.recommendView.hidden = NO;
    }else{
        cell.recommendView.hidden = YES;
    }
    cell.delegate = self;
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0f;
}

-(void)RecommendViewCell:(YYRecommendViewCell *)recommendViewCell didClickUseButton:(UIButton *)useButton
{
    if ([self.delegate respondsToSelector:@selector(YYRecomendListView:didClickUseButton:)]) {
        if (recommendViewCell.model == nil) {
            YYRentalModel *model = [[YYRentalModel alloc] init];
            model.ID = recommendViewCell.siteModel.ID;
            model.sid = recommendViewCell.siteModel.sid;
            model.bleid = recommendViewCell.siteModel.bleid;
            model.last_mileage = recommendViewCell.siteModel.last_mileage;
            model.last_percent = recommendViewCell.siteModel.last_percent;
            model.deviceid = recommendViewCell.siteModel.deviceid;
            model.ctime = nil;
            self.selectedModel = model;
        }else{
            self.selectedModel = recommendViewCell.model;
            self.selectedModel.ctime = nil;
        }
        [self.delegate YYRecomendListView:self didClickUseButton:useButton];
    }
}


- (IBAction)closeButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYRecomendListView:didClickCloseButton:)]) {
        [self.delegate YYRecomendListView:self didClickCloseButton:sender];
    }
}




-(void)setSiteModel:(YYYSiteModel *)siteModel
{
    _siteModel = siteModel;
    self.siteNameLabel.text = self.siteModel.name;
    self.siteDistanceLabel.text = [NSString stringWithFormat:@"距离%.2fKM",self.siteModel.distance / 1000.0];

    [self getAllBikeRequest];
}

-(void)setSiteName:(NSString *)siteName
{
    _siteName = siteName;
    self.siteNameLabel.text = self.siteName;

}

-(void)setDistance:(CGFloat)distance
{
    _distance = distance;
    
    self.siteDistanceLabel.text = [NSString stringWithFormat:@"距离%.2fKM",self.distance / 1000.0];
}

-(void)setArray:(NSArray<YYRentalModel *> *)array
{
    _array = array;
    
    self.tableView.tableFooterView = nil;
    
    if (kScreenHeight <= 568) {
        if (self.array.count >= 4) {
            self.height += 3 * 58 - 29;
        }else{
            if (self.array.count > 1) {
                self.height += (self.array.count - 1 ) * 58 - 29;
            }else{
                self.height -= 29;
            }
            
        }
    }else{
        if (self.array.count >= 6) {
            self.height += 5 * 58 - 29;
        }else{
            if (self.array.count > 1) {
                self.height += (self.array.count - 1 ) * 58 - 29;
            }else{
                self.height -= 29;
            }
            
        }
    }
    
    [self.tableView reloadData];
}


-(void) getAllBikeRequest
{
    YYGetBikeRequest *request = [[YYGetBikeRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kGetBikeBysidAPI];
    request.sid = self.siteModel.sid;
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.rentalArray = [YYRentalModel modelArrayWithDictArray:response];
            
            weak_self.tableView.tableFooterView = nil;
            
            if (kScreenHeight <= 568) {
                if (weak_self.rentalArray.count >= 5) {
                    weak_self.height += 4 * 58 - 29;
                }else{
                    if (weak_self.rentalArray.count > 1) {
                        weak_self.height += (weak_self.rentalArray.count - 1 ) * 58 - 29;
                    }else{
                        weak_self.height -= 29;
                    }
                    
                }
            }else{
                if (weak_self.rentalArray.count >= 8) {
                    weak_self.height += 9 * 58 - 29;
                }else{
                    if (weak_self.rentalArray.count > 1) {
                        weak_self.height += (weak_self.rentalArray.count - 1 ) * 58 - 29;
                    }else{
                        weak_self.height -= 29;
                    }
                    
                }
            }
            
            
            
            
            [weak_self.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];

}



@end
