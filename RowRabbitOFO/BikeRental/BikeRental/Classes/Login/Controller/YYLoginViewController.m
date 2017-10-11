//
//  YYLoginViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYLoginViewController.h"
#import "YYBaseRequest.h"
#import "YYLoginRequest.h"
#import "YYSendCodeRequest.h"
#import "YYFileCacheManager.h"
#import "NSDictionary+dealNullValue.h"
#import "YYWebViewController.h"
#import "YYUserManager.h"
#import "YYPayDepositViewController.h"
#import "YYCertificationViewController.h"
#import "YYChargeViewController.h"
#import "YYReturnBikeViewController.h"
#import "YYRegisterHBView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YYUserModel.h"
#import "JPUSHService.h"
#import <QMUIKit/QMUIKit.h>

@interface YYLoginViewController ()
{
    NSString    *_previousTextFieldContent;
    UITextRange *_previousSelection;
}

//定时器
@property (nonatomic,strong) NSTimer *timer;
//倒计时时间
@property (nonatomic,assign) NSInteger time;

@property (nonatomic,strong) YYUserModel *userModel;

@property (weak, nonatomic) IBOutlet QMUITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet QMUITextField *validateCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *validateButton;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property (weak, nonatomic) IBOutlet QMUITextField *inviteCodeTextField;


@end

@implementation YYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.time = 60;
    
    self.fd_prefersNavigationBarHidden = YES;
    //[self setUpHUD];
    // Do any additional setup after loading the view from its nib.
}

-(void) setUpHUD
{
    UIView *parentView = self.view;
    QMUITips *tips = [QMUITips createTipsToView:parentView];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(90, 90);
    [tips showLoadingHideAfterDelay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//获取验证码
- (IBAction)validateButtonClick:(UIButton *)sender {
    if (self.mobileTextField.text.length <= 0) {
        QMUITips *tips = [QMUITips createTipsToView:self.view];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(200, 100);
        [tips showInfo:@"请输入电话号码" hideAfterDelay:2];
        return;
    }
    sender.userInteractionEnabled = NO;
    [sender setTitle:[NSString stringWithFormat:@"%ld S",(long)self.time] forState:UIControlStateNormal];
    
    YYBaseRequest *request = [YYBaseRequest nh_request];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kGetTokenAPI];
    
    QMUITips *tips = [QMUITips showLoadingInView:self.view];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            DLog(@"%@",response);
            [tips hideAnimated:YES];
            YYSendCodeRequest *sendCodeRequest = [[YYSendCodeRequest alloc] init];
            sendCodeRequest.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kSendCodeAPI];
            sendCodeRequest.tel = [self.mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            sendCodeRequest.c_token = response;
            [sendCodeRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                
                if (success) {
                    [QMUITips showSucceed:@"短信验证码发送成功，请注意查收" inView:self.view hideAfterDelay:2];
                    DLog(@"%@",response);
                }else{
                    [QMUITips showError:@"验证码发送失败" inView:self.view hideAfterDelay:2];
                }
                
            }];
        }
        
    }];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeText) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
}

//登录
- (IBAction)loginButtonClick:(UIButton *)sender {
    if (self.mobileTextField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入您的手机号码"];
        return;
    }
    if (self.validateCodeTextField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    
    WEAK_REF(self);
    
    YYLoginRequest *request = [[YYLoginRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kLoginBytelAPI];
    
    request.tel = [self.mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    request.code = self.validateCodeTextField.text;
    
    request.inviteid = self.inviteCodeTextField.text;
    
    [SVProgressHUD showWithStatus:@"正在登录..."];
    
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            
            [SVProgressHUD dismiss];
            
            DLog(@"%@",response);
            
            //记录用户Token
            [YYUserManager saveToken:response[@"token"]];
         
            //设置ID为别名
            //[JPUSHService setAlias:[NSString stringWithFormat:@"%@",response[@"id"]] callbackSelector:nil object:nil];
            [JPUSHService setAlias:[NSString stringWithFormat:@"%@",response[@"id"]] completion:nil seq:0];
            
            if ([response[@"register"] boolValue] == YES) {
                YYRegisterHBView *registerHBView = [[YYRegisterHBView alloc] init];
                QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
                modalViewController.contentView = registerHBView;
                modalViewController.maximumContentViewWidth = kScreenWidth;
                modalViewController.animationStyle = QMUIModalPresentationAnimationStylePopup;
                [modalViewController showWithAnimated:YES completion:nil];
                self.modalPrentViewController = modalViewController;
                registerHBView.block = ^{
                    [modalViewController hideWithAnimated:YES completion:nil];
                };
            }
            
            YYBaseRequest *request = [[YYBaseRequest alloc] init];
            
            request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
            
            [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                if (success) {
                    NSDictionary *dict = [NSDictionary nullDic:response];
                    //记录用户信息
                    [YYFileCacheManager saveUserData:dict forKey:kUserInfoKey];
                    
                    [self requestUserState];
                    //发送登录成功的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
                }
            }];
            
            
            [weak_self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
}

-(void) requestUserState
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    WEAK_REF(self);
    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(100, 100);
    [tips showLoading];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [tips hideAnimated:YES];
        if (success) {
            weak_self.userModel = [YYUserModel modelWithDictionary:response];
            
            //未交押金
            if (weak_self.userModel.dstate == 0 || weak_self.userModel.dstate == 3) {
                //payDeposit
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYPayDepositViewController *payDepositViewController = [storyboard instantiateViewControllerWithIdentifier:@"payDeposit"];
                
                [weak_self.navigationController pushViewController:payDepositViewController animated:YES];
                return;
            }
            //未认证身份
            if ([weak_self.userModel.idcard isEqualToString:@""]) {
                //Certification
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                YYCertificationViewController *certificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Certification"];
                
                [weak_self.navigationController pushViewController:certificationViewController animated:YES];
                return;
            }
 
        }
    } error:^(NSError *error) {
        [tips hideAnimated:YES];
    }];

}



//定时器改变文字
-(void) changeText
{
    self.time--;
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        self.validateButton.userInteractionEnabled = YES;
        self.validateButton.titleLabel.alpha = 1;
        [self.validateButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        return;
    }
    [self.validateButton setTitle:[NSString stringWithFormat:@"%ld S",(long)self.time] forState:UIControlStateNormal];
    
    
}

#pragma mark 处理UITextField手机号码
-(void)reformatAsPhoneNumber:(UITextField *)textField {
    /**
     *  判断正确的光标位置
     */
    NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSString *phoneNumberWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPostion];
    
    if([phoneNumberWithoutSpaces length] > 11) {
        /**
         *  避免超过11位的输入
         */
        
        [textField setText:_previousTextFieldContent];
        textField.selectedTextRange = _previousSelection;
        
        return;
    }
    
    NSString *phoneNumberWithSpaces = [self insertSpacesEveryFourDigitsIntoString:phoneNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPostion];
    
    textField.text = phoneNumberWithSpaces;
    UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
    
}

/**
 *  除去非数字字符，确定光标正确位置
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理过后的string
 */
- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i = 0; i < string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if(isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if(i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}

/**
 *  将空格插入我们现在的string 中，并确定我们光标的正确位置，防止在空格中
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理后有空格的string
 */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    
    for (NSUInteger i = 0; i <string.length; i++) {
        if(i > 0)
        {
            if(i == 3 || i == 7) {
                [stringWithAddedSpaces appendString:@" "];
                
                if(i<cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _previousSelection = textField.selectedTextRange;
    _previousTextFieldContent = textField.text;
    
    if(range.location == 0) {
        if(string.integerValue > 1)
        {
            return NO;
        }
    }
    
    return YES;
}

//监听文本框输入
-(void) textFieldDidChange:(UITextField *)textField
{
    //    if (textField.text.length >= 4) {
    //        textField.text = [textField.text substringToIndex:4];
    //        return;
    //    }
    //    if (self.mobileTextField.text.length >= 11 && self.passwordTextField.text.length >= 4) {
    //        [self.loginButton setBackgroundColor:RGB_255(254, 110, 11)];
    //        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        self.loginButton.userInteractionEnabled = YES;
    //    }else{
    //        [self.loginButton setBackgroundColor:[UIColor colorWithHexString:@"E0E0E0"]];
    //        [self.loginButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    //        self.loginButton.userInteractionEnabled = NO;
    //    }
}



- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)serviceButtonClick:(id)sender {
    YYWebViewController *webViewController = [[YYWebViewController alloc] init];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
