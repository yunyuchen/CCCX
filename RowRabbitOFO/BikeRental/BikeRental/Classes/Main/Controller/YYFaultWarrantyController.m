//
//  YYFaultWarrantyController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/27.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYFaultWarrantyController.h"
#import "YYBaseRequest.h"
#import "YYFeedBackRequest.h"
#import "UIImage+Size.h"


@interface YYFaultWarrantyController()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet QMUITextField *bikeIDTextField;

@property (weak, nonatomic) IBOutlet UIView *bikeIDView;

@property (weak, nonatomic) IBOutlet UIView *bikeFaultView;

@property (weak, nonatomic) IBOutlet UIView *useFaultView;

@property (weak, nonatomic) IBOutlet UIView *partsFaultView;

@property (weak, nonatomic) IBOutlet QMUITextView *additionalTextView;

@property (weak, nonatomic) IBOutlet UILabel *textNumLabel;

@property(nonatomic, strong) UIButton *selectedBikeFaultButton;

@property(nonatomic, strong) UIButton *selectedUseFaultButton;

@property(nonatomic, strong) UIButton *selectedPartsFaultButton;

@end

#define kMaxTextCount 140
@implementation YYFaultWarrantyController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"故障保修";

    [self setupControls];
}

- (void) setupControls
{
    self.bikeIDView.layer.cornerRadius = 22;
    self.bikeIDView.layer.masksToBounds = YES;
    self.showInView = self.contentView;
    self.maxCount = 1;
    [self initPickerView];
    
    self.pickerCollectionView.backgroundColor = [UIColor clearColor];
    self.additionalTextView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
    for (UIView *view in self.bikeFaultView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton *)view).layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
        }
    }
    for (UIView *view in self.useFaultView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton *)view).layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
        }
    }
    for (UIView *view in self.partsFaultView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton *)view).layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
        }
    }
    
}

- (IBAction)bikeFaultButtonClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.selectedBikeFaultButton.selected = NO;
    self.selectedBikeFaultButton.layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
    sender.layer.borderColor = [UIColor qmui_colorWithHexString:@"#F08300"].CGColor;
    sender.selected = YES;
    self.selectedBikeFaultButton = sender;
    
}

- (IBAction)useFaultButtonClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.selectedUseFaultButton.selected = NO;
    self.selectedUseFaultButton.layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
    sender.layer.borderColor = [UIColor qmui_colorWithHexString:@"#F08300"].CGColor;
    sender.selected = YES;
    self.selectedUseFaultButton = sender;
}

- (IBAction)partsFaultButtonClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.selectedPartsFaultButton.selected = NO;
    self.selectedPartsFaultButton.layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
    sender.layer.borderColor = [UIColor qmui_colorWithHexString:@"#F08300"].CGColor;
    sender.selected = YES;
    self.selectedPartsFaultButton = sender;
}

- (IBAction)submitButtonClick:(UIButton *)sender {
    if (self.bikeIDTextField.text.qmui_trim.length <= 0) {
        [QMUITips showWithText:@"请输入故障车辆ID" inView:self.view hideAfterDelay:2];
        return;
    }
    
    if (self.selectedPartsFaultButton == nil && self.selectedUseFaultButton == nil && self.selectedPartsFaultButton == nil) {
        [QMUITips showWithText:@"请选择您的故障问题" inView:self.view hideAfterDelay:2];
        return;
    }
    
    NSString *faultStr = @"";
    if (self.selectedBikeFaultButton) {
        faultStr = [faultStr stringByAppendingString:self.selectedPartsFaultButton.currentTitle];
    }
    if (self.selectedUseFaultButton) {
        faultStr = [faultStr stringByAppendingString:self.selectedUseFaultButton.currentTitle];
    }
    if (self.selectedPartsFaultButton) {
        faultStr = [faultStr stringByAppendingString:self.selectedPartsFaultButton.currentTitle];
    }
    if (self.additionalTextView.text.qmui_trim.length > 0) {
        faultStr = [faultStr stringByAppendingString:self.additionalTextView.text];
    }
    
    //大图数据
    NSArray *bigImageDataArray = [self getBigImageArray];
    
    //小图数组
    NSArray *smallImageArray = self.imageArray;
    
    //小图二进制数据
    NSMutableArray *smallImageDataArray = [NSMutableArray array];
    
    for (UIImage *smallImg in smallImageArray) {
        NSData *smallImgData = UIImagePNGRepresentation(smallImg);
        [smallImageDataArray addObject:smallImgData];
    }
    
    NSMutableArray *bigImageArray = [NSMutableArray array];
    
    WEAK_REF(self);
    
    [QMUITips showLoadingInView:self.view];
    
    if (self.imageArray.count <= 0) {
        YYFeedBackRequest *request = [[YYFeedBackRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFeedBackAPI];;
        request.des = faultStr;
        request.img = @"";
        request.deviceid = self.bikeIDTextField.text;
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            [QMUITips hideAllToastInView:weak_self.view animated:YES];
            if (success) {
                [QMUITips showSucceed:message inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:2];
                [weak_self.navigationController popViewControllerAnimated:YES];
            }
        } error:^(NSError *error) {
             [QMUITips hideAllToastInView:weak_self.view animated:YES];
            DLog(@"%@",error);
        }];
        
    }else{
        
        YYBaseRequest *uploadRequest = [[YYBaseRequest alloc] init];
        uploadRequest.nh_url = [NSString stringWithFormat:@"%@%@?folder=feedback",kBaseURL,kUploadPhotoAPI];
        uploadRequest.nh_isPost = YES;
        NSArray *uploadArray = [NSArray arrayWithObjects:[UIImage compressImage:self.getBigImageArray[0] toByte:1024 * 20], nil];
        uploadRequest.nh_imageArray = uploadArray;
        [uploadRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            [QMUITips hideAllToastInView:weak_self.view animated:YES];
            if (success) {
                YYFeedBackRequest *request = [[YYFeedBackRequest alloc] init];
                request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFeedBackAPI];;
                request.des = faultStr;
                request.img = [NSString stringWithFormat:@"%@",response];
                request.deviceid = self.bikeIDTextField.text;
                [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                     [QMUITips hideAllToastInView:weak_self.view animated:YES];
                    if (success) {
                        [QMUITips showSucceed:message inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:2];
                        [weak_self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            }
            
        } error:^(NSError *error) {
           [QMUITips hideAllToastInView:weak_self.view animated:YES];
            DLog(@"%@",error);
        }];
        
    }
    
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //NSLog(@"当前输入框文字个数:%ld",self.additionalTextView.text.length);
    //当前输入字数
    self.textNumLabel.text = [NSString stringWithFormat:@"(%lu/%d)",(unsigned long)self.additionalTextView.text.length,kMaxTextCount];
    if (self.additionalTextView.text.length > kMaxTextCount) {
        self.textNumLabel.textColor = [UIColor redColor];
    }else{
        self.textNumLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    return YES;
}

@end
