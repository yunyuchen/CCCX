//
//  YYScanViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/22.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYScanViewController.h"
#import "StyleDIY.h"
#import "YYScanCodeRequest.h"
#import "YYScanResult.h"
#import "YYCreateOrderReuquest.h"
#import "YYShowBikeView.h"
#import "YYControlBikeViewController.h"
#import "YYFileCacheManager.h"
#import <QMUIKit/QMUIKit.h>

@interface YYScanViewController ()<ShowBikeViewDelegate>

@property (weak, nonatomic) IBOutlet QMUIButton *inputBikeNoButton;

@property (weak, nonatomic) IBOutlet QMUIButton *flashButton;

@property (weak, nonatomic) IBOutlet UIView *leftBottomView;

@property (weak, nonatomic) IBOutlet UIView *rightBottomView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (nonatomic,strong) YYScanResult *result;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation YYScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.libraryType = SLT_Native;
    self.scanCodeType = SCT_QRCode;
    self.cameraInvokeMsg = @"相机启动中";
    self.qRScanView.layer.cornerRadius = 5;
    self.style = [StyleDIY recoCropRect];
    
    self.inputBikeNoButton.imagePosition = QMUIButtonImagePositionTop;
    self.flashButton.imagePosition = QMUIButtonImagePositionTop;
    self.inputBikeNoButton.spacingBetweenImageAndTitle = 10;
    self.flashButton.spacingBetweenImageAndTitle = 10;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawTitle];
    
    [self.view bringSubviewToFront:self.closeButton];
    [self.view bringSubviewToFront:self.leftBottomView];
    [self.view bringSubviewToFront:self.rightBottomView];
    [self.view bringSubviewToFront:self.logoImageView];
    [self.view bringSubviewToFront:self.titleLabel];
}

-(void) drawTitle
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    titleLabel.centerX = kScreenWidth * 0.5;
    titleLabel.centerY = CGRectGetMinY(self.leftBottomView.frame) - 20;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"对准车牌上的二维码，即可自动扫描";
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:titleLabel];
    [self.view bringSubviewToFront:titleLabel];
}

- (IBAction)dismissButtonClick:(id)sender {
    [self stopScan];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)flashButtonClick:(id)sender {
    [self openOrCloseFlash];
}


- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        return;
    }
    
    //震动提醒
    // [LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    [self requestBikeInfo:strResult];
}

-(void) requestBikeInfo:(NSString *)code
{
    YYScanCodeRequest *request = [[YYScanCodeRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kScanCodeAPI];
    request.code = code;
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weak_self.result = [YYScanResult modelWithDictionary:response];
            
            if (weak_self.result.red == nil) {
                
            }else{
                YYShowBikeView *showBikeView = [[YYShowBikeView alloc] init];
                showBikeView.delegate = self;
                showBikeView.result = weak_self.result;
                QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
                modalViewController.contentView = showBikeView;
                modalViewController.maximumContentViewWidth = kScreenWidth;
                modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
                [modalViewController showWithAnimated:YES completion:nil];
                self.modalPrentViewController = modalViewController;
            }
        }else{
            QMUITips *tips = [QMUITips createTipsToView:weak_self.view];
            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
            contentView.minimumSize = CGSizeMake(100, 100);
            [tips showWithText:message hideAfterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weak_self reStartDevice];
            });
        }
    } error:^(NSError *error) {
        
    }];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];
    
    if (self.isOpenFlash)
    {
        [self.flashButton setImage:[UIImage imageNamed:@"手电筒2"] forState:UIControlStateNormal];
    }
    else{
        [self.flashButton setImage:[UIImage imageNamed:@"手电筒"] forState:UIControlStateNormal];
    }
}

-(void)YYShowBikeView:(YYShowBikeView *)showBikeView didClickOKButton:(UIButton *)okButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        YYCreateOrderReuquest *request = [[YYCreateOrderReuquest alloc] init];
        request.sid = showBikeView.result.sid;
        request.bid = showBikeView.result.ID;
        request.deviceid = showBikeView.result.deviceid;
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreateOrderAPI];
        WEAK_REF(self);
        QMUITips *tips = [QMUITips createTipsToView:self.view];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(100, 100);
        [tips showLoading];
        
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            [tips hideAnimated:YES];
            if (success) {
                NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"启动成功" withExtension:@".wav"];
                weak_self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
                weak_self.audioPlayer.numberOfLoops = 0;
                [weak_self.audioPlayer play];
                
                YYControlBikeViewController *controlBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"controlBike"];
                controlBikeViewController.last_mileage = showBikeView.result.last_mileage;
                controlBikeViewController.deviceid = showBikeView.result.deviceid;
                controlBikeViewController.ID = showBikeView.result.ID;
                controlBikeViewController.name = showBikeView.result.name;
                [YYFileCacheManager saveUserData:showBikeView.result.bleid forKey:KBLEIDKey];
                [weak_self.navigationController pushViewController:controlBikeViewController animated:YES];
                
            }else{
                QMUITips *tips = [QMUITips createTipsToView:weak_self.view];
                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                contentView.minimumSize = CGSizeMake(100, 100);
                [tips showWithText:message hideAfterDelay:2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weak_self reStartDevice];
                });
            }
        } error:^(NSError *error) {
            [tips hideAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weak_self reStartDevice];
            });
        }];
    }];
}

-(void)YYShowBikeView:(YYShowBikeView *)showBikeView didClickCancelButton:(UIButton *)cancelButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        [self reStartDevice];
    }];
}


@end
