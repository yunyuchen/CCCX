//
//  YYSettingViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/21.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYSettingViewController.h"
#import "YYFeedBackController.h"
#import "YYWebViewController.h"
#import <QMUIKit/QMUIKit.h>
#import "YYUserManager.h"

@interface YYSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!self.used) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, kScreenHeight - 64, kScreenWidth - 40, 44)];
        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutButton.frame = bottomView.bounds;
        [logoutButton setTitle:@"退出账号" forState:UIControlStateNormal];
        [logoutButton setBackgroundColor:[UIColor colorWithHexString:@"#F85233"]];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logoutButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [logoutButton addTarget:self action:@selector(logoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:logoutButton];
        [self.view addSubview:bottomView];
    }

    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void) logoutButtonClick:(UIButton *)sender
{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
        [YYUserManager logout];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"确定退出登录吗" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#404040"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"关于橙车出行";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"去评分";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"版本号";
        cell.accessoryType  = UITableViewCellAccessoryNone;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
         NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V %@",app_Version];
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"意见与反馈";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"租车协议";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"about" sender:self];
    }else if (indexPath.row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1280933754?mt=8"]];
    }else if (indexPath.row == 3){
        YYFeedBackController *feedbackController = [[YYFeedBackController alloc] init];
        [self.navigationController pushViewController:feedbackController animated:YES];
    }else if (indexPath.row == 4){
        YYWebViewController *webViewController = [[YYWebViewController alloc] init];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
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
