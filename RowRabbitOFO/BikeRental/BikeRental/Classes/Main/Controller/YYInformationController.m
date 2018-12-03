//
//  YYInformationController.m
//  BikeRental
//
//  Created by yunyuchen on 2018/11/28.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYInformationController.h"
#import "YYBaseRequest.h"
#import "YYInformationModel.h"
#import "YYInfomationViewCell.h"
#import "CCWebViewController.h"

@interface YYInformationController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSArray<YYInformationModel *> *models;

@property (weak, nonatomic) IBOutlet QMUITableView *tableView;


@end

@implementation YYInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"资讯";
    [self loadInformation];
}


- (void) loadInformation {
    YYBaseRequest *request = [YYBaseRequest nh_requestWithUrl:[NSString stringWithFormat:@"%@%@",kBaseURL,kInformationAPI]];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYInformationModel modelArrayWithDictArray:response];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYInfomationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 137;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView qmui_clearsSelection];
    
    CCWebViewController *vc = [[CCWebViewController alloc] init];
    vc.url = [NSString stringWithFormat:@"%@%@",kBaseURL,self.models[indexPath.row].cimg];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
