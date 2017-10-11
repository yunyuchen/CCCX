//
//  YYCardListViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/9/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYCardListViewController.h"
#import "YYCardViewCell.h"
#import "YYBaseRequest.h"
#import "YYCardModel.h"

@interface YYCardListViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property(nonatomic, strong) NSArray<YYCardModel *> *models;

@end

@implementation YYCardListViewController

-(NSArray<YYCardModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 190;
    self.navigationItem.title = @"购卡";
    self.tableView.tableHeaderView = self.headerView;
    
    [self requestCardList];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) requestCardList
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kVipListAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYCardModel modelArrayWithDictArray:response];
            
            [weakSelf.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card"];
    cell.model = self.models[indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detail" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(YYCardViewCell *)sender
{
    [segue.destinationViewController setValue:sender.model forKey:@"model"];
}

@end
