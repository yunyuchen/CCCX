//
//  YYCertificationViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/18.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYCertificationViewController.h"
#import "YYUserAuthRequest.h"
#import "Helper.h"
#import "QDSingleImagePickerPreviewViewController.h"
#import "YYNavigationController.h"
#import "UIImage+YYExtension.h"
#import "YYCollegeAuthRequest.h"
#import <QMUIKit/QMUIKit.h>

@interface YYCertificationViewController ()<QDSingleImagePickerPreviewViewControllerDelegate,QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,assign) CGFloat angle;

@property (nonatomic,strong) UIImageView *tranformImageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *idcardTextField;

//芝麻认证
@property (weak, nonatomic) IBOutlet QMUIButton *sesameButton;
//学生证认证
@property (weak, nonatomic) IBOutlet QMUIButton *studentCardButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sesameLeadingCons;

@property (weak, nonatomic) IBOutlet QMUITextField *realNameTextField;

@property (weak, nonatomic) IBOutlet QMUITextField *idCardTextField1;

@property (weak, nonatomic) IBOutlet QMUITextField *schoolNameTextField;

@property (weak, nonatomic) IBOutlet QMUITextField *studentNoTextField;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property(nonatomic, copy) NSString *url;

@property (weak, nonatomic) IBOutlet UIView *successView;


@property (weak, nonatomic) IBOutlet UIButton *otherAuthButton;

@end

static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeAll;

@implementation YYCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTopView];
    
    self.sesameButton.imagePosition = QMUIButtonImagePositionTop;
    self.sesameButton.spacingBetweenImageAndTitle = 10;
    self.studentCardButton.imagePosition = QMUIButtonImagePositionTop;
    self.studentCardButton.spacingBetweenImageAndTitle = 10;
    self.sesameLeadingCons.constant = -kScreenWidth;
    if (self.preState) {
        self.successView.hidden = NO;
        self.otherAuthButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpTopView
{
    CGFloat margin = (kScreenWidth - 2 * 50) / 4;
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"通过"]];
    imageView1.left = 50;
    imageView1.top = 80;
    [self.topView addSubview:imageView1];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView1.frame) + 8, 68, 20)];
    label1.centerX = imageView1.centerX;
    label1.text = @"手机绑定";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor colorWithHexString:@"#F08300"];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label1];
    
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame), imageView1.top, margin, 20)];
    [self.topView addSubview:sep1];
    UIImageView *arrwowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头11"]];
    arrwowImage.centerX = sep1.width * 0.5;
    arrwowImage.centerY = sep1.height * 0.5;
    [sep1 addSubview:arrwowImage];
    
    
    UIButton *step2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    step2Button.left = CGRectGetMaxX(sep1.frame);
    step2Button.top = 80;
    step2Button.layer.cornerRadius = 10;
    step2Button.layer.masksToBounds = YES;
    step2Button.width = step2Button.height = 20;
    [step2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    step2Button.titleLabel.font = [UIFont systemFontOfSize:12];
    [step2Button setBackgroundColor:[UIColor colorWithHexString:@"#B2B2B2"]];
    [step2Button setTitle:@"2" forState:UIControlStateNormal];
    [self.topView addSubview:step2Button];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(step2Button.frame) + 8, 100, 20)];
    label2.centerX = step2Button.centerX;
    label2.text = @"实名认证";
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor colorWithHexString:@"#404040"];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label2];
    
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(step2Button.frame), imageView1.top, margin, 1)];
    [self.topView addSubview:sep2];
    UIImageView *arrwowImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头22"]];
    arrwowImage1.centerX = sep1.width * 0.5;
    arrwowImage1.centerY = sep1.height * 0.5;
    [sep2 addSubview:arrwowImage1];
    
    UIButton *step3Button = [UIButton buttonWithType:UIButtonTypeCustom];
    step3Button.left = CGRectGetMaxX(sep2.frame);
    step3Button.top = 80;
    step3Button.layer.cornerRadius = 10;
    step3Button.layer.masksToBounds = YES;
    step3Button.width = step3Button.height = 20;
    [step3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    step3Button.titleLabel.font = [UIFont systemFontOfSize:12];
    [step3Button setBackgroundColor:[UIColor colorWithHexString:@"#B2B2B2"]];
    [step3Button setTitle:@"3" forState:UIControlStateNormal];
    [self.topView addSubview:step3Button];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(step3Button.frame) + 8, 68, 20)];
    label3.centerX = step3Button.centerX;
    label3.text = @"押金充值";
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = [UIColor colorWithHexString:@"#404040"];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label3];
    
    
    UIView *sep3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(step3Button.frame), imageView1.top, margin, 1)];
    [self.topView addSubview:sep3];
    UIImageView *arrwowImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头22"]];
    arrwowImage2.centerX = sep1.width * 0.5;
    arrwowImage2.centerY = sep1.height * 0.5;
    [sep3 addSubview:arrwowImage2];
    
    UIButton *step4Button = [UIButton buttonWithType:UIButtonTypeCustom];
    step4Button.left = CGRectGetMaxX(sep3.frame);
    step4Button.top = 80;
    step4Button.layer.cornerRadius = 10;
    step4Button.layer.masksToBounds = YES;
    step4Button.width = step4Button.height = 20;
    [step4Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    step4Button.titleLabel.font = [UIFont systemFontOfSize:12];
    [step4Button setBackgroundColor:[UIColor colorWithHexString:@"#B2B2B2"]];
    [step4Button setTitle:@"4" forState:UIControlStateNormal];
    [self.topView addSubview:step4Button];
    
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(step4Button.frame) + 8, 68, 20)];
    label4.centerX = step4Button.centerX;
    label4.text = @"开始用车";
    label4.font = [UIFont systemFontOfSize:12];
    label4.textColor = [UIColor colorWithHexString:@"#404040"];
    label4.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:label4];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"28背景02"]];
    arrowImageView.centerY = self.topView.height - arrowImageView.height * 0.5;
    arrowImageView.centerX = self.tranformImageView.centerX;
    [self.view addSubview:arrowImageView];
}

-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.02];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.tranformImageView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void) endAnimation
{
    _angle += 10;
    [self startAnimation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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


- (IBAction)okButtonClick:(id)sender {
    //芝麻信用认证
    if (self.sesameButton.selected) {
        if (![Helper justIdentityCard:self.idcardTextField.text]) {
            [QMUITips showWithText:@"请输入正确的身份证号" inView:self.view hideAfterDelay:2];
            return;
        }
        YYUserAuthRequest *request = [[YYUserAuthRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserAuthAPI];
        request.idcard = self.idcardTextField.text;
        request.name = self.nameTextField.text;
        WEAK_REF(self);
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                if ([response[@"zmstate"] integerValue] == 1) {
                    [weak_self performSegueWithIdentifier:@"finish" sender:self];
                }else{
                    [weak_self performSegueWithIdentifier:@"charge" sender:self];
                }
            }else{
                [QMUITips showError:message inView:weak_self.view hideAfterDelay:2];
            }
        } error:^(NSError *error) {
            
        }];
    }else{
        if (self.realNameTextField.text.qmui_trim.length <= 0) {
            [QMUITips showWithText:@"请输入您的真实姓名" inView:self.view hideAfterDelay:2];
            return;
        }
        if (self.idCardTextField1.text.qmui_trim.length <= 0) {
            [QMUITips showWithText:@"请输入身份证号" inView:self.view hideAfterDelay:2];
            return;
        }
        if (self.schoolNameTextField.text.qmui_trim.length <= 0) {
            [QMUITips showWithText:@"请输入学校名称" inView:self.view hideAfterDelay:2];
            return;
        }
        if (self.studentNoTextField.text.qmui_trim.length <= 0) {
            [QMUITips showWithText:@"请输入学号" inView:self.view hideAfterDelay:2];
            return;
        }
        if (self.url.length <= 0) {
           [QMUITips showWithText:@"请上传证件照" inView:self.view hideAfterDelay:2];
            return;
        }
        
        if (![Helper justIdentityCard:self.idCardTextField1.text]) {
            QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
            contentView.minimumSize = CGSizeMake(100, 100);
            [QMUITips showWithText:@"请输入正确的身份证号" inView:self.view hideAfterDelay:2];
            return;
        }
        
        YYCollegeAuthRequest *request = [[YYCollegeAuthRequest alloc] init];
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kcollegeAuthAPI];
        request.name = self.realNameTextField.text;
        request.idcard = self.idCardTextField1.text;
        request.college = self.schoolNameTextField.text;
        request.colnum = self.studentNoTextField.text;
        request.img = self.url;
        __weak __typeof(self)weakSelf = self;
       [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                weakSelf.successView.hidden = NO;
                weakSelf.otherAuthButton.hidden = YES;
            }else{
                [QMUITips showError:message inView:weakSelf.view hideAfterDelay:2];
            }
        } error:^(NSError *error) {
            
        }];
    }
}

- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)certificateTypeButtonClick:(QMUIButton *)sender {
    if (sender.selected) {
        return;
    }
    if (sender == self.sesameButton) {
        self.studentCardButton.selected = NO;
        self.sesameButton.selected = YES;
        self.sesameLeadingCons.constant = 0;
    }else{
        self.sesameLeadingCons.constant = -kScreenWidth;
        self.studentCardButton.selected = YES;
        self.sesameButton.selected = NO;
    }
}

- (IBAction)selectPhotoButtonClick:(id)sender {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"拍照" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        UIImagePickerController *imagePickerCtr = [[UIImagePickerController alloc] init];
        imagePickerCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerCtr.allowsEditing = YES;
        [self presentViewController:imagePickerCtr animated:YES completion:^{
            imagePickerCtr.delegate = self;
        }];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"相册" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertAction *action) {
        [self authorizationPresentAlbumViewControllerWithTitle:@"选择图片"];
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"请上传您的头像" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController showWithAnimated:YES];

}



- (void)authorizationPresentAlbumViewControllerWithTitle:(NSString *)title {
    // 请求访问照片库的权限，在 iOS 8 或以上版本中可以利用这个方法弹出 Alert 询问用户是否授权
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentAlbumViewControllerWithTitle:title];
            });
        }];
    } else {
        [self presentAlbumViewControllerWithTitle:title];
    }
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = kAlbumContentType;
    albumViewController.title = title;
    YYNavigationController *navigationController = [[YYNavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastestPickerAlbumWithUserIdentify:nil];
    if (assetsGroup) {
        QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];
        
        [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
        imagePickerViewController.title = [assetsGroup name];
        [navigationController pushViewController:imagePickerViewController animated:NO];
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - <QMUIAlbumViewControllerDelegate>
- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 1;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    imagePickerViewController.allowsMultipleSelection = NO;
    return imagePickerViewController;
}

- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController {
    QDSingleImagePickerPreviewViewController *imagePickerPreviewViewController = [[QDSingleImagePickerPreviewViewController alloc] init];
    imagePickerPreviewViewController.delegate = self;
    imagePickerPreviewViewController.assetsGroup = imagePickerViewController.assetsGroup;
    imagePickerPreviewViewController.view.tag = imagePickerViewController.view.tag;
    return imagePickerPreviewViewController;
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    
}

#pragma mark --QDSingleImagePickerPreviewViewControllerDelegate
- (void)imagePickerPreviewViewController:(QDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.assetsGroup ablumContentType:kAlbumContentType userIdentify:nil];
    [self.avatarButton setImage:[imageAsset previewImage] forState:UIControlStateNormal];
    YYBaseRequest *uploadRequest = [[YYBaseRequest alloc] init];
    uploadRequest.nh_url = [NSString stringWithFormat:@"%@%@?folder=icon",kBaseURL,kUploadPhotoAPI];
    uploadRequest.nh_isPost = YES;
    uploadRequest.nh_imageArray = @[[[imageAsset previewImage] scaleFromImage:[imageAsset previewImage] toSize:CGSizeMake(200, 200)]];
    __weak __typeof(self)weakSelf = self;
    [uploadRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.url = response;
        }
   
    } error:^(NSError *error) {
        
    }];
}

//当用户选择头像完成后的代理方法回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *pickImg = info[UIImagePickerControllerOriginalImage];
        pickImg = [pickImg scaleFromImage:pickImg toSize:CGSizeMake(400, 400)];
        [self.avatarButton setImage:pickImg forState:UIControlStateNormal];
        
        YYBaseRequest *uploadRequest = [[YYBaseRequest alloc] init];
        
        uploadRequest.nh_url = [NSString stringWithFormat:@"%@%@?folder=icon",kBaseURL,kUploadPhotoAPI];
        uploadRequest.nh_isPost = YES;
        uploadRequest.nh_imageArray = @[pickImg];
        __weak __typeof(self)weakSelf = self;
        [uploadRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            
            if (success) {
                weakSelf.url = response;
            }
            DLog(@"%@",response);
        } error:^(NSError *error) {
            
        }];
    }];
}


@end
