//
//  YYMessageViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/8.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYMessageViewController.h"
#import "YYMessageViewCell.h"
#import "YYBaseRequest.h"
#import "YYMsgModel.h"
#import "YYActivityViewController.h"

@interface YYMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray<YYMsgModel *> *models;

@end

@implementation YYMessageViewController

-(NSArray<YYMsgModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的消息";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    [self requestMsgList];
    // Do any additional setup after loading the view.
}

-(void) requestMsgList
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kPushMsgAPI];
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            NSLog(@"%@",response);
            weak_self.models = [YYMsgModel modelArrayWithDictArray:response];
            
            [weak_self.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    cell.model = self.models[indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.models[indexPath.row].type != 1) {
        return;
    }
    YYActivityViewController *activityViewController = [[YYActivityViewController alloc] init];
    activityViewController.url = self.models[indexPath.row].url;
    [self.navigationController pushViewController:activityViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
