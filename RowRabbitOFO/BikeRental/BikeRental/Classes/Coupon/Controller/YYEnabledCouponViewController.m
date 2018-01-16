//
//  YYEnabledCouponViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/22.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYEnabledCouponViewController.h"
#import "YYCouponViewCell.h"
#import "YYMyCouponRequest.h"
#import "YYCouponModel.h"
#import "NSNotificationCenter+Addition.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface YYEnabledCouponViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet QMUITableView *tableView;

@property(nonatomic, strong) NSArray<YYCouponModel *> *models;

@end

@implementation YYEnabledCouponViewController

-(NSArray<YYCouponModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

- (void)didInitialized {
    [super didInitialized];
    // init 时做的事情请写在这里
}

- (void)initSubviews {
    [super initSubviews];
    // 对 subviews 的初始化写在这里
}

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
    self.title = @"选择优惠券";
}

- (void) requestCoupons
{
    YYMyCouponRequest *request = [[YYMyCouponRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kMyCouponsAPI];
    request.state = 0;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYCouponModel modelArrayWithDictArray:response];
            
            if (weakSelf.selected) {
                for (YYCouponModel *model in weakSelf.models) {
                    if (model.ID == weakSelf.cid) {
                        model.selected = YES;
                        break;
                    }
                }
            }
            
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
    YYCouponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"enableCoupon"];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYCouponModel *model = self.models[indexPath.row];
    if (model.condition > self.price) {
        [QMUITips showWithText:@"无法使用该优惠券" inView:self.view hideAfterDelay:2];
        return;
    }
    if (self.selected) {
        
        [NSNotificationCenter postNotification:kSelectedCouponNotification object:self.models[indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无优惠券";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
