//
//  YYWebViewController.m
//  YouXing
//
//  Created by yunyuchen on 2018/8/10.
//  Copyright © 2018年 RowRabbit. All rights reserved.
//

#import "CCWebViewController.h"
#import "WeiXinPayModel.h"
#import <WXApi.h>
#import <MJExtension/MJExtension.h>
#import <Masonry/Masonry.h>
#import <WebKit/WebKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "YYFileCacheManager.h"

@interface CCWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic, weak) WKWebView *webView;

@property (nonatomic,strong) UIProgressView *progress;
@end

@implementation CCWebViewController

#pragma mark 加载进度条
- (UIProgressView *)progress
{
    if (_progress == nil)
    {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 2)];
        _progress.tintColor = [UIColor blueColor];
        _progress.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_progress];
    }
    return _progress;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    NSString *cookieValue = [NSString stringWithFormat:@"document.cookie='agent=Ios';document.cookie='token=%@'",[YYFileCacheManager readUserDataForKey:kTokenKey]];
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookieValue
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    config.userContentController = userContentController;
    config.preferences = preferences;
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) configuration:config];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    self.webView = webview;
    
    /* 加载服务器url的方法*/
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [request addValue:[NSString stringWithFormat:@"agent=Ios;token=%@;Domain=.cccx.ltd;Path=/",[YYFileCacheManager readUserDataForKey:kTokenKey]] forHTTPHeaderField:@"Cookie"];
    [webview loadRequest:request];

    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)loadRequestWithUrlString:(NSString *)urlString {
    
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    
    [self.webView loadRequest:request];
}


- (void)insertCookie:(NSHTTPCookie *)cookie
{
    @autoreleasepool {
        
        if (@available(iOS 11.0, *)) {
            WKHTTPCookieStore *cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore;
            [cookieStore setCookie:cookie completionHandler:nil];
            return;
        }
        
        NSMutableArray *TempCookies = [NSMutableArray array];
        NSMutableArray *localCookies =[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"]];
        for (int i = 0; i < localCookies.count; i++) {
            NSHTTPCookie *TempCookie = [localCookies objectAtIndex:i];
            if ([cookie.name isEqualToString:TempCookie.name]) {
                [localCookies removeObject:TempCookie];
                i--;
                break;
            }
        }
        [TempCookies addObjectsFromArray:localCookies];
        [TempCookies addObject:cookie];
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: TempCookies];
        [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:@"cookie"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.webView)
        {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.webView.estimatedProgress animated:YES];
            if(self.webView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView)
        {
            self.title = self.webView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark 移除观察者
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *url = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
//    NSString* reUrl=[[webView URL] absoluteString];
//    if ([url containsString:kBaseURL]) {
//        reUrl=url;
//
//    }
    
    if ([url containsString:@"alipay://"]) {
        NSString* dataStr=[url substringFromIndex:9];
        NSLog(@"%@",dataStr);
        [[AlipaySDK defaultService] payOrder:dataStr fromScheme:@"chengchePay" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    if ([url containsString:@"weixin://"]) {
        NSString* dataStr=[url substringFromIndex:9];
        NSLog(@"%@",dataStr);
        WeiXinPayModel *model = [WeiXinPayModel mj_objectWithKeyValues:dataStr];
        PayReq* req  = [[PayReq alloc] init];
        req.partnerId  = model.partnerid;
        req.prepayId   = model.prepayid;
        req.nonceStr   = model.noncestr;
        req.timeStamp  = [model.timestamp intValue];
        req.package    = model.package;
        req.sign        = model.sign;
        [WXApi sendReq:req];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    // 获取cookie,并设置到本地
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {        completionHandler();    }])];    [self presentViewController:alertController animated:YES completion:nil];}




@end
