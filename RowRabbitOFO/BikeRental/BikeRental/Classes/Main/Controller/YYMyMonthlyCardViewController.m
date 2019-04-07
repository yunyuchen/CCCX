//
//  YYMyMonthlyCardViewController.m
//  ShanHaWan
//
//  Created by yunyuchen on 2018/12/24.
//  Copyright © 2018 xinghu. All rights reserved.
//

#import "YYMyMonthlyCardViewController.h"
#import "YYBaseRequest.h"
#import "YYVIPLogRequest.h"
#import "YYUserModel.h"
#import "YYBuyRecordModel.h"
#import "YYWalletViewCell.h"
//#import "YYBuyMothlyCardTipsView.h"
#import <Masonry/Masonry.h>

@interface YYMyMonthlyCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic, strong) YYUserModel *userModel;

@property(nonatomic, strong) NSMutableArray<YYBuyRecordModel *> *models;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightCons;

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet QMUIGhostButton *buyButton;
@property (weak, nonatomic) IBOutlet QMUIFillButton *buyButton1;

@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;


@end

@implementation YYMyMonthlyCardViewController

-(NSMutableArray<YYBuyRecordModel *> *)models
{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self loadBuyRecords];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadUserInfo];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)cardTipsButtonClick:(id)sender {
//    YYBuyMothlyCardTipsView *contentView = [[YYBuyMothlyCardTipsView alloc] init];
//    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
//    modalViewController.contentView = contentView;
//    modalViewController.maximumContentViewWidth = kScreenWidth;
//    modalViewController.contentViewMargins = UIEdgeInsetsMake(10, 10, 10, 10);
//    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
//    [modalViewController showWithAnimated:YES completion:nil];
}


- (void)initSubviews {
    [super initSubviews];
    [self.backButton setImage:[UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    // 状态栏(statusbar)
    CGRect StatusRect=[[UIApplication sharedApplication] statusBarFrame];
    //标题
    CGRect NavRect=self.navigationController.navigationBar.frame;
    self.topViewHeightCons.constant = StatusRect.size.height + NavRect.size.height;
    self.cardView.layer.cornerRadius = 6;
    self.cardView.layer.masksToBounds = YES;
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor qmui_colorWithHexString:@"#BEA169"].CGColor, (__bridge id)[UIColor qmui_colorWithHexString:@"#DBC79C"].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1.0);
    gradientLayer.frame = self.cardView.bounds;
    [self.cardView.layer insertSublayer:gradientLayer atIndex:0];
}

- (void) loadUserInfo
{
    
    YYBaseRequest *request = [YYBaseRequest nh_requestWithUrl:[NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI]];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.userModel = [YYUserModel modelWithDictionary:response];
            if (weakSelf.userModel.cardstate) {
                weakSelf.timeLabel.hidden = NO;
                weakSelf.cardIconImageView.hidden = NO;
                weakSelf.cardNameLabel.hidden = NO;
                weakSelf.buyButton.hidden = NO;
                weakSelf.emptyImageView.hidden = YES;
                weakSelf.emptyLabel.hidden = YES;
                weakSelf.timeLabel.text = [NSString stringWithFormat:@"到期时间：%@",weakSelf.userModel.cardouttime];
                weakSelf.buyButton1.hidden = YES;
            }else{
                weakSelf.timeLabel.hidden = YES;
                weakSelf.cardIconImageView.hidden = YES;
                weakSelf.cardNameLabel.hidden = YES;
                weakSelf.buyButton.hidden = YES;
                weakSelf.emptyImageView.hidden = NO;
                weakSelf.emptyLabel.hidden = NO;
                weakSelf.buyButton1.hidden = NO;
            }
          
        }
    }];
}

- (void) loadBuyRecords
{
    YYVIPLogRequest *request = [YYVIPLogRequest nh_requestWithUrl:[NSString stringWithFormat:@"%@%@",kBaseURL,kVipLogAPI]];
    request.page = 1;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYBuyRecordModel modelArrayWithDictArray:response];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (IBAction)mallAction:(id)sender {
    
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYWalletViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wallet"];
    cell.buyModel = self.models[indexPath.row];
    return cell;
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
