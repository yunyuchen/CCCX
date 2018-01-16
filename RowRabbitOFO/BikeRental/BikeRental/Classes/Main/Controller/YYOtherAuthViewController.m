//
//  YYOtherAuthViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/11/28.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYOtherAuthViewController.h"
#import "YYCompanyAuthRequest.h"
#import "QDSingleImagePickerPreviewViewController.h"
#import "YYNavigationController.h"
#import "Helper.h"
#import "UIImage+YYExtension.h"

@interface YYOtherAuthViewController ()<QDSingleImagePickerPreviewViewControllerDelegate,QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,UINavigationControllerDelegate,
UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet QMUITextField *realNameTextField;

@property (weak, nonatomic) IBOutlet QMUITextField *idCardTextField1;

@property (weak, nonatomic) IBOutlet QMUITextField *schoolNameTextField;

@property (weak, nonatomic) IBOutlet QMUITextField *studentNoTextField;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property(nonatomic, copy) NSString *url;

@property (weak, nonatomic) IBOutlet UIView *successView;

@property (weak, nonatomic) IBOutlet QMUIFillButton *submitButton;
@end


static QMUIAlbumContentType const kAlbumContentType = QMUIAlbumContentTypeAll;

@implementation YYOtherAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"其他认证";
    self.extendedLayoutIncludesOpaqueBars = NO;
    if (self.preState) {
        self.successView.hidden = NO;
        self.submitButton.hidden = YES;
        
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(15, 15) tintColor:[UIColor qmui_colorWithHexString:@"#000000"]]  style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
//        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
        
    }
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"21返回"] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backButton setTitleColor:[UIColor colorWithHexString:@"#404040"] forState:UIControlStateNormal];
    backButton.width = 100;
    backButton.height = 30;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(navGoBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
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


- (void) dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonClick:(id)sender {
    if (self.realNameTextField.text.qmui_trim.length <= 0) {
        [QMUITips showWithText:@"请输入您的真实姓名" inView:self.view hideAfterDelay:2];
        return;
    }
    if (self.idCardTextField1.text.qmui_trim.length <= 0) {
        [QMUITips showWithText:@"请输入身份证号" inView:self.view hideAfterDelay:2];
        return;
    }
    if (self.schoolNameTextField.text.qmui_trim.length <= 0) {
        [QMUITips showWithText:@"请输入单位名称" inView:self.view hideAfterDelay:2];
        return;
    }
    if (self.studentNoTextField.text.qmui_trim.length <= 0) {
        [QMUITips showWithText:@"请输入工号" inView:self.view hideAfterDelay:2];
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
    
    YYCompanyAuthRequest *request = [[YYCompanyAuthRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCompanyAuthAPI];
    request.name = self.realNameTextField.text;
    request.idcard = self.idCardTextField1.text;
    request.company = self.schoolNameTextField.text;
    request.comnum = self.studentNoTextField.text;
    request.comimg = self.url;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.successView.hidden = NO;
            weakSelf.submitButton.hidden = YES;
        }else{
            [QMUITips showError:message inView:weakSelf.view hideAfterDelay:2];
        }
    } error:^(NSError *error) {
        
    }];
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

-(void)navGoBack
{
    if (self.successView.hidden == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
