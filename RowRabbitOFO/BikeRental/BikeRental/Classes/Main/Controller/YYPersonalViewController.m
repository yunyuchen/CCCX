//
//  YYPersonalViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYPersonalViewController.h"
#import "YYPersonalViewCell.h"
#import "YYBaseRequest.h"
#import "YYUserModel.h"
#import "YYMyWalletViewController.h"
#import "YYUserManager.h"
#import "YYUserNeedsViewController.h"
#import "YYAboutUSViewController.h"
#import <QMUIKit/QMUIKit.h>

@interface YYPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *itemsArray;

@property (nonatomic,strong) NSArray *imagesArray;

@property (nonatomic,strong) YYUserModel *model;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *depositLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMinLabel;

@end

@implementation YYPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.fd_prefersNavigationBarHidden = YES;
    self.itemsArray = @[@"用户指南",@"关于我们",@"退出登录"];
    self.imagesArray = @[@"17用户指南",@"18关于我们",@"19设置"];
    
    [self getUserInfoRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getUserInfoRequest
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.model = [YYUserModel modelWithDictionary:response];
            
            weak_self.telLabel.text = weak_self.model.tel;
            
            weak_self.depositLabel.text = [NSString stringWithFormat:@"%.0f",weak_self.model.deposit];
            
            weak_self.totalMinLabel.text = [NSString stringWithFormat:@"%.0f",weak_self.model.totalkeep];

        }
    } error:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYPersonalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalViewCell"];
    cell.itemName = self.itemsArray[indexPath.row];
    cell.itemImage = self.imagesArray[indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
      

    }
    if (indexPath.row == 0) {
        YYUserNeedsViewController *userNeedsViewController = [[YYUserNeedsViewController alloc] init];
        [self.navigationController pushViewController:userNeedsViewController animated:YES];
    }
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"aboutusSegue" sender:self];
    }
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[YYMyWalletViewController class]]) {
        [segue.destinationViewController setValue:self.model forKey:@"model"];
    }
}


@end
