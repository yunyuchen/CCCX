//
//  YYDisabledCouponViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/22.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYDisabledCouponViewController.h"
#import "YYDisabledCouponViewCell.h"


@interface YYDisabledCouponViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet QMUITableView *tableView;


@end

@implementation YYDisabledCouponViewController


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
    // 对 self.view 的操作写在这里
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

#pragma mark - tableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYDisabledCouponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"disabledCoupon"];
    return cell;
}

@end
