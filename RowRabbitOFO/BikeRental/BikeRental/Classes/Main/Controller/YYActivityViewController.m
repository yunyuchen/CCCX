//
//  YYActivityViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYActivityViewController.h"
#import "YYActChargeViewController.h"
#import "Masonry.h"
#import "WebViewJavascriptBridge.h"
#import "YYLoginViewController.h"
#import "YYUserManager.h"
#import "YYNavigationController.h"

@interface YYActivityViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) WebViewJavascriptBridge *bridge;

@end

@implementation YYActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    self.webView = webView;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    topView.backgroundColor = [UIColor whiteColor];
    
    //初始化  WebViewJavascriptBridge
    if (_bridge) { return; }
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    //申明js调用oc方法的处理事件，这里写了后，h5那边只要请求了，oc内部就会响应
    [self JS2OC];
    // Do any additional setup after loading the view.
}

-(void)JS2OC{
    /*
     含义：JS调用OC
     @param registerHandler 要注册的事件名称(比如这里我们为loginAction)
     @param handel 回调block函数 当后台触发这个事件的时候会执行block里面的代码
     */
    [_bridge registerHandler:@"createPayBalance" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data js页面传过来的参数  假设这里是用户名和姓名，字典格式
        if (![YYUserManager isHaveLogin]) {
            UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            YYLoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"login"];
            [self presentViewController:[[YYNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:nil];
            return;
        }
        
        // 利用data参数处理自己的逻辑
        NSDictionary *dict = (NSDictionary *)data;
        
        YYActChargeViewController *chargeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"actCharge"];
        [self.navigationController pushViewController:chargeViewController animated:YES];
        //NSString *str = [NSString stringWithFormat:@"价格：%@",dict[@"price"]];
        //[self renderButtons:str];
        chargeViewController.price = [dict[@"price"] floatValue];
        // responseCallback 给js的回复
        //responseCallback(@"报告，oc已收到js的请求");
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = theTitle;
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
