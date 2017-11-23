//
//  YYWebViewController.m
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/19.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import "YYWebViewController.h"
#import "Masonry.h"

@interface YYWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation YYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务协议";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cccx.ltd/htm/service.htm"]]];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    self.webView = webView;
    // 状态栏(statusbar)
    CGRect StatusRect=[[UIApplication sharedApplication] statusBarFrame];
    //标题
    CGRect NavRect=self.navigationController.navigationBar.frame;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, StatusRect.size.height + NavRect.size.height)];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(StatusRect.size.height + NavRect.size.height);
    }];
    topView.backgroundColor = [UIColor whiteColor];
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
