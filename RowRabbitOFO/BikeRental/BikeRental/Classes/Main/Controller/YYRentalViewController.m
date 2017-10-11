//
//  YYRentalViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/15.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYRentalViewController.h"
#import "YYRentalViewCell.h"
#import "YYRentalModel.h"
#import "YYUseBikeViewController.h"
#import "YYGetBikeRequest.h"
#import "YYUserModel.h"
#import "YYPayDepositViewController.h"
#import "YYCertificationViewController.h"
#import "YYRentalModel.h"
#import "YYReturnBikeViewController.h"
#import "NSNotificationCenter+Addition.h"
#import "YYSiteModel.h"
#import "YYLoginViewController.h"
#import "YYUserManager.h"
#import <QMUIKit/QMUIKit.h>

@interface YYRentalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray<YYRentalModel *> *rentalArray;

@property (nonatomic,strong) YYUserModel *model;

@property (nonatomic,strong) YYRentalModel *rentalModel;

@end

@implementation YYRentalViewController

-(NSMutableArray<YYRentalModel *> *)rentalArray
{
    if (_rentalArray == nil) {
        _rentalArray = [NSMutableArray array];
    }
    return _rentalArray;
}


//获取站点车辆信息
-(void) getBikeRequest
{
    YYGetBikeRequest *request = [[YYGetBikeRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kGetBikeBysidAPI];
    request.sid = self.sid;
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.rentalArray = [YYRentalModel modelArrayWithDictArray:response];
            
            [weak_self.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#C90530"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   

    [NSNotificationCenter addObserver:self action:@selector(refreshAction:) name:kSiteRefreshNotifaction];
    [self getBikeRequest];
    // Do any additional setup after loading the view.
}

-(void) refreshAction:(NSNotification *)noti
{
    YYSiteModel *model = (YYSiteModel *)noti.object;
    self.sid = model.ID;
    [self getBikeRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.rentalArray.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYRentalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentalCell"];
    cell.model = self.rentalArray[indexPath.section];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
 
    [self.rentalArray enumerateObjectsUsingBlock:^(YYRentalModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    self.rentalArray[indexPath.section].selected = YES;
    [self.tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.rentalArray[section].selected == NO) {
        return nil;
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#C90530"];
    UIButton *useButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 89.5, 30.5)];
    useButton.centerY = footerView.height * 0.5;
    useButton.centerX = self.view.width - 60;
    useButton.tag = section;
    [useButton setTitle:@"马上使用" forState:UIControlStateNormal];
    [useButton setBackgroundColor:[UIColor colorWithHexString:@"#ED1847"]];
    [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [useButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    useButton.layer.cornerRadius = 8;
    useButton.layer.masksToBounds = YES;
    [useButton addTarget:self action:@selector(useAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:useButton];
    return footerView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.rentalArray[section].selected == NO) {
        return 0;
    }
    return 50;
}


-(void) useAction:(UIButton *)sender
{
    if (![YYUserManager isHaveLogin]) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    
    
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(100, 100);
    [tips showLoading];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [tips hideAnimated:YES];
        if (success) {
            weak_self.model = [YYUserModel modelWithDictionary:response];
            
            //未交押金
            if (weak_self.model.dstate == 0) {
                //payDeposit
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYPayDepositViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"payDeposit"];
                
                [weak_self.navigationController pushViewController:payDepositViewController animated:YES];
                return;
            }
            //未认证身份
            if ([weak_self.model.idcard isEqualToString:@""]) {
                //Certification
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
                
                [weak_self.navigationController pushViewController:certificationViewController animated:YES];
                return;
            }
            
            //用户有订单的情况
            if ([weak_self.model.hasorder isEqualToString:@"1"]) {
                QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(100, 100);
                [tips showError:@"上次借车还未付款, 请先付款" hideAfterDelay:2];
                YYBaseRequest *orderRequest = [[YYBaseRequest alloc] init];
                orderRequest.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderInfoAPI];
                [orderRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                    weak_self.rentalModel = [YYRentalModel modelWithDictionary:response];
                    
                    YYReturnBikeViewController *returnBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"returnBike"];
                    returnBikeViewController.price = weak_self.rentalModel.price;
                    returnBikeViewController.extprice = 0;
                    returnBikeViewController.keep = weak_self.rentalModel.keep;
                    [weak_self.navigationController pushViewController:returnBikeViewController animated:YES];
                } error:^(NSError *error) {
                    
                }];
                
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYUseBikeViewController *useBikeViewController = [storyboard instantiateViewControllerWithIdentifier:@"useBike"];
                useBikeViewController.rentalModel = weak_self.rentalArray[sender.tag];
                [weak_self.navigationController pushViewController:useBikeViewController animated:YES];
            }
            //用户无订单
            
        }
    } error:^(NSError *error) {
         [tips hideAnimated:YES];
    }];

}




//获取用户状态信息
-(void) getUserInfoRequest
{
  
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
