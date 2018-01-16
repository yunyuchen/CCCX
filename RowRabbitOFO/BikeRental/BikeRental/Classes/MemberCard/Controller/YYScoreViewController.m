//
//  YYScoreViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/24.
//Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYScoreViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YYScoreViewCell.h"
#import "YYBaseRequest.h"
#import "YYScoreModel.h"

@interface YYScoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet QMUITableView *tableView;

@property(nonatomic, strong) NSArray<YYScoreModel*> *models;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@end

@implementation YYScoreViewController

- (NSArray<YYScoreModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f",self.score];
    
    [self requestMyPoint];
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
    self.title = @"我的积分";
}

- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) requestMyPoint
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kMyPointAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYScoreModel modelArrayWithDictArray:response];
            
            [weakSelf.tableView reloadData];
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
        }
    } error:^(NSError *error) {
        
    }];
    
}

#pragma mark - tableviewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.models.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYScoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"score"];
    cell.model = self.models[indexPath.row];
    return cell;
}

@end
