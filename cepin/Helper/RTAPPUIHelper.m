//
//  RTAPPUIHelper.m
//  Daishu
//
//  Created by Ricky Tang on 14-3-17.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "RTAPPUIHelper.h"
#import "FUILineButton.h"
#import "CPCommon.h"
@interface CPWNavigationBackButton : UIButton

@end
@implementation CPWNavigationBackButton
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
@implementation RTAPPUIHelper
+(id)shareInstance
{
    static RTAPPUIHelper *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = self.new;
    });
    return shareInstance;
}
+(void)appearence
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add" alpha:1.0] cornerRadius:0] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    if ( [[UIDevice currentDevice] systemName].floatValue > 8.0 )
        [[UINavigationBar appearance] setTranslucent:NO];
}
+(void)appearenceForSearch
{
//    if (IsIOS7) {
//        //customize the title text for *all* UINavigationBars为所有导航栏设置标题文本
//        [[UINavigationBar appearance] setTitleTextAttributes:
//         [NSDictionary dictionaryWithObjectsAndKeys:
//          [UIColor whiteColor],NSForegroundColorAttributeName,
//          [UIFont fontWithName:@"Arial-Bold" size:0],NSFontAttributeName, nil]];
//    }else{
//
//    }
}
-(instancetype)init{
    if (self = [super init]) {
        
        _backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];

        _whiteColor = [UIColor colorWithHexString:@"ffffff"];
        _transparentWhiteColor = [UIColor colorWithWhite:255 alpha:0.6];
        
        _lineColor = [UIColor colorWithHexString:@"ede3e6"];
        _lineWidth = 1;
        
        _cornerRadius = 3;
        _shadeColor = [UIColor colorWithHexString:@"f0eff5"];

        _grapColor = [UIColor colorWithHexString:@"eeeeee"];
        _darkGrayColor = [UIColor colorWithHexString:@"f8f8f8"];
        _greenColor = [UIColor colorWithHexString:@"2bb559"];
        _blueColor = [UIColor colorWithHexString:@"c8e1f6"];
        _lightBlueColor = [UIColor colorWithHexString:@"f0f4f8"];
        _redColor = [UIColor colorWithHexString:@"f47e7e"];
        _darkRedColor = [UIColor colorWithHexString:@"ff3535"];
        
        _orangeColor = [UIColor colorWithHexString:@"fb6e52"];
        _companyColor = [UIColor colorWithHexString:@"707070"];
        
#pragma mark - 修改字体大小
//        _bigTitleFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:15]:[UIFont fontWithName:@"HelveticaNeue" size:18];
        _bigTitleFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:20.0]:[UIFont fontWithName:@"HelveticaNeue" size:18];
        _mainTitleColor = [UIColor colorWithHexString:@"404040"];
        _mainTitleFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:42 / CP_GLOBALSCALE]:[UIFont fontWithName:@"HelveticaNeue" size:14.4];
        
        _subTitleFont = IS_IPHONE_5?[UIFont systemFontOfSize:9]:[UIFont systemFontOfSize:11];
        _subTitleColor = [UIColor colorWithHexString:@"9d9d9d"];
        //[UIFont systemFontOfSize:11]
        ;
        
#pragma mark - 修改字体大小
//        _titleFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:11]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        _titleFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:16.0]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        
        _recommendCompanyNameFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:14.0]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        
        _recommendJobNameFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:16.0]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        
        _recommendWelfareFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:12.0]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        
        _recommendWorkAddressFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:14.0]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        
        _recommendJobPublishTimeFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:12.0]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        
        _recommendBlockTitleFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:14.0]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        
        _jobInformationTitleFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:16.0]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        
        _jobInformationPositionFont = IS_IPHONE_5?[UIFont fontWithName:@"HelveticaNeue" size:20.0]:[UIFont fontWithName:@"HelveticaNeue" size:12.6];
        
        _jobInformationSaleFont = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        
        _jobInformationDetaillFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        
        _jobInformationCompanyFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        
        _jobInformationPositionDetailFont = [UIFont fontWithName:@"HelveticaNeue" size: 42 / CP_GLOBALSCALE];
        
        _jobInformationPositionDetailContentFont = [UIFont fontWithName:@"HelveticaNeue" size:10.5];
        
        _jobInformationDeliverButtonFont = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        
        _jobInformationTemptationFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        
        _companyInformationNameFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        
        _companyInformationIndustryFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        
        _companyInformationNatureFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        
        _companyInformationIntroduceFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];;
        
        _companyInformationIntroduceTitleFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        
        _searchResultTipsHeadFont = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        
        _searchResultTipsEndFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        
        _searchResultSubFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        _searchResultSubColor = [UIColor colorWithHexString:@"9d9d9d"];
        
        
        _profileResumeNameFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        _profileResumeStatueFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        _profileResumeMessageFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        _profileResumeOperationFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        _profileBaseInformatonFont = [UIFont fontWithName:@"HelveticaNeue" size:40 / 3.0];
        _profileBaseInformationRFont = [UIFont fontWithName:@"HelveticaNeue" size:42 / 3.0];
        _profileNameFont = [UIFont fontWithName:@"HelveticaNeue" size:48 / 3.0];
        
        _profileResumeNameColor = [UIColor colorWithHexString:@"404040"];
        _profileResumeStatueColor = [UIColor colorWithHexString:@"5dc4bb"];
        _profileResumeMessageColor = [UIColor colorWithHexString:@"9d9d9d"];
        _profileBaseInformatonColor = [UIColor colorWithHexString:@"9d9d9d"];
        _profileBaseInformationRColor = [UIColor colorWithHexString:@"404040"];
        _profileNameColor = [UIColor colorWithHexString:@"404040"];
        _orangeWordColor = [UIColor colorWithHexString:@"fba15e"];
        
        _blueWordColor = [UIColor colorWithHexString:@"2492f4"];
        _blueWordFont = [UIFont systemFontOfSize:14];
        
        _linkedWordsFont = [UIFont systemFontOfSize:14];
        _linkedWordsColor = [UIColor colorWithHexString:@"172643"];
        
        _lessWordsFont = [UIFont systemFontOfSize:12];
        
        
        _buttonFont = [UIFont systemFontOfSize:16];
        _buttonColor = [UIColor colorWithHexString:@"ffffff"];
        _buttonHightedColor = [UIColor colorWithHexString:@"fba15e"];
        _buttonEnableColor = _buttonHightedColor;
        
        _buttonGrayColor = [UIColor colorWithHexString:@"e8e8e8"];
        _buttonHightedColor = [UIColor colorWithHexString:@"ffffff"];
        
        _buttonGreenColor = [UIColor colorWithHexString:@"47d0ad"];
        _buttonHightedColor = [UIColor greenColor];
        
          _labelColorBlue = [UIColor colorWithHexString:@"4bc4bb"];
//        _labelColorBlue = [UIColor colorWithHexString:@"81c1d7"];
        _labelColorRed = [UIColor colorWithHexString:@"d39aba"];
        _labelColorPurple = [UIColor colorWithHexString:@"a69fd5"];
        _labelColorGreen = [UIColor colorWithHexString:@"5bc4bb"];
        _labelColorOrange = [UIColor colorWithHexString:@"e9a48e"];
    }
    return self;
}
+(NSArray *)labelColors
{
    return @[[[RTAPPUIHelper shareInstance] labelColorBlue],[[RTAPPUIHelper shareInstance] labelColorRed],[[RTAPPUIHelper shareInstance] labelColorGreen],[[RTAPPUIHelper shareInstance] labelColorOrange],[[RTAPPUIHelper shareInstance] labelColorPurple]];
}
+(FUILineButton *)loginMainButtonWithButton:(FUILineButton *)btn
{
    [btn setButtonColor:[UIColor clearColor]];
    [btn setButtonHighlightedColor:[UIColor clearColor]];
    [btn setTitleColor:[[RTAPPUIHelper shareInstance] grapColor] forState:UIControlStateHighlighted];
    [btn setCornerRadius:[[RTAPPUIHelper shareInstance] cornerRadius]];
    [btn setButtonBorderColor:[[RTAPPUIHelper shareInstance] lineColor]];
    [btn setButtonBorderWidth:[[RTAPPUIHelper shareInstance] lineWidth]];
    [btn setButtonHighlightBorderColor:[[RTAPPUIHelper shareInstance] grapColor]];
    
    return btn;
}
+(UIBarButtonItem *)rightBarButtonWithTitle:(NSString *)title
{
    FUIButton *returnBtn = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnBtn setTitle:title forState:UIControlStateNormal];
    [returnBtn setTitleColor:[[RTAPPUIHelper shareInstance] buttonColor] forState:UIControlStateNormal];
    [returnBtn setTitleColor:[[RTAPPUIHelper shareInstance] buttonHightedColor] forState:UIControlStateHighlighted];
    [returnBtn setTitleColor:[[RTAPPUIHelper shareInstance] buttonEnableColor] forState:UIControlStateSelected];
    [returnBtn setTitleColor:[[RTAPPUIHelper shareInstance] buttonEnableColor] forState:UIControlStateDisabled];
    [returnBtn setBackgroundColor:[UIColor clearColor]];
    returnBtn.buttonColor = [UIColor clearColor];
    returnBtn.buttonHighlightedColor = [UIColor clearColor];
    returnBtn.cornerRadius = [[RTAPPUIHelper shareInstance] cornerRadius];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    return leftBtn;
}
+(UIBarButtonItem *)rightBarButtonWithType:(kRightButtonType)type
{
    UIImage *image = nil;
    
    switch (type) {
        case kRightButtonTypeModify:
            image = [UIImage imageNamed:@"icon_modify"];
            break;
        case kRightButtonTypeTarget:
            
            break;
            
        default:
            break;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}
+(UIBarButtonItem *)backBarButtonWith:(id)target selector:(SEL)selector {
    UIBarButtonItem *item = [RTAPPUIHelper backBarButton];
    UIButton *btn = (UIButton *)[item customView];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return item;
}
//设置标题栏
+(UIView *)initTitleWith:(id)target selector:(SEL)selector parentView:(UIView*)view title:(NSString*)titleStr
{
    //设置标题栏
    int titlehight = 66.0 / 2.0;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.viewWidth, 64)];
//    titleView.backgroundColor = RGBCOLOR(76, 185, 172);
//    titleView.backgroundColor = CPColor(76, 185, 172, 0.8);
    titleView.backgroundColor = [UIColor colorWithHexString:@"288add"];
    [view addSubview:titleView];
    //返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 64 - 44. + ( 44 - titlehight ) / 2.0, titlehight, titlehight);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:button];
    //标题
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44.0)];
    title.text = titleStr;
    [title setFont:[UIFont systemFontOfSize:20.0]];
    [title setTextColor:[UIColor whiteColor]];
    [titleView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView.mas_centerX);
//        make.top.equalTo(@( 20 ));
        make.centerY.equalTo(button.mas_centerY);
    }];

    return titleView;
}
+(UIBarButtonItem *)backBarButtonWithBlock:(void(^)(id sender))block
{
    UIBarButtonItem *item = [RTAPPUIHelper backBarButton];
    UIButton *btn = (UIButton *)[item customView];
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:block];
    return item;
}
+(UIBarButtonItem *)backBarButton
{
    int hight = 84 / ( 3.0 * ( 1 / 1.29 ) );
    CPWNavigationBackButton *button = [CPWNavigationBackButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, hight, hight);
    [button setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}
@end
