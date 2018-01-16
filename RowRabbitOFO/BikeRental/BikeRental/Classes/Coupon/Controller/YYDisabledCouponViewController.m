//
//  YYDisabledCouponViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/22.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYDisabledCouponViewController.h"
#import "YYDisabledCouponViewCell.h"
#import "YYMyCouponRequest.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface YYDisabledCouponViewController ()<UIScrollViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet QMUITableView *tableView;

@property(nonatomic, strong) NSArray<YYCouponModel *> *models;

@end

@implementation YYDisabledCouponViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestCoupons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"";
}

- (void) requestCoupons
{
    YYMyCouponRequest *request = [[YYMyCouponRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kMyCouponsAPI];
    request.state = 1;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYCouponModel modelArrayWithDictArray:response];
           
            
            [weakSelf.tableView reloadData];
        }
    }];
    
}


#pragma mark - tableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYDisabledCouponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"disabledCoupon"];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无优惠券";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
