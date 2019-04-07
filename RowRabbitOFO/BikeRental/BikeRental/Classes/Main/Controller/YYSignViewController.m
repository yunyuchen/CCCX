//
//  YYSignViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2019/3/8.
//  Copyright © 2019 xinghu. All rights reserved.
//

#import "YYSignViewController.h"
#import "YYCalendarRequest.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YYScoreViewController.h"
#import "YYScoreIntroViewController.h"
#import "CCWebViewController.h"
#import "YYSignSuccessView.h"
#import <FSCalendar.h>
#import <DateTools.h>

@interface YYSignViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;
@property(nonatomic, strong) NSArray *selectedDays;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation YYSignViewController

- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return YES;
}

- (IBAction)introButtonClick:(id)sender {
    YYScoreIntroViewController *vc = [[UIStoryboard storyboardWithName:@"Score" bundle:nil] instantiateViewControllerWithIdentifier:@"sss"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)lotteryButtonClick:(id)sender {
    CCWebViewController *vc = [[CCWebViewController alloc] init];
    vc.url = @"http://api.cccx.ltd/award";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mallButtonClick:(id)sender {
    CCWebViewController *vc = [[CCWebViewController alloc] init];
    vc.url = @"http://cccx.ltd/mall/index.html";
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)initSubviews {
    [super initSubviews];
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 500 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 24, height)];
    calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:16];
    calendar.calendarWeekdayView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F2F2F2"];
    calendar.appearance.headerTitleColor = [UIColor qmui_colorWithHexString:@"#333333"];
    //calendar.appearance.head
    calendar.appearance.weekdayTextColor = [UIColor qmui_colorWithHexString:@"#404040"];
    calendar.appearance.todayColor = [UIColor qmui_colorWithHexString:@"#FF5500"];
    calendar.appearance.todaySelectionColor = [UIColor qmui_colorWithHexString:@"#FF5500"];
    calendar.appearance.titleTodayColor = [UIColor whiteColor];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.allowsSelection = NO;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.currentPage = [self.dateFormatter dateFromString:@"2016-06-01"];
    calendar.firstWeekday = 2;
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    [self.containerView addSubview:calendar];
    self.calendar = calendar;
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
}

- (void) previousClicked:(UIButton *)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value: - 1 toDate:currentMonth options:0];
    NSDate *previous2Month = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:- 2 toDate:currentMonth options:0];
    [self.previousButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",previous2Month.year,previous2Month.month] forState:UIControlStateNormal];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",(long)currentMonth.year,currentMonth.month] forState:UIControlStateNormal];
    [self.calendar setCurrentPage:previousMonth animated:YES];
    [self requestCalendar:previousMonth.year month:previousMonth.month];
}

- (void) nextClicked:(UIButton *)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *next2Month = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value: + 2 toDate:currentMonth options:0];
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value: + 1 toDate:currentMonth options:0];
    [self.previousButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",currentMonth.year,currentMonth.month] forState:UIControlStateNormal];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",next2Month.year,next2Month.month] forState:UIControlStateNormal];
    [self.calendar setCurrentPage:nextMonth animated:YES];
    [self requestCalendar:next2Month.year month:next2Month.month];
}


- (void) requestCalendar:(int)year month:(int)month
{
    self.selectedDays = [NSArray array];
    YYCalendarRequest *request = [[YYCalendarRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCalendarAPI];
    request.year = year;
    request.month = month;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            
            NSString *days = response[@"days"];
            if (days.length > 0) {
                NSArray *selectedDays = [days componentsSeparatedByString:@","];
                weakSelf.selectedDays = selectedDays;
            }
            [weakSelf.calendar reloadData];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f",self.score];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    QMUIButton *previousButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(8, 4, 95, 34);
    previousButton.backgroundColor = [UIColor whiteColor];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [previousButton setTitleColor:[UIColor qmui_colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
    previousButton.titleLabel.textColor = [UIColor qmui_colorWithHexString:@"#9b9b9b"];
    [previousButton setImage:[UIImage imageNamed:@"icon_prev"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:previousButton];
    self.previousButton = previousButton;
    
    QMUIButton *nextButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    nextButton.imagePosition = QMUIButtonImagePositionRight;
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 95 - 8 - 12, 4, 95, 34);
    nextButton.backgroundColor = [UIColor whiteColor];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [nextButton setTitleColor:[UIColor qmui_colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:nextButton];
    self.nextButton = nextButton;
    
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value: - 1 toDate:currentMonth options:0];
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:+ 1 toDate:currentMonth options:0];
    [self.previousButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",(long)previousMonth.year,(long)previousMonth.month] forState:UIControlStateNormal];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",(long)nextMonth.year,(long)nextMonth.month] forState:UIControlStateNormal];
    
    
    
    YYBaseRequest *request = [YYBaseRequest nh_requestWithUrl:[NSString stringWithFormat:@"%@%@",kBaseURL,kSignAPI]];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            YYSignSuccessView *contentView = [[YYSignSuccessView alloc] init];
            contentView.tips1Label.text = [NSString stringWithFormat:@"今日签到成功 已连续签到%d天",[response[@"signdays"] intValue]];
             contentView.tips2Label.text = [NSString stringWithFormat:@"恭喜获得%d积分",[response[@"point"] intValue]];
             contentView.tips3Label.text = [NSString stringWithFormat:@"%@",response[@"des"]];
            contentView.layer.cornerRadius = 4;
            contentView.layer.masksToBounds = YES;
            
            QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
            modalViewController.contentView = contentView;
            modalViewController.maximumContentViewWidth = kScreenWidth;
            modalViewController.contentViewMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
            [modalViewController showWithAnimated:YES completion:nil];
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:1.5];
        }
    }];
    
    [self requestCalendar:currentMonth.year month:currentMonth.month];
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)introButtonClick1:(id)sender {
    YYScoreViewController *scoreViewController = [[UIStoryboard storyboardWithName:@"Score" bundle:nil] instantiateViewControllerWithIdentifier:@"score"];
    //scoreViewController.score = self.score;
    [self.navigationController pushViewController:scoreViewController animated:YES];
}



#pragma mark - <FSCalendarDelegate>

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
//    if ([date isLaterThan:calendar.today]) {
//        return 0;
//    }
//    return 1;
    return 0;
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    if ([date isLaterThan:calendar.today]) {
        return [UIColor qmui_colorWithHexString:@"#DBD8D8"];
    }
    for (int i = 0; i < self.selectedDays.count; i++) {
        if (date.day == [self.selectedDays[i] integerValue]) {
            return [UIColor qmui_colorWithHexString:@"#FF5500"];
        }
    }
   
    return [UIColor qmui_colorWithHexString:@"#DBD8D8"];
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
{
    return [UIColor qmui_colorWithHexString:@"#FF5500"];
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date
{
    if ([date isLaterThan:calendar.today]) {
        return [UIColor qmui_colorWithHexString:@"#333333"];
    }
    for (int i = 0; i < self.selectedDays.count; i++) {
        if (date.day == [self.selectedDays[i] integerValue]) {
            return [UIColor qmui_colorWithHexString:@"#FFFFFF"];
        }
    }
   
    return [UIColor qmui_colorWithHexString:@"#333333"];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date
{
    return [UIColor qmui_colorWithHexString:@"#FF5500"];
}

- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date{
    for (int i = 0; i < self.selectedDays.count; i++) {
        if (date.day == [self.selectedDays[i] integerValue]) {
            return @[[UIColor qmui_colorWithHexString:@"#FF5500"]];
        }
    }
    return @[[UIColor qmui_colorWithHexString:@"#DCDCDC"]];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value: - 1 toDate:currentMonth options:0];
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:+ 1 toDate:currentMonth options:0];
    [self.previousButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",previousMonth.year,previousMonth.month] forState:UIControlStateNormal];
    [self.nextButton setTitle:[NSString stringWithFormat:@"%ld年%ld月",nextMonth.year,nextMonth.month] forState:UIControlStateNormal];
    
    [self requestCalendar:currentMonth.year month:currentMonth.month];
}




@end
