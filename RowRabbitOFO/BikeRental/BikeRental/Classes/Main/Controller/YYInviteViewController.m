//
//  YYInviteViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/7/20.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYInviteViewController.h"
#import "YYInviteRuleView.h"
#import "YYBaseRequest.h"
#import <QMUIKit/QMUIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface YYInviteViewController ()

@property (weak, nonatomic) IBOutlet QMUIButton *wechatButton;

@property (weak, nonatomic) IBOutlet QMUIButton *timeLineButton;

@property (weak, nonatomic) IBOutlet QMUIButton *qqButton;

@property (weak, nonatomic) IBOutlet QMUIButton *qZoneButton;

@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLabel;

@property (weak, nonatomic) IBOutlet QMUILabel *cpLabel;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation YYInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cpLabel.canPerformCopyAction = YES;
    self.wechatButton.imagePosition = QMUIButtonImagePositionTop;
    self.wechatButton.spacingBetweenImageAndTitle = 10;
    self.timeLineButton.imagePosition = QMUIButtonImagePositionTop;
    self.timeLineButton.spacingBetweenImageAndTitle = 10;
    self.qqButton.imagePosition = QMUIButtonImagePositionTop;
    self.qqButton.spacingBetweenImageAndTitle = 10;
    self.qZoneButton.imagePosition = QMUIButtonImagePositionTop;
    self.qZoneButton.spacingBetweenImageAndTitle = 10;
    
    UIButton *ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleButton.frame = CGRectMake(0, 0, 120, 80);
    ruleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [ruleButton setTitle:@"活动规则" forState:UIControlStateNormal];
    [ruleButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [ruleButton setTitleColor:[UIColor colorWithHexString:@"#404040"] forState:UIControlStateNormal];
    [ruleButton addTarget:self action:@selector(ruleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ruleButton];
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106290470"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
   [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx535feea77188fcab" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    self.inviteCodeLabel.text = [NSString stringWithFormat:@"你的邀请码：%04ld（长按可复制）",(long)self.userId];
    self.cpLabel.text = [NSString stringWithFormat:@"%ld",self.userId];
    [self requestInviteInfo];
    // Do any additional setup after loading the view.
}

-(void) requestInviteInfo
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kInviteInfoAPI];
    WEAK_REF(self);
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            
            weak_self.infoLabel.text = [NSString stringWithFormat:@"已成功推荐%@人，累计获得奖励%@元",response[@"cnt"],response[@"total"]];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void) ruleButtonClick:(UIButton *)sender
{
    YYInviteRuleView *inviteRuleView = [[YYInviteRuleView alloc] init];
  
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = inviteRuleView;
    modalViewController.maximumContentViewWidth = kScreenWidth;
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
    [modalViewController showWithAnimated:YES completion:nil];
    self.modalPrentViewController = modalViewController;
    inviteRuleView.myBlock = ^(){
       [self.modalPrentViewController hideWithAnimated:YES completion:nil];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wechatButtonClick:(id)sender {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"叮当一下，快乐出行" descr:@"邀请好友注册就送5元红包,认证再送5元红包" thumImage:[UIImage imageNamed:@"logo"]];
    //设置网页地址
    shareObject.webpageUrl =[NSString stringWithFormat:@"http://zc.51xytu.com/htm/invite.htm?inviteid=%ld",self.userId];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
       
            
        }
    }];
}

- (IBAction)timeLineButtonClick:(id)sender {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"叮当一下，快乐出行" descr:@"邀请好友注册就送5元红包,认证再送5元红包" thumImage:[UIImage imageNamed:@"logo"]];
    //设置网页地址
    shareObject.webpageUrl =[NSString stringWithFormat:@"http://zc.51xytu.com/htm/invite.htm?inviteid=%ld",self.userId];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            
        }
    }];
}

- (IBAction)qqButtonClick:(id)sender {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"叮当一下，快乐出行" descr:@"邀请好友注册就送5元红包,认证再送5元红包" thumImage:[UIImage imageNamed:@"logo"]];
    //设置网页地址
    shareObject.webpageUrl =[NSString stringWithFormat:@"http://zc.51xytu.com/htm/invite.htm?inviteid=%ld",self.userId];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            
        }
    }];
}

- (IBAction)qZoneButtonClick:(id)sender {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"叮当一下，快乐出行" descr:@"邀请好友注册就送5元红包,认证再送5元红包" thumImage:[UIImage imageNamed:@"logo"]];
    //设置网页地址
    shareObject.webpageUrl =[NSString stringWithFormat:@"http://zc.51xytu.com/htm/invite.htm?inviteid=%ld",self.userId];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            
        }
    }];
}


@end
