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
#import "YYFeedCfgModel.h"

@interface YYFaultWarrantyController()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet QMUITextField *bikeIDTextField;

@property (weak, nonatomic) IBOutlet UIView *bikeIDView;

@property (weak, nonatomic) IBOutlet QMUITextView *additionalTextView;

@property (weak, nonatomic) IBOutlet UILabel *textNumLabel;

@property (weak, nonatomic) IBOutlet UIView *faultReasonView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faultReasonViewHeightCons;

@property(nonatomic, strong) NSArray<YYFeedCfgModel *> *models;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeightCons;

@end



#define kMaxTextCount 140
@implementation YYFaultWarrantyController

-(NSArray<YYFeedCfgModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"故障报修";
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self setupControls];
    
    [self requestFeedConfig];
}

- (void) requestFeedConfig
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFeedcfgAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            [YYFeedCfgModel setUpModelClassInArrayWithContainDict:@{@"value" : [YYCfgSubModel class]}];
            weakSelf.models = [YYFeedCfgModel modelArrayWithDictArray:response];
            
            [weakSelf createFaultButtons];
            
            QMUILog(@"%@",weakSelf.models);
        }
    }];
    
}

- (void) createFaultButtons
{
    UIButton *tmpBtn = nil;
    for (YYFeedCfgModel *model in self.models) {
        CGFloat labelY = 0;
        UILabel *label = [[UILabel alloc] init];
        label.text = model.type;
        label.textColor = [UIColor qmui_colorWithHexString:@"#404040"];
        if (tmpBtn == nil) {
            labelY = 12;
        }else{
            labelY = CGRectGetMaxY(tmpBtn.frame) + 12;
        }
        label.frame = CGRectMake(21.5, labelY, 100, 22.5);
        [self.faultReasonView addSubview:label];
        
        int j = 0;
        for (YYCfgSubModel *sub in model.value) {
            CGFloat buttonW = (kScreenWidth - 2 * 21.5 - 3 * 4.5) /  4;
            CGFloat buttonH = 40;
            CGFloat buttonX = 21.5 + (j % 4 * buttonW) + (j % 4 * 4.5);
            CGFloat buttonY = CGRectGetMaxY(label.frame) + 13 + buttonH * (j / 4) + (j / 4) * 4.5;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = sub.ID;
            button.layer.cornerRadius = 4;
            button.layer.borderWidth = 2;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            [button setTitle:sub.des forState:UIControlStateNormal];
            [button setTitleColor:[UIColor qmui_colorWithHexString:@"404040"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.faultReasonView addSubview:button];
            tmpBtn = button;
            j++;
        }
    }
    
    self.faultReasonViewHeightCons.constant = CGRectGetMaxY(tmpBtn.frame) + 12;
    self.mainViewHeightCons.constant += CGRectGetMaxY(tmpBtn.frame) + 12 - 280;
    
}

- (void) setupControls
{
    self.bikeIDView.layer.cornerRadius = 22;
    self.bikeIDView.layer.masksToBounds = YES;
    self.showInView = self.contentView;
    self.maxCount = 1;
    self.selectImageStr = @"不超过1张";
    [self initPickerView];
    
    self.pickerCollectionView.backgroundColor = [UIColor clearColor];
    self.additionalTextView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
}

- (IBAction)telButtonClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"0596-2671066" message:[NSString stringWithFormat:@"%@",@""] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"0596-2671066"]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.selected) {
        sender.layer.borderColor = [UIColor qmui_colorWithHexString:@"#DCDCDC"].CGColor;
        sender.selected = NO;
    }else{
        sender.layer.borderColor = [UIColor qmui_colorWithHexString:@"#F08300"].CGColor;
        sender.selected = YES;
    }
}


- (IBAction)submitButtonClick:(UIButton *)sender {
    if (self.bikeIDTextField.text.qmui_trim.length <= 0) {
        [QMUITips showWithText:@"请输入故障车辆ID" inView:self.view hideAfterDelay:2];
        return;
    }
    
    NSString *faultStr = @"";
    NSString *ids = @"";

    for (UIControl *ctrl in self.faultReasonView.subviews) {
        if ([ctrl isKindOfClass:[UIButton class]]) {
            if (((UIButton *)ctrl).selected) {
                if ([ids isEqualToString:@""]) {
                    ids = [ids stringByAppendingFormat:@"%ld",((UIButton *)ctrl).tag];
                }else{
                    ids = [ids stringByAppendingFormat:@",%ld",((UIButton *)ctrl).tag];
                }
                faultStr = [faultStr stringByAppendingFormat:@" %@",((UIButton *)ctrl).currentTitle];
            }
        }
  
    }

    faultStr = [faultStr stringByAppendingFormat:@"  %@",self.additionalTextView.text];
    
    if (faultStr.qmui_trim.length <= 0) {
        [QMUITips showWithText:@"请选择您要报修的问题" inView:self.view hideAfterDelay:2];
        return;
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
        request.ids = ids;
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
                request.ids = ids;
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

//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{

    //
    self.textNumLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)self.additionalTextView.text.length,kMaxTextCount];
    if (self.additionalTextView.text.length > kMaxTextCount) {
        self.textNumLabel.textColor = [UIColor redColor];
    }
    else{
        self.textNumLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
}

@end
