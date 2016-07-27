//
//  GuideStatesMv.m
//  cepin
//
//  Created by dujincai on 15/11/2.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "GuideStatesMv.h"
#import "TBAppDelegate.h"
#import "SignupGuideResumeVC.h"
#import "SchoolSignupGuideResumeVC.h"
#import "CPCommon.h"
@interface GuideStatesMv()
@property(nonatomic,strong)NSString *mobile;
@property (nonatomic, strong) NSString *comeFromString;
@end

@implementation GuideStatesMv

- (instancetype)initWithMobiel:(NSString *)mobiel
{
    self = [super init];
    if (self) {
        self.mobile = mobiel;
        [self setTitle:@"身份引导"];
        [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    }
    return self;
}
- (instancetype)initWithMobiel:(NSString *)mobiel comeFromString:(NSString *)comeFromString
{
    self = [super init];
    if ( self )
    {
        self.mobile = mobiel;
        [self setTitle:@"身份引导"];
        [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        self.comeFromString = comeFromString;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"resume_guide_launch"];
    UILabel *littleTitlLabel = [[UILabel alloc] init];
    littleTitlLabel.text = @"我们期待了解你并成为小伙伴";
    littleTitlLabel.textAlignment = NSTextAlignmentCenter;
    littleTitlLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    littleTitlLabel.textColor =[UIColor colorWithHexString:@"404040"];
    CGFloat topMarge = 343;
    if ( CP_IS_IPHONE_4_OR_LESS )
        topMarge = 180.0;
    littleTitlLabel.frame = CGRectMake(0, topMarge / CP_GLOBALSCALE + 64.0, kScreenWidth, 42 / CP_GLOBALSCALE);
    [self.view addSubview:littleTitlLabel];
    UILabel *subTitleView = [[UILabel alloc] init];
    subTitleView.text = @"你现在的状态为？";
    subTitleView.textAlignment = NSTextAlignmentCenter;
    subTitleView.font = [UIFont systemFontOfSize:60 / CP_GLOBALSCALE];
    subTitleView.textColor =[UIColor colorWithHexString:@"404040"];
    subTitleView.frame = CGRectMake(0, CGRectGetMaxY( littleTitlLabel.frame ) + 40 / CP_GLOBALSCALE, kScreenWidth, 60 / CP_GLOBALSCALE);
    [self.view addSubview:subTitleView];
    //校招图标
    UIButton *studentView = [UIButton buttonWithType:UIButtonTypeCustom];
    [studentView setImage:[UIImage imageNamed:@"guide_student"] forState:UIControlStateNormal];
    [studentView setImage:[UIImage imageNamed:@"guide_student_hover"] forState:UIControlStateHighlighted];
    [self.view addSubview:studentView];
    [studentView handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [MobClick event:@"guide_i_graduate"];
        if ( self.comeFromString && 0 < [self.comeFromString length] )
        {
            SchoolSignupGuideResumeVC *vc = [[SchoolSignupGuideResumeVC alloc] initWithMobiel:self.mobile comeFromString:self.comeFromString];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate guidResumeVC:self.mobile isSocialResume:false comeFromString:self.comeFromString];
        }
    }];
    //社招图标
    UIButton *socialView = [UIButton buttonWithType:UIButtonTypeCustom];
    [socialView setImage:[UIImage imageNamed:@"guide_worker"] forState:UIControlStateNormal];
    [socialView setImage:[UIImage imageNamed:@"guide_worker_hover"] forState:UIControlStateHighlighted];
    [self.view addSubview:socialView];
    [socialView handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [MobClick event:@"guide_i_work"];
        if ( self.comeFromString && 0 < [self.comeFromString length] )
        {
            SignupGuideResumeVC *vc = [[SignupGuideResumeVC alloc] initWithMobiel:self.mobile comeFromString:self.comeFromString];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            TBAppDelegate *delegate = (TBAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate guidResumeVC:self.mobile isSocialResume:true comeFromString:self.comeFromString];
        }
    }];
    CGFloat margin = (kScreenWidth - 320 / CP_GLOBALSCALE * 2) / 3.0;
    [studentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( self.view.mas_left ).offset( margin );
        make.width.equalTo( @( 320 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 320 / CP_GLOBALSCALE ) );
        make.top.equalTo( subTitleView.mas_bottom ).offset( 225 / CP_GLOBALSCALE );
    }];
    [socialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( studentView.mas_right ).offset( margin );
        make.width.equalTo( @( 320 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 320 / CP_GLOBALSCALE ) );
        make.top.equalTo( subTitleView.mas_bottom ).offset( 225 / CP_GLOBALSCALE );
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
@end
