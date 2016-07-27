//
//  CPFeedBackController.m
//  cepin
//
//  Created by ceping on 16/2/16.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPFeedBackController.h"
#import "CPFeedBackPhoneTextField.h"
#import "RTNetworking+User.h"
#import "NSDictionary+NetworkBean.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPCommon.h"
#import "NSString+Extension.h"
@interface CPFeedBackController ()
@property (nonatomic, strong) UILabel *phoneStaticLabel;
@property (nonatomic, strong) UILabel *suggestionStaticLabel;
@property (nonatomic, strong) CPFeedBackPhoneTextField *phoneTextField;
@property (nonatomic, strong) UITextView *describeText;
@property (nonatomic, strong) UILabel *textViewPlaceLabel;
@property (nonatomic, strong) UIView *textBackgroundView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) NSString *currentVersion;
@property (nonatomic, strong) UIView *existAccountTipsView;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *contentLabel;
@property (nonatomic, strong) UIView *tipsView;
@end
@implementation CPFeedBackController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        self.title = @"意见反馈";
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        currentVersion = [@"iOS" stringByAppendingString:currentVersion];
        self.currentVersion = currentVersion;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [self.view addSubview:self.phoneStaticLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.suggestionStaticLabel];
    [self.view addSubview:self.textBackgroundView];
    [[self.describeText rac_textSignal] subscribeNext:^(NSString *text) {
        if ( 0 == [text length] )
        {
            self.textViewPlaceLabel.hidden = NO;
            [self.sureButton setEnabled:NO];
        }
        else
        {
            self.textViewPlaceLabel.hidden = YES;
            [self.sureButton setEnabled:YES];
        }
    }];
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
//    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30 * CP_DPI_SCALE)];
//    [topView setBarStyle:UIBarStyleDefault];
//    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
//    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
//    [topView setItems:buttonsArray];
//    [self.describeText setInputAccessoryView:topView];
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.textBackgroundView.mas_bottom ).offset( 84 / CP_GLOBALSCALE);
        make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( @( 144 / CP_GLOBALSCALE) );
    }];
}
//关闭键盘
-(void) dismissKeyBoard
{
    [self.describeText resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - getter mothed
- (UILabel *)phoneStaticLabel
{
    if ( !_phoneStaticLabel )
    {
        _phoneStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, 0.0, kScreenWidth, 120 / CP_GLOBALSCALE)];
        [_phoneStaticLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_phoneStaticLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_phoneStaticLabel setText:@"联系邮箱／手机号码（选填）"];
    }
    return _phoneStaticLabel;
}
- (UILabel *)suggestionStaticLabel
{
    if ( !_suggestionStaticLabel )
    {
        _suggestionStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, 120 / CP_GLOBALSCALE + 144 / CP_GLOBALSCALE, kScreenWidth, 120 / CP_GLOBALSCALE)];
        [_suggestionStaticLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_suggestionStaticLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_suggestionStaticLabel setText:@"你的建议（500字以内）"];
    }
    return _suggestionStaticLabel;
}
- (CPFeedBackPhoneTextField *)phoneTextField
{
    if ( !_phoneTextField )
    {
        _phoneTextField = [[CPFeedBackPhoneTextField alloc] initWithFrame:CGRectMake(0, 120 / CP_GLOBALSCALE, kScreenWidth, 144 / CP_GLOBALSCALE)];
        [_phoneTextField setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_phoneTextField setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_phoneTextField setPlaceholder:@"请输入联系邮箱／手机号码"];
        [_phoneTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_phoneTextField setBackgroundColor:[UIColor whiteColor]];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40 / CP_GLOBALSCALE, 144 / CP_GLOBALSCALE)];
        [_phoneTextField setLeftView:leftView];
        [_phoneTextField setLeftViewMode:UITextFieldViewModeAlways];
    }
    return _phoneTextField;
}
- (UIView *)textBackgroundView
{
    if ( !_textBackgroundView )
    {
        _textBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, ( 120 + 144 + 120 ) / CP_GLOBALSCALE, kScreenWidth, 360 / CP_GLOBALSCALE)];
        [_textBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [_textBackgroundView addSubview:self.describeText];
        [_textBackgroundView addSubview:self.textViewPlaceLabel];
        [self.textViewPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( _textBackgroundView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.top.equalTo( _textBackgroundView.mas_top ).offset( 35 / CP_GLOBALSCALE );
            make.right.equalTo( _textBackgroundView.mas_right ).offset( -35 / CP_GLOBALSCALE );
        }];
    }
    return _textBackgroundView;
}
- (UITextView *)describeText
{
    if ( !_describeText )
    {
        _describeText = [[UITextView alloc] initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, 0, kScreenWidth - 40 / CP_GLOBALSCALE * 2 + 10, 360 / CP_GLOBALSCALE)];
        [_describeText setBackgroundColor:[UIColor whiteColor]];
        [_describeText setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_describeText setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_describeText setContentInset:UIEdgeInsetsMake(40 / CP_GLOBALSCALE - 10, -4.0, 0, 0)];
    }
    return _describeText;
}
- (UILabel *)textViewPlaceLabel
{
    if ( !_textViewPlaceLabel )
    {
        _textViewPlaceLabel = [[UILabel alloc] init];
        [_textViewPlaceLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_textViewPlaceLabel setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
        [_textViewPlaceLabel setText:@"我们珍视你的每一个反馈，你的建议和批评将帮助我们更快成长。"];
        [_textViewPlaceLabel setNumberOfLines:0];
    }
    return _textViewPlaceLabel;
}
- (UIButton *)sureButton
{
    if ( !_sureButton )
    {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 10 / CP_GLOBALSCALE;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
        _sureButton.backgroundColor = [UIColor colorWithHexString:@"ff5252"];
        [_sureButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_sureButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9d9d9d"] cornerRadius:0.0] forState:UIControlStateDisabled];
        [_sureButton setEnabled:NO];
        [_sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            RACSignal *signal = [[RTNetworking shareInstance] feedbackWithMobileOrEmail:self.phoneTextField.text contentText:self.describeText.text version:self.currentVersion];
            [signal subscribeNext:^(RACTuple *tuple) {
                NSDictionary *dic = (NSDictionary *)tuple.second;
                if ([dic resultSucess])
                {
                    [self showShordMessage:@"发送成功" isSuccess:YES];
                }
                else
                {
                    if ([dic isMustAutoLogin])
                    {
                        [self showShordMessage:NetWorkError isSuccess:NO];
                    }
                    else
                    {
                        [self showShordMessage:[dic resultErrorMessage] isSuccess:NO];
                    }
                }
                
            } error:^(NSError *error) {
                [self showShordMessage:NetWorkError isSuccess:NO];
            }];
        }];
    }
    return _sureButton;
}
- (void)showShordMessage:(NSString *)message isSuccess:(BOOL)isSuccess
{
    if ( !self )
        return;
    self.existAccountTipsView = [self shortMessageTipsView:message isSuccess:isSuccess];
    [[UIApplication sharedApplication].keyWindow addSubview:self.existAccountTipsView];
}
#pragma mark - getter method
- (UIView *)shortMessageTipsView:(NSString *)message isSuccess:(BOOL)isSuccess
{
    if ( !_existAccountTipsView )
    {
        _existAccountTipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_existAccountTipsView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.75]];
        CGFloat W = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
        CGFloat maxW = kScreenWidth - ( 84 + 64 + 40 * 2 ) / CP_GLOBALSCALE;
        CGFloat H = ( 84 + 60 + 84 + 84 + 2 + 144 ) / CP_GLOBALSCALE;
        CGFloat X = 40 / CP_GLOBALSCALE;
        CGFloat Y = ( kScreenHeight - H ) / 2.0;
        NSString *str = message;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:24 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
        CGSize strSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        H += strSize.height;
        if ( strSize.height > ( 48 + 24 + 24 ) / CP_GLOBALSCALE )
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
        else
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
        attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:48 / CP_GLOBALSCALE]}];
        UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [tipsView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [tipsView.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [tipsView.layer setMasksToBounds:YES];
        [_existAccountTipsView addSubview:tipsView];
        self.tipsView = tipsView;
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:60 / CP_GLOBALSCALE]];
        [titleLabel setText:@"提示"];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [tipsView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( tipsView.mas_top ).offset( 84 / CP_GLOBALSCALE);
            make.left.equalTo( tipsView.mas_left );
            make.right.equalTo( tipsView.mas_right );
            make.height.equalTo( @( 60 / CP_GLOBALSCALE ) );
        }];
        CPPositionDetailDescribeLabel *contentLabel = [[CPPositionDetailDescribeLabel alloc] init];
        [contentLabel setVerticalAlignment:VerticalAlignmentTop];
        [contentLabel setNumberOfLines:0];
        self.contentLabel = contentLabel;
        [contentLabel setAttributedText:attStr];
        [tipsView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( titleLabel.mas_bottom ).offset( 84 / CP_GLOBALSCALE);
            make.left.equalTo( tipsView.mas_left ).offset( 74 / CP_GLOBALSCALE );
            make.right.equalTo( tipsView.mas_right ).offset( -64 / CP_GLOBALSCALE );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [tipsView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( tipsView.mas_bottom ).offset( -(144 / CP_GLOBALSCALE + 2 / CP_GLOBALSCALE) );
            make.left.equalTo( tipsView.mas_left );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
            make.right.equalTo( tipsView.mas_right );
        }];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [tipsView addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( separatorLine.mas_bottom );
            make.left.equalTo( tipsView.mas_left );
            make.bottom.equalTo( tipsView.mas_bottom );
            make.right.equalTo( tipsView.mas_right );
        }];
        [sureButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [_existAccountTipsView setHidden:YES];
            [_existAccountTipsView removeFromSuperview];
            _existAccountTipsView = nil;
            if ( isSuccess )
                [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _existAccountTipsView;
}
@end