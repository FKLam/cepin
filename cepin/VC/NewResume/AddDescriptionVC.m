//
//  AddDescriptionVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddDescriptionVC.h"
#import "UIViewController+NavicationUI.h"
#import "AddDescriptionVM.h"
#import "TBAppDelegate.h"
#import "NSString+Extension.h"
#import "AlertDialogView.h"
#import "CPResumeGuideExperienceCityButton.h"
#import "CPTipsView.h"
#import "CPCommon.h"
@interface AddDescriptionVC ()<UITextViewDelegate, UIAlertViewDelegate, CPTipsViewDelegate>
@property(nonatomic,strong)AddDescriptionVM *viewModel;
@property(nonatomic,strong)UITextView *describeText;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UIButton *skipButton;
@property(nonatomic,assign)BOOL showRightTitle;
@property(nonatomic,strong)NSString *des;
@property (nonatomic, strong) UITextView *tipsTextField;
@property (nonatomic, strong) AlertDialogView *alertView;
@property (nonatomic, strong) CPTipsView *tipsView;
@property (nonatomic, strong) NSString *comeFromString;
@end

@implementation AddDescriptionVC
- (instancetype)initWithModelId:(NSString *)resumeId defaultDes:(NSString*)des
{
    self = [super init];
    if (self) {
        self.showRightTitle = YES;
        ResumeNameModel *model = [ResumeNameModel new];
        model.ResumeId = resumeId;
        self.viewModel = [[AddDescriptionVM alloc]initWithResumeModel:model];
        self.des = des;
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithModelId:(NSString *)resumeId showRightTitle:(BOOL)show
{
    self = [super init];
    if (self)
    {
        self.showRightTitle = show;
        ResumeNameModel *model = [ResumeNameModel new];
        model.ResumeId = resumeId;
        self.viewModel = [[AddDescriptionVM alloc]initWithResumeModel:model];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithModelId:(NSString *)resumeId showRightTitle:(BOOL)show comeFromString:(NSString *)comeFromString
{
    self = [self initWithModelId:resumeId showRightTitle:show];
    self.comeFromString = comeFromString;
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( !self.showRightTitle )
    {
        UIButton *changeCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeCityBtn setBackgroundColor:[UIColor colorWithHexString:@"1665a7"]];
        [changeCityBtn.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [changeCityBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [changeCityBtn setTitle:@"4/4" forState:UIControlStateNormal];
        [changeCityBtn.layer setCornerRadius:60 / CP_GLOBALSCALE / 2.0];
        [changeCityBtn.layer setMasksToBounds:YES];
        changeCityBtn.viewSize = CGSizeMake(110 / CP_GLOBALSCALE, 60 / CP_GLOBALSCALE);
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:changeCityBtn];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
}
-(void)alertCancelWithMessage:(NSString *)msg
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"自我描述";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    if (self.showRightTitle)
    {
        [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender)
         {
            [self.view endEditing:YES];
            if ( self.describeText.text.length == 0 )
            {
                [self shomMessageTips:@"请输入自我描述"];
                return;
            }
             if ( ![self checkWithString:self.describeText.text] )
             {
                 [self shomMessageTips:@"请输入自我描述"];
                 return;
             }
            [self.viewModel saveInfo];
            [MobClick event:@"edit_user_remark"];
        }];
    }
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 30  / CP_GLOBALSCALE, kScreenWidth, 180 + 60 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    self.describeText = [[UITextView alloc] initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, 60 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE, back.viewHeight - 60 / CP_GLOBALSCALE * 2 - 36 / CP_GLOBALSCALE - 32 / CP_GLOBALSCALE)];
    self.describeText.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.describeText.textColor = [UIColor colorWithHexString:@"404040"];
    self.describeText.backgroundColor = [UIColor clearColor];
    self.describeText.delegate = self;
    [self.describeText setContentInset:UIEdgeInsetsMake(-10.0, -4.0, 0, 0)];
    if(self.des && ![self.des isEqualToString:@""] && ![self.des isEqualToString:@"null"])
    {
        self.describeText.text = self.des;
    }
    [back addSubview:self.describeText];
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [self.describeText setInputAccessoryView:topView];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"添加性格，能力，优势等，最多填写500字";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"9d9d9d"];
    self.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [self.describeText addSubview:self.titleLabel];
    self.titleLabel.hidden = YES;
    [self.titleLabel setFrame:CGRectMake(5, 10, self.describeText.viewWidth, self.titleLabel.font.pointSize)];
    if(self.des && ![self.des isEqualToString:@""] && ![self.des isEqualToString:@"null"])
    {
         self.titleLabel.hidden = YES;
    }
    else
    {
        self.titleLabel.hidden = NO;
    }
    if (!self.showRightTitle)
    {
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nextButton setTitle:@"完成，马上发现好工作" forState:UIControlStateNormal];
        self.nextButton.layer.cornerRadius = 10 / CP_GLOBALSCALE;
        self.nextButton.layer.masksToBounds = YES;
        [self.nextButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        self.nextButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"ff5252"];
        [self.view addSubview:self.nextButton];
        [self.nextButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.describeText resignFirstResponder];
            if( self.viewModel.resumeModel.UserRemark.length > 0 )
            {
                if ( ![self checkWithString:self.describeText.text] )
                {
                    [self shomMessageTips:@"自我描述不能为空"];
                    return;
                }
                [self.viewModel saveInfo];
            }
            else
            {
                [self shomMessageTips:@"自我描述不能为空"];
            }
        }];
        self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.skipButton.frame = CGRectMake(40 / CP_GLOBALSCALE, self.nextButton.viewHeight + self.nextButton.viewY + 50 / CP_GLOBALSCALE, self.nextButton.viewWidth, 42 / CP_GLOBALSCALE);
        self.skipButton.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        [self.skipButton setTitle:@"跳过填写" forState:UIControlStateNormal];
        self.skipButton.backgroundColor = [UIColor clearColor];
        [self.skipButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [self.view addSubview:self.skipButton];
        [self.skipButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ( self.comeFromString && 0 < [self.comeFromString length] )
            {
                if ( [self.comeFromString isEqualToString:@"aboutlogin"] )
                {
                    TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
                    [delegate ChangeToMainTwo];
                }
                else if ( [self.comeFromString isEqualToString:@"homeADGuide"] )
                {
                    TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
                    [delegate ChangeToMainTwo];
                }
                else
                {
                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
                        BaseNavigationViewController *root = (BaseNavigationViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                        NSArray *childArray = root.childViewControllers;
                        UIViewController *childVC = [childArray objectAtIndex:1];
                        [childVC dismissViewControllerAnimated:NO completion:nil];
                    }];
                }
            }
            else
            {
                TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
                [delegate ChangeToMainTwo];
            }
        }];
    }
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
    countLabel.font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
    [back addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(back.mas_bottom).offset( -60 / CP_GLOBALSCALE );
        make.right.equalTo(back.mas_right).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( @( countLabel.font.pointSize ) );
    }];
    [[self.describeText rac_textSignal] subscribeNext:^(NSString *text) {
        if ([text isEqualToString:@""])
        {
            self.titleLabel.hidden = NO;
        }
        else
        {
            self.titleLabel.hidden = YES;
        }
        if ( text )
        {
            NSInteger len = 500 - text.length;
            if( len < 0 )
            {
                self.describeText.text = [self.describeText.text substringToIndex:500];
                NSString *des = [NSString stringWithFormat:@"您还可以输入0个字符"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, 1)];
                countLabel.attributedText = str;
                self.viewModel.resumeModel.UserRemark = [text substringToIndex:500];
                return ;
            }
            NSString *des = [NSString stringWithFormat:@"您还可以输入%ld个字符",(long)len];
            NSString *lenStr = [NSString stringWithFormat:@"%ld",(long)len];
            NSInteger end = lenStr.length;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, end)];
            countLabel.attributedText = str;
             self.viewModel.resumeModel.UserRemark = text;
        }
    }];
    @weakify(self)
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            if (!self.showRightTitle)
            {
                if ( self.comeFromString && 0 < [self.comeFromString length] )
                {
                    if ( [self.comeFromString isEqualToString:@"homeADGuide"] || [self.comeFromString isEqualToString:@"aboutlogin"])
                    {
                        TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
                        [delegate ChangeToMainTwo];
                    }
                    else
                    {
                        [self.navigationController dismissViewControllerAnimated:NO completion:^{
                            BaseNavigationViewController *root = (BaseNavigationViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                            NSArray *childArray = root.childViewControllers;
                            UIViewController *childVC = [childArray objectAtIndex:1];
                            [childVC dismissViewControllerAnimated:NO completion:nil];
                        }];
                    }
                }
                else
                {
                    TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
                    [delegate ChangeToMainTwo];
                }
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    UIImageView *annotationView = [[UIImageView alloc] init];
    annotationView.image = [UIImage imageNamed:@"ic_pin"];
    [self.view addSubview:annotationView];
    [annotationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( back.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
        make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.width.equalTo( @( 48 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 48 / CP_GLOBALSCALE ) );
    }];
    UILabel *annotationLabel = [[UILabel alloc] init];
    [annotationLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
    [annotationLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [annotationLabel setText:@"描述怎么写更有吸引力？"];
    [self.view addSubview:annotationLabel];
    [annotationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( annotationView.mas_top );
        make.left.equalTo( annotationView.mas_right ).offset( 40 / CP_GLOBALSCALE );
        make.height.equalTo( annotationView );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
    }];
    CPResumeGuideExperienceCityButton *expressButton = [CPResumeGuideExperienceCityButton buttonWithType:UIButtonTypeCustom];
    [expressButton setBackgroundImage:[UIImage imageNamed:@"ic_down_blue"] forState:UIControlStateNormal];
    [expressButton setBackgroundImage:[UIImage imageNamed:@"ic_up_blue"] forState:UIControlStateSelected];
    [self.view addSubview:expressButton];
    [expressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo( self.view.mas_right ).offset( -20 / CP_GLOBALSCALE );
        make.centerY.equalTo( annotationLabel.mas_centerY );
        make.width.equalTo( @( 84 / CP_GLOBALSCALE ) );
        make.height.equalTo( @( 84 / CP_GLOBALSCALE ) );
    }];
    UITextView *tipsTextField = [[UITextView alloc] init];
    [tipsTextField setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE ]];
    [tipsTextField setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [tipsTextField setBackgroundColor:[UIColor clearColor]];
    [tipsTextField setUserInteractionEnabled:NO];
    [tipsTextField setContentInset:UIEdgeInsetsMake(-9, -4, 0, 0)];
    [self.view addSubview:tipsTextField];
    [tipsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( annotationView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
        make.left.equalTo( annotationView.mas_left );
        make.right.equalTo( self.view.mas_right );
        make.height.equalTo( @( 0 ) );
    }];
    self.tipsTextField = tipsTextField;
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.tipsTextField.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
        make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
    }];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.nextButton.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
        make.left.equalTo( self.nextButton.mas_left );
        make.right.equalTo( self.nextButton.mas_right );
        make.height.equalTo( @( 36 / CP_GLOBALSCALE ) );
    }];
    [expressButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        @strongify(self);
        sender.selected = !sender.isSelected;
        if ( sender.isSelected )
        {
            [self.tipsTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( annotationView.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
                make.left.equalTo( annotationView.mas_left );
                make.right.equalTo( self.view.mas_right );
                make.height.equalTo( @( (36 * 9 + 18 * 9) / CP_GLOBALSCALE ) );
            }];
        }
        else
        {
            [self.tipsTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo( annotationView.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
                make.left.equalTo( annotationView.mas_left );
                make.right.equalTo( self.view.mas_right );
                make.height.equalTo( @( 0 ) );
            }];
        }
        [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.tipsTextField.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
            make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
            make.height.equalTo( @( 144 / CP_GLOBALSCALE ) );
        }];
        [self.skipButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.nextButton.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( self.nextButton.mas_left );
            make.right.equalTo( self.nextButton.mas_right );
            make.height.equalTo( @( 36 / CP_GLOBALSCALE ) );
        }];
    }];
    NSString *tipsStr = @"提供几个思路，试着从这些点描述自己：\n*你认为值得称道的工作细节；\n*你曾经克服过的最大挑战；\n*你在找工作时最看重的方面；\n*你曾经引以为豪的个人项目或者事迹；\n*如果你是一位团队领导者，说说你的管理哲学以独到的行业见解；\n*其它你以为能展示你优势的事情";
//    [tipsTextField setText:tipsStr];
    NSMutableAttributedString *attTipsStrM = [[NSMutableAttributedString alloc] initWithString:tipsStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:18 / CP_GLOBALSCALE];
    [attTipsStrM addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipsStr length])];
    [attTipsStrM addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"9d9d9d"] range:NSMakeRange(0, [tipsStr length])];
    [tipsTextField setAttributedText:attTipsStrM];
}
//关闭键盘
-(void)dismissKeyBoard
{
    [self.describeText resignFirstResponder];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ( 0 < [textView.text length] )
        self.titleLabel.hidden = YES;
    else
        self.titleLabel.hidden = NO;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    // textView 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:18 / CP_GLOBALSCALE];
    NSDictionary *attributes = @{
                        NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE],
                        NSParagraphStyleAttributeName : paragraphStyle,
                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]};
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
}
#pragma mark - private method
- (BOOL)checkWithString:(NSString *)str
{
    NSString *tempStr = str;
    tempStr = [tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ( 0 == [tempStr length] )
        return NO;
    else
        return YES;
}
- (void)shomMessageTips:(NSString *)tips
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton
{
    self.tipsView = nil;
}
- (CPTipsView *)messageTipsViewWithTips:(NSString *)tips
{
    if ( !_tipsView )
    {
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"确定"] showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
@end
