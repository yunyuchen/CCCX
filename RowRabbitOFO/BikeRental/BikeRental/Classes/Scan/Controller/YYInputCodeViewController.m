//
//  YYInputCodeViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/22.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYInputCodeViewController.h"
#import "YYScanCodeRequest.h"
#import "YYScanResult.h"
#import "YYCreateOrderReuquest.h"
#import "YYShowBikeView.h"
#import "YYControlBikeViewController.h"
#import "YYFileCacheManager.h"
#import "YYFeeIntroViewController.h"
#import <QMUIKit/QMUIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YYInputCodeViewController ()<ShowBikeViewDelegate,AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet QMUIButton *scanButton;

@property (weak, nonatomic) IBOutlet QMUIButton *flashButton;

@property (weak, nonatomic) IBOutlet QMUITextField *bikeIdTextField;

@property (nonatomic,strong) YYScanResult *result;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@property (nonatomic,assign) BOOL lightON;
@end

@implementation YYInputCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scanButton.imagePosition = QMUIButtonImagePositionTop;
    self.flashButton.imagePosition = QMUIButtonImagePositionTop;
    self.scanButton.spacingBetweenImageAndTitle = 10;
    self.flashButton.spacingBetweenImageAndTitle = 10;
    self.inputView.layer.cornerRadius = 24;
    self.inputView.layer.masksToBounds = YES;
}

- (IBAction)confirmButtonClick:(id)sender {
    if (self.bikeIdTextField.text.length <= 0) {
        QMUITips *tips = [QMUITips createTipsToView:self.view];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(100, 100);
        [tips showWithText:@"请输入车辆ID" hideAfterDelay:2];
        return;
    }
    [self requestBikeInfo:self.bikeIdTextField.text];
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
            YYShowBikeView *showBikeView = [[YYShowBikeView alloc] init];
            showBikeView.delegate = self;
            showBikeView.result = weak_self.result;
            QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
            modalViewController.contentView = showBikeView;
            modalViewController.maximumContentViewWidth = kScreenWidth;
            modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
            [modalViewController showWithAnimated:YES completion:nil];
            self.modalPrentViewController = modalViewController;
//            if (weak_self.result.red == nil) {
//
//            }else{
//                YYShowBikeView *showBikeView = [[YYShowBikeView alloc] init];
//                showBikeView.delegate = self;
//                showBikeView.result = weak_self.result;
//                QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
//                modalViewController.contentView = showBikeView;
//                modalViewController.maximumContentViewWidth = kScreenWidth;
//                modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
//                [modalViewController showWithAnimated:YES completion:nil];
//                self.modalPrentViewController = modalViewController;
//            }
        }else{
            QMUITips *tips = [QMUITips createTipsToView:weak_self.view];
            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
            contentView.minimumSize = CGSizeMake(100, 100);
            [tips showWithText:message hideAfterDelay:2];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)YYShowBikeView:(YYShowBikeView *)showBikeView didClickOKButton:(UIButton *)okButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scanResult" object:showBikeView.result];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

-(void)YYShowBikeView:(YYShowBikeView *)showBikeView didClickCancelButton:(UIButton *)cancelButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        //[self reStartDevice];
    }];
}


//-(void)YYShowBikeView:(YYShowBikeView *)showBikeView didClickOKButton:(UIButton *)okButton
//{
//    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
//        YYCreateOrderReuquest *request = [[YYCreateOrderReuquest alloc] init];
//        request.sid = showBikeView.result.sid;
//        request.bid = showBikeView.result.ID;
//        request.deviceid = showBikeView.result.deviceid;
//        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreateOrderAPI];
//        WEAK_REF(self);
//        QMUITips *tips = [QMUITips createTipsToView:self.view];
//        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
//        contentView.minimumSize = CGSizeMake(100, 100);
//        [tips showLoading];
//
//        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//            [tips hideAnimated:YES];
//            if (success) {
//                NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"启动成功" withExtension:@".wav"];
//                weak_self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
//                weak_self.audioPlayer.numberOfLoops = 0;
//                weak_self.audioPlayer.delegate = weak_self;
//                [weak_self.audioPlayer play];
//                YYControlBikeViewController *controlBikeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"controlBike"];
//                controlBikeViewController.last_mileage = showBikeView.result.last_mileage;
//                controlBikeViewController.deviceid = showBikeView.result.deviceid;
//                controlBikeViewController.ID = showBikeView.result.ID;
//                controlBikeViewController.name = showBikeView.result.name;
//                [YYFileCacheManager saveUserData:showBikeView.result.bleid forKey:KBLEIDKey];
//                [weak_self.navigationController pushViewController:controlBikeViewController animated:YES];
//
//            }else{
//                QMUITips *tips = [QMUITips createTipsToView:weak_self.view];
//                QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
//                contentView.minimumSize = CGSizeMake(100, 100);
//                [tips showError:message hideAfterDelay:2];
//            }
//        } error:^(NSError *error) {
//            [tips hideAnimated:YES];
//        }];
//    }];
//}
//
//-(void)YYShowBikeView:(YYShowBikeView *)showBikeView didClickCancelButton:(UIButton *)cancelButton
//{
//    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
//
//    }];
//}

-(void)YYShowBikeView:(YYShowBikeView *)showBikeView didClickFeeButton:(UIButton *)okButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
        YYFeeIntroViewController *feeIntroViewController = [[YYFeeIntroViewController alloc] init];
        [self.navigationController pushViewController:feeIntroViewController animated:YES];
    }];
  
}

- (IBAction)scanButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)flashButtonClick:(id)sender {
    AVCaptureDevice *device =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device hasFlash])
    {
        if (!self.lightON) {
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];
            [device unlockForConfiguration];
            self.lightON = YES;
            [self.flashButton setImage:[UIImage imageNamed:@"手电筒2"] forState:UIControlStateNormal];
        }else{
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
            self.lightON = NO;
            [self.flashButton setImage:[UIImage imageNamed:@"手电筒"] forState:UIControlStateNormal];
        }
    }
}


@end
