//
//  YYFreightViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/15.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYFreightViewController.h"
#import "Masonry.h"

@interface YYFreightViewController ()

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation YYFreightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bs.51xytu.com/htm/standard.htm"]]];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    self.webView = webView;
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
