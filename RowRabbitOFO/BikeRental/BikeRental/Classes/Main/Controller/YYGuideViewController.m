//
//  YYGuideViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/22.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYGuideViewController.h"
#import "Masonry.h"

@interface YYGuideViewController ()

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation YYGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用指南";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.cccx.ltd/htm/userguide.htm?random=%u",arc4random()]]]];
    [self.view addSubview:webView];
    webView.scalesPageToFit = YES;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(64);
    }];
    
  
    
    self.webView = webView;
    self.webView.backgroundColor = [UIColor whiteColor];
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
