//
//  CPResumeOneWordController.m
//  cepin
//
//  Created by ceping on 16/1/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEditInforOneWordController.h"
#import "UIViewController+NavicationUI.h"
#import "TBAppDelegate.h"
#import "NSString+Extension.h"
#import "AlertDialogView.h"
#import "CPResumeGuideExperienceCityButton.h"
#import "CPResumeEditInformationReformer.h"
#import "CPPositionDetailDescribeLabel.h"
#import "CPTipsView.h"
#import "CPCommon.h"
@interface CPResumeEditInforOneWordController ()<UITextViewDelegate, UIAlertViewDelegate, CPTipsViewDelegate>
@property(nonatomic,strong)UITextView *describeText;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UIButton *skipButton;
@property(nonatomic,assign)BOOL showRightTitle;
@property(nonatomic,strong)NSString *des;
@property (nonatomic, strong) UITextView *tipsTextField;
@property (nonatomic, strong) AlertDialogView *alertView;
@property (nonatomic, strong) NSString *oneWordStr;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *tipsLabel1;
@property (nonatomic, strong) CPPositionDetailDescribeLabel *tipsLabel2;
@property (nonatomic, strong) CPTipsView *tipsView;
@end

@implementation CPResumeEditInforOneWordController
- (instancetype)initWithModelId:(NSString *)resumeId defaultDes:(NSString*)des
{
    self = [super init];
    if (self) {
        self.showRightTitle = YES;
        if ( des && 0 < [des length] && ![des isEqualToString:@"(null)"] )
            self.des = des;
    }
    return self;
}
- (instancetype)initWithModelId:(NSString *)resumeId showRightTitle:(BOOL)show
{
    self = [super init];
    if (self) {
        self.showRightTitle = show;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)alertCancelWithMessage:(NSString *)msg
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一句话优势";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    if (self.showRightTitle) {
        [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.describeText resignFirstResponder];
            if ( self.describeText.text.length == 0 )
            {
                [self shomMessageTips:@"请输入一句话优势"];
                return;
            }
            if ( ![self checkWithString:self.describeText.text] )
            {
                [self shomMessageTips:@"请输入一句话优势"];
                return;
            }
            [CPResumeEditInformationReformer SaveOneWord:self.oneWordStr];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 30  / CP_GLOBALSCALE, kScreenWidth, 100 + 60 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    self.describeText = [[UITextView alloc]initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, 60 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE, back.viewHeight - 60 / CP_GLOBALSCALE * 2 - 36 / CP_GLOBALSCALE - 30 / CP_GLOBALSCALE)];
    self.describeText.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.describeText.textColor = [UIColor colorWithHexString:@"404040"];
    self.describeText.backgroundColor = [UIColor clearColor];
    self.describeText.delegate = self;
    [self.describeText setContentInset:UIEdgeInsetsMake(-10.0, -4.0, 0, 0)];
    if(self.des && ![self.des isEqualToString:@""] && ![self.des isEqualToString:@"null"]){
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
    self.titleLabel.text = @"一句话介绍自己，告诉企业为什么选择你而不是别人（非常重要）";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"9d9d9d"];
    self.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [self.titleLabel setNumberOfLines:0];
    [self.describeText addSubview:self.titleLabel];
    self.titleLabel.hidden = YES;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.describeText.mas_top ).offset( 10 );
        make.left.equalTo( self.describeText.mas_left ).offset( 5 );
        make.width.equalTo( @( kScreenWidth - 40 / CP_GLOBALSCALE * 1.8 ) );
    }];
    if(self.des && ![self.des isEqualToString:@""] && ![self.des isEqualToString:@"null"]){
        self.titleLabel.hidden = YES;
    }else{
        self.titleLabel.hidden = NO;
    }
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
    countLabel.font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
    [back addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(back.mas_bottom).offset( -60 / CP_GLOBALSCALE );
        make.right.equalTo(back.mas_right).offset( -40 / CP_GLOBALSCALE );
        make.height.equalTo( @( countLabel.font.pointSize ) );
    }];
    [[self.describeText rac_textSignal] subscribeNext:^(NSString *text) {
        if ([text isEqualToString:@""]) {
            self.titleLabel.hidden = NO;
        }else{
            self.titleLabel.hidden = YES;
        }
        if ( text ) {
            NSInteger len = 100 - text.length;
            if( len < 0 ){
                self.describeText.text = [self.describeText.text substringToIndex:100];
                NSString *des = [NSString stringWithFormat:@"您还可以输入0个字符"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
                //设置：在0-3个单位长度内的内容显示成红色
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, 1)];
                countLabel.attributedText = str;
                self.oneWordStr = [text substringToIndex:100];
                return ;
            }
            NSString *des = [NSString stringWithFormat:@"您还可以输入%ld个字符",(long)len];
            NSString *lenStr = [NSString stringWithFormat:@"%ld",len];
            NSInteger end = lenStr.length;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
            //设置：在0-3个单位长度内的内容显示成红色
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, end)];
            countLabel.attributedText = str;
            self.oneWordStr = text;
        }
    }];
    UILabel *annotationLabel = [[UILabel alloc] init];
    [annotationLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
    [annotationLabel setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE]];
    [annotationLabel setText:@"介绍示例"];
    [self.view addSubview:annotationLabel];
    [annotationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( back.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
        make.left.equalTo( self.view.mas_left ).offset( 40 / CP_GLOBALSCALE );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
    }];
    [self.view addSubview:self.tipsLabel1];
    [self.tipsLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( annotationLabel.mas_left );
        make.top.equalTo( annotationLabel.mas_bottom ).offset( 60 / CP_GLOBALSCALE );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
    }];
    [self.view addSubview:self.tipsLabel2];
    [self.tipsLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo( annotationLabel.mas_left );
        make.top.equalTo( self.tipsLabel1.mas_bottom ).offset( 80 / CP_GLOBALSCALE );
        make.right.equalTo( self.view.mas_right ).offset( -40 / CP_GLOBALSCALE );
    }];
}
//关闭键盘
-(void) dismissKeyBoard
{
    [self.describeText resignFirstResponder];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.titleLabel.hidden = YES;
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
- (CPPositionDetailDescribeLabel *)tipsLabel1
{
    if ( !_tipsLabel1 )
    {
        _tipsLabel1 = [[CPPositionDetailDescribeLabel alloc] init];
        [_tipsLabel1 setVerticalAlignment:VerticalAlignmentTop];
        [_tipsLabel1 setNumberOfLines:0];
        [_tipsLabel1 setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE ]];
        [_tipsLabel1 setTextColor:[UIColor colorWithHexString:@"707070"]];
        NSString *str = @"示例一\n从事财务工作6年，其中2年管理经验，4年的外资全盘账务处理经验。擅长精确核算收入、成本利润。对进口医疗卫浴、IT、旅游等行业的税务政策及工作都非常熟悉。";
        NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setLineSpacing:20 / CP_GLOBALSCALE];
        [strM addAttributes:@{NSParagraphStyleAttributeName : paragraph} range:NSMakeRange(0, [str length])];
        [_tipsLabel1 setAttributedText:strM];
    }
    return _tipsLabel1;
}
- (CPPositionDetailDescribeLabel *)tipsLabel2
{
    if ( !_tipsLabel2 )
    {
        _tipsLabel2 = [[CPPositionDetailDescribeLabel alloc] init];
        [_tipsLabel2 setVerticalAlignment:VerticalAlignmentTop];
        [_tipsLabel2 setNumberOfLines:0];
        [_tipsLabel2 setFont:[UIFont systemFontOfSize:36 / CP_GLOBALSCALE ]];
        [_tipsLabel2 setTextColor:[UIColor colorWithHexString:@"707070"]];
        NSString *str = @"示例二\n多年来供职于大中型企业的市场策划部门，积累了丰富工作经验。对市场动态把握，整体市场策划与实施都有深入地研究。自修市场营销与管理本科课程，喜欢接受新的挑战并努力完成。";
        NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setLineSpacing:20 / CP_GLOBALSCALE];
        [strM addAttributes:@{NSParagraphStyleAttributeName : paragraph} range:NSMakeRange(0, [str length])];
        [_tipsLabel2 setAttributedText:strM];
    }
    return _tipsLabel2;
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
