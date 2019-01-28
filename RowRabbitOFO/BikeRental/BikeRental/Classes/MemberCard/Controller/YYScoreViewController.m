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
#import "CCWebViewController.h"

@interface YYScoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet QMUITableView *tableView;

@property(nonatomic, strong) NSArray<YYScoreModel*> *models;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;

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
    self.indicatorImageView.image =[UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(9, 17) tintColor:[UIColor whiteColor]];
    [self requestMyPoint];
}

- (IBAction)lotteryButtonClick:(id)sender {
    CCWebViewController *vc = [[CCWebViewController alloc] init];
    vc.url = @"http://api.cccx.ltd/award";
    [self.navigationController pushViewController:vc animated:YES];
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
