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
#import <QMUIKit/QMUIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YYInputCodeViewController ()<ShowBikeViewDelegate>

@property (weak, nonatomic) IBOutlet QMUIButton *scanButton;

@property (weak, nonatomic) IBOutlet QMUIButton *flashButton;

@property (weak, nonatomic) IBOutlet QMUITextField *bikeIdTextField;

@property (nonatomic,strong) YYScanResult *result;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property (nonatomic,assign) BOOL lightON;
@end

@implementation YYInputCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scanButton.imagePosition = QMUIButtonImagePositionTop;
    self.flashButton.imagePosition = QMUIButtonImagePositionTop;
    self.scanButton.spacingBetweenImageAndTitle = 10;
    self.flashButton.spacingBetweenImageAndTitle = 10;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            //NSLog(response);
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
                [tips showError:message hideAfterDelay:2];
            }
        } error:^(NSError *error) {
            [tips hideAnimated:YES];
        }];
    }];
}

-(void)YYShowBikeView:(YYShowBikeView *)showBikeView didClickCancelButton:(UIButton *)cancelButton
{
    [self.modalPrentViewController hideWithAnimated:YES completion:^(BOOL finished) {
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
