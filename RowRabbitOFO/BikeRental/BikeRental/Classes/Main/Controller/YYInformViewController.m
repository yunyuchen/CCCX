//
//  YYInformViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2018/11/23.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYInformViewController.h"
#import "YYBaseRequest.h"
#import "YYFeedbackModel.h"
#import "YYFeedbackViewCell.h"

@interface YYInformViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSArray<YYFeedbackModel *> *models;

@end

@implementation YYInformViewController

-(NSArray<YYFeedbackModel *> *)models
{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestFeedbackList];
}

- (void) requestFeedbackList
{
//    YYBaseRequest *request = [YYBaseRequest nh_requestWithUrl:[NSString stringWithFormat:@"%@%@",kBaseURL,kFeedbackListAPI]];
//    __weak __typeof(self)weakSelf = self;
//    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//        if (success) {
//            QMUILog(@"kFeedbackListAPI",@"%@",response);
//            weakSelf.models  = [YYFeedbackModel modelArrayWithDictArray:response];
//            [weakSelf.tableView reloadData];
//        }else{
//            [QMUITips showError:message inView:weakSelf.view hideAfterDelay:1.5];
//        }
//    } error:^(NSError *error) {
//
//    }];
}


//-(void)setupNavigationItems
//{
//    [super setupNavigationItems];
//    self.title = @"反馈记录";
//}




-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYFeedbackViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"feedback"];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYFeedbackModel *model = [self.models objectAtIndex:indexPath.row];
    return model.cellHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView qmui_clearsSelection];
    //[self performSegueWithIdentifier:@"detail" sender:self.models[indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    YYFeedbackDetailViewController *vc = segue.destinationViewController;
//    vc.model = sender;
}


@end
