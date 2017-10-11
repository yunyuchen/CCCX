//
//  MySearchBar.m
//  MyFeel
//
//  Created by qf on 15-10-21.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "YYSearchBar.h"
#import "YYColor.h"

@implementation YYSearchBar

-(id)initWithFrame:(CGRect)frame
{   
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

-(void) layoutSubviews
{
    
    [super layoutSubviews];
    UITextField *searchField;
    
    //ios7
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0)
        searchField = [self.subviews objectAtIndex:1];
    else{
        searchField = [((UIView *)[self.subviews objectAtIndex:0]).subviews lastObject];
    }
    
    //获取到的是输入框的话
    if([searchField isKindOfClass:[UITextField class]]){
        //searchField.placeholder = @"请输入您要搜索的店铺";
        
        //设置圆角
        searchField.layer.cornerRadius = 6;
        
        //设置边框
//        searchField.layer.borderWidth = 1;
//        searchField.layer.borderColor = [UIColor colorWithRed:206 / 255.0 green:206 / 255.0 blue:206 / 255.0 alpha:1].CGColor;
    }
    //获取到的是按钮的话
    else if([searchField isKindOfClass:[UIButton class]]){
        [searchField setTintColor:YYRGBColor(254, 110, 11)];
    }
    
}

-(void)setCanselBtnTitle:(NSString *)title
{
    for (UIView *view in [[self.subviews lastObject] subviews]) {

        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:title forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelBtn setTintColor:YYRGBColor(254, 110, 11)];
        }
    }
}

-(void)changeBackground:(UIColor *)color
{
    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    if ([ self respondsToSelector : @selector (barTintColor)]) {
        float  iosversion7_1 = 7.1 ;
        if (version >= iosversion7_1)
        {
            //iOS7.1
            [[[[ self . subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
            [ self setBackgroundColor :color];
        }
        else
        {
            //iOS7.0
            [ self setBarTintColor :[ UIColor clearColor ]];
            [ self setBackgroundColor :color];
        }
    }
    else
    {
        //iOS7.0 以下
        [[ self . subviews objectAtIndex : 0 ] removeFromSuperview ];
        [ self setBackgroundColor :color];
    }
}


@end
