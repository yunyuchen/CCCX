//
//  XHLaunchAdManager.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2017/5/3.
//  Copyright © 2017年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  开屏广告初始化

#import "XHLaunchAdManager.h"
#import "XHLaunchAd.h"
#import "AppDelegate.h"
#import "Network.h"
#import "LaunchAdModel.h"
#import "UIViewController+Nav.h"
#import "WebViewController.h"
#import "YYWarmPromptView.h"
#import "YYBuyMemberCardViewController.h"
#import "CCWebViewController.h"
#import "YYFileCacheManager.h"
#import <QMUIKit/QMUIKit.h>
#import <MAMapKit/MAMapKit.h>
/** 以下连接供测试使用 */
/** 静态图 */
#define imageURL1 @"http://c.hiphotos.baidu.com/image/pic/item/4d086e061d950a7b78c4e5d703d162d9f2d3c934.jpg"
#define imageURL2 @"http://d.hiphotos.baidu.com/image/pic/item/f7246b600c3387444834846f580fd9f9d72aa034.jpg"
#define imageURL3 @"http://d.hiphotos.baidu.com/image/pic/item/64380cd7912397dd624a32175082b2b7d0a287f6.jpg"
#define imageURL4 @"http://d.hiphotos.baidu.com/image/pic/item/14ce36d3d539b60071473204e150352ac75cb7f3.jpg"

/** 动态图 */
#define imageURL5 @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg"
#define imageURL6 @"http://p1.bqimg.com/567571/4ce1a4c844b09201.gif"

/** 视频链接 */
#define videoURL1 @"http://ohnzw6ag6.bkt.clouddn.com/video0.mp4"
#define videoURL2  @"http://120.25.226.186:32812/resources/videos/minion_01.mp4"
#define videoURL3 @"http://ohnzw6ag6.bkt.clouddn.com/video1.mp4"

@interface XHLaunchAdManager()<XHLaunchAdDelegate,YYWarmPromptViewDelegate>

@end

@implementation XHLaunchAdManager

+(void)load{
    [self shareManager];
}

+(XHLaunchAdManager *)shareManager{
    static XHLaunchAdManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[XHLaunchAdManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //在UIApplicationDidFinishLaunching时初始化开屏广告,做到对业务层无干扰,当然你也可以直接在AppDelegate didFinishLaunchingWithOptions方法中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            //初始化开屏广告
            [self setupXHLaunchAd];
        }];
    }
    return self;
}

-(void)setupXHLaunchAd{
    
    //1.******图片开屏广告 - 网络数据******
    [self example01];

    //2.******图片开屏广告 - 本地数据******
    //[self example02];
    
    //3.******视频开屏广告 - 网络数据(网络视频只支持缓存OK后下次显示,看效果请二次运行)******
    //[self example03];
    
    //4.******视频开屏广告 - 本地数据******
    //[self example04];
    
    //5.******如需自定义跳过按钮,请看这个示例******
    //[self example05];
    
    //6.******使用默认配置快速初始化,请看下面两个示例******
    //[self example06];//图片
    //[self example07];//视频
    
    //7.******如果你想提前缓存图片/视频请看下面两个示例*****
    //批量下载并缓存图片
    //[self batchDownloadImageAndCache];
    
    //批量下载并缓存视频
    //[self batchDownloadVideoAndCache];

}

#pragma mark - 图片开屏广告-网络数据-示例
//图片开屏广告 - 网络数据
-(void)example01{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将自动进入window的RootVC
    //3.数据获取成功,初始化广告时,自动结束等待,显示广告
    [XHLaunchAd setWaitDataDuration:3];//请求广告数据前,必须设置,否则会先进入window的RootVC
    
    //广告数据请求
    [Network getLaunchAdImageDataSuccess:^(NSDictionary * response) {
        
        NSLog(@"广告数据 = %@",response);
        NSString *openUrl = response[@"launchUrl"];
        if (![openUrl hasPrefix:@"http://"]) {
            openUrl = [NSString stringWithFormat:@"%@%@",kBaseURL,response[@"launchUrl"]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"config"];
        //广告数据转模型
        LaunchAdModel *model = [[LaunchAdModel alloc] init];
        model.duration = 3;
        model.contentSize = @"1242*1786";
        model.openUrl = openUrl;
        model.content = [NSString stringWithFormat:@"%@%@",kBaseURL,response[@"launchImg"]];
        //配置广告数据
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
        //广告停留时间
        imageAdconfiguration.duration = model.duration;
        //广告frame
        imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
        imageAdconfiguration.imageNameOrURLString = model.content;
        //缓存机制(仅对网络图片有效)
        imageAdconfiguration.imageOption = XHLaunchAdImageCacheInBackground;
        //为告展示效果更好,可设置为XHLaunchAdImageCacheInBackground,先缓存,下次显示
        //图片填充模式
        imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
        //广告点击打开链接
        imageAdconfiguration.openURLString = model.openUrl;
        //广告显示完成动画
        imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
        //广告显示完成动画时间
        imageAdconfiguration.showFinishAnimateTime = 0.8;
        //跳过按钮类型
        imageAdconfiguration.skipButtonType = SkipTypeTimeText;
        //后台返回时,是否显示广告
        imageAdconfiguration.showEnterForeground = NO;
        
        //图片已缓存 - 显示一个 "已预载" 视图 (可选)
        if([XHLaunchAd checkImageInCacheWithURL:[NSURL URLWithString:model.content]])
        {
            //设置要添加的自定义视图(可选)
            //imageAdconfiguration.subViews = [self launchAdSubViews_alreadyView];
            
        }
        //显示开屏广告
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        
        
    } failure:^(NSError *error) {
    }];
    
}


#pragma mark - 图片开屏广告-本地数据-示例
//图片开屏广告 - 本地数据
-(void)example02{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
     [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 5;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/1242*1786);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"image2.jpg";
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    imageAdconfiguration.GIFImageCycleOnce = NO;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    //广告点击打开链接
    imageAdconfiguration.openURLString = @"http://www.it7090.com";
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFlipFromLeft;
    //广告显示完成动画时间
    imageAdconfiguration.showFinishAnimateTime = 0.8;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeRoundProgressText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
}

#pragma mark - 视频开屏广告-网络数据-示例
//视频开屏广告 - 网络数据
-(void)example03{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
      [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [XHLaunchAd setWaitDataDuration:3];
    
    //广告数据请求
    [Network getLaunchAdVideoDataSuccess:^(NSDictionary * response) {
        
        NSLog(@"广告数据 = %@",response);
        
        //广告数据转模型
        LaunchAdModel *model = [[LaunchAdModel alloc] initWithDict:response[@"data"]];
        
        //配置广告数据
        XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration new];
        //广告停留时间
        videoAdconfiguration.duration = model.duration;
        //广告frame
        videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/model.width*model.height);
        //广告视频URLString/或本地视频名(请带上后缀)
        //注意:视频广告只支持先缓存,下次显示(看效果请二次运行)
        videoAdconfiguration.videoNameOrURLString = model.content;
        //视频缩放模式
        videoAdconfiguration.scalingMode = MPMovieScalingModeAspectFill;
        //是否只循环播放一次
        videoAdconfiguration.videoCycleOnce = NO;
        //广告点击打开链接
        videoAdconfiguration.openURLString = model.openUrl;
        //广告显示完成动画
        videoAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
        //广告显示完成动画时间
        videoAdconfiguration.showFinishAnimateTime = 0.8;
        //后台返回时,是否显示广告
        videoAdconfiguration.showEnterForeground = NO;
        //跳过按钮类型
        videoAdconfiguration.skipButtonType = SkipTypeTimeText;
        //视频已缓存 - 显示一个 "已预载" 视图 (可选)
        if([XHLaunchAd checkVideoInCacheWithURL:[NSURL URLWithString:model.content]]){
            //设置要添加的自定义视图(可选)
            videoAdconfiguration.subViews = [self launchAdSubViews_alreadyView];
            
        }
        
        [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 视频开屏广告-本地数据-示例
//视频开屏广告 - 本地数据
-(void)example04{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
      [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //配置广告数据
    XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration new];
    //广告停留时间
    videoAdconfiguration.duration = 5;
    //广告frame
    videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告视频URLString/或本地视频名(请带上后缀)
    videoAdconfiguration.videoNameOrURLString = @"video1.mp4";
    //视频填充模式
    videoAdconfiguration.scalingMode = MPMovieScalingModeAspectFill;
    //是否只循环播放一次
    videoAdconfiguration.videoCycleOnce = NO;
    //广告点击打开链接
    videoAdconfiguration.openURLString =  @"http://www.it7090.com";
    //跳过按钮类型
    videoAdconfiguration.skipButtonType = SkipTypeRoundProgressTime;
    //广告显示完成动画
    videoAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
    //广告显示完成动画时间
    videoAdconfiguration.showFinishAnimateTime = 0.8;
    //后台返回时,是否显示广告
    videoAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //videoAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
    
}
#pragma mark - 自定义跳过按钮-示例
-(void)example05{
    
    //注意:
    //1.自定义跳过按钮很简单,configuration有一个customSkipView属性.
    //2.自定义一个跳过的view 赋值给configuration.customSkipView属性便可替换默认跳过按钮,如下:
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
     [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 5;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/1242*1786);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"image11.gif";
    //缓存机制(仅对网络图片有效)
    imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    //广告点击打开链接
    imageAdconfiguration.openURLString = @"http://www.it7090.com";
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFlipFromLeft;
    //广告显示完成动画时间
    imageAdconfiguration.showFinishAnimateTime = 0.8;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    
    //设置要添加的子视图(可选)
    imageAdconfiguration.subViews = [self launchAdSubViews];
    
    //start********************自定义跳过按钮**************************
    imageAdconfiguration.customSkipView = [self customSkipView];
    //********************自定义跳过按钮*****************************end
    
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
    
}

#pragma mark - 使用默认配置快速初始化 - 示例
/**
 *  图片
 */
-(void)example06{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //使用默认配置
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = imageURL3;
    //广告点击打开链接
    imageAdconfiguration.openURLString = @"http://www.it7090.com";
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

/**
 *  视频
 */
-(void)example07{
    
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //使用默认配置
    XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration defaultConfiguration];
    //广告视频URLString/或本地视频名(请带上后缀)
    videoAdconfiguration.videoNameOrURLString = @"video0.mp4";
    ////广告点击打开链接
    videoAdconfiguration.openURLString = @"http://www.it7090.com";
    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
}

#pragma mark - 批量下载并缓存
/**
 *  批量下载并缓存图片
 */
-(void)batchDownloadImageAndCache{
    
    [XHLaunchAd downLoadImageAndCacheWithURLArray:@[[NSURL URLWithString:imageURL1],[NSURL URLWithString:imageURL2],[NSURL URLWithString:imageURL3],[NSURL URLWithString:imageURL4],[NSURL URLWithString:imageURL5]] completed:^(NSArray * _Nonnull completedArray) {
        
         /** 打印批量下载缓存结果 */
        
        //url:图片的url字符串,
        //result:0表示该图片下载失败,1表示该图片下载并缓存完成或本地缓存中已有该图片
        NSLog(@"批量下载缓存结果 = %@" ,completedArray);
    }];
}

/**
 *  批量下载并缓存视频
 */
-(void)batchDownloadVideoAndCache{
    
    [XHLaunchAd downLoadVideoAndCacheWithURLArray:@[[NSURL URLWithString:videoURL1],[NSURL URLWithString:videoURL2],[NSURL URLWithString:videoURL3]] completed:^(NSArray * _Nonnull completedArray) {

      /** 打印批量下载缓存结果 */
        
     //url:视频的url字符串,
     //result:0表示该视频下载失败,1表示该视频下载并缓存完成或本地缓存中已有该视频
     NSLog(@"批量下载缓存结果 = %@" ,completedArray);
     
     }];

}

#pragma mark - subViews
-(NSArray<UIView *> *)launchAdSubViews_alreadyView{
    
    CGFloat y = XH_IPHONEX ? 46:22;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-140, y, 60, 30)];
    label.text  = @"已预载";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
    
}

-(NSArray<UIView *> *)launchAdSubViews{
    
    CGFloat y = XH_IPHONEX ? 54 : 30;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-170, y, 60, 30)];
    label.text  = @"subViews";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
    
}

#pragma mark - customSkipView
//自定义跳过按钮
-(UIView *)customSkipView{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor orangeColor];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 1.5;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    CGFloat y = XH_IPHONEX ? 54 : 30;
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100,y, 85, 30);
    [button addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//跳过按钮点击事件
-(void)skipAction{
    
    //移除广告
    [XHLaunchAd removeAndAnimated:YES];
}

#pragma mark - XHLaunchAd delegate - 倒计时回调
/**
 *  倒计时回调
 *
 *  @param launchAd XHLaunchAd
 *  @param duration 倒计时时间
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration{
    //设置自定义跳过按钮时间
    UIButton *button = (UIButton *)customSkipView;//此处转换为你之前的类型
    //设置时间
    [button setTitle:[NSString stringWithFormat:@"自定义%lds",duration] forState:UIControlStateNormal];
}

#pragma mark - XHLaunchAd delegate - 其他

/**
 *  广告点击事件 回调
 */
- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString{
    if ([openURLString isEqualToString:kBaseURL]) {
        return;
    }
    NSLog(@"广告点击事件");
    WebViewController *VC = [[WebViewController alloc] init];
    VC.URLString = openURLString;
    //此处不要直接取keyWindow
    UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [rootVC.myNavigationController pushViewController:VC animated:YES];
}

/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  XHLaunchAd
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData{
    NSLog(@"图片下载完成/或本地图片读取完成回调");
}

/**
 *  视频本地读取/或下载完成回调
 *
 *  @param launchAd XHLaunchAd
 *  @param pathURL  视频保存在本地的path
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadFinish:(NSURL *)pathURL{
    
    NSLog(@"video下载/加载完成/保存path = %@",pathURL.absoluteString);
}

/**
 *  视频下载进度回调
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current{
    NSLog(@"总大小=%lld,已下载大小=%lld,下载进度=%f",total,current,progress);
    
}

/**
 *  广告显示完成
 */
-(void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd{
    YYWarmPromptView *contentView = [[YYWarmPromptView alloc] init];
    contentView.moreButton.hidden = NO;
    contentView.delegate = self;
    contentView.layer.cornerRadius = 4;
    contentView.layer.masksToBounds = YES;
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    modalViewController.maximumContentViewWidth = kScreenWidth;
    modalViewController.contentViewMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    [modalViewController showWithAnimated:YES completion:nil];
    
    [self checkLBSAuth];
    
    [self checkUpdate];
}

-(void)YYWarmPromptView:(YYWarmPromptView *)view didClickShowButton:(UIButton *)btn
{
    if ([YYFileCacheManager readUserDataForKey:kUserInfoKey][@"tipUrl"] == nil) {
        [QMUIModalPresentationViewController hideAllVisibleModalPresentationViewControllerIfCan];
        YYBuyMemberCardViewController *memberCardViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"memberCard"];
        UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
        [rootVC.myNavigationController pushViewController:memberCardViewController animated:YES];
    }else{
        CCWebViewController *vc = [[CCWebViewController alloc] init];
        vc.url = [YYFileCacheManager readUserDataForKey:kUserInfoKey][@"tipUrl"];
        UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
        [rootVC.myNavigationController pushViewController:vc animated:YES];
    }
//    CCWebViewController *vc = [[CCWebViewController alloc] init];
//    vc.url = @"weixin://%7b%22appid%22%3a%22wx535feea77188fcab%22%2c%22noncestr%22%3a%225c948221e4b047b47249ec05%22%2c%22package%22%3a%22Sign%3dWXPay%22%2c%22partnerid%22%3a%221488645662%22%2c%22prepayid%22%3a%22wx22143513947247678a74843a2593767339%22%2c%22sign%22%3a%224DCD3E960EEEC72C6532A5B6E8E56EAE%22%2c%22timestamp%22%3a%221553236513%22%7d";
//    UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
//    [rootVC.myNavigationController pushViewController:vc animated:YES];
}

- (void) checkLBSAuth
{
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的定位->设置->隐私->定位" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    }
    
}

-(void) checkUpdate
{
    [self Postpath:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppId]];
}

#pragma mark -- 获取数据
-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
                
                NSString* thisVersion = kAppVersion;
                
                if ([[receiveStatusDic valueForKey:@"version"] floatValue] > [thisVersion floatValue]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"发现新版本，是否要去更新？" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString  *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",kAppId];
                        
                        NSURL *url = [NSURL URLWithString:urlStr];
                        [[UIApplication sharedApplication]openURL:url];
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                    });
                }
                
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
    }];
    
}


/**
 如果你想用SDWebImage等框架加载网络广告图片,请实现此代理(实现此方法后,图片缓存将不受XHLaunchAd管理)
 
 @param launchAd          XHLaunchAd
 @param launchAdImageView launchAdImageView
 @param url               图片url
 */
//-(void)xhLaunchAd:(XHLaunchAd *)launchAd launchAdImageView:(UIImageView *)launchAdImageView URL:(NSURL *)url
//{
//    [launchAdImageView sd_setImageWithURL:url];
//
//}

@end
