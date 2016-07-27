//
//  CPResumeOneWordController.m
//  cepin
//
//  Created by ceping on 16/1/28.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeOneWordController.h"
#import "UIViewController+NavicationUI.h"
#import "AddDescriptionVM.h"
#import "TBAppDelegate.h"
#import "NSString+Extension.h"
#import "AlertDialogView.h"
#import "CPResumeGuideExperienceCityButton.h"

@interface CPResumeOneWordController ()<UITextViewDelegate, UIAlertViewDelegate>
@property(nonatomic,strong)AddDescriptionVM *viewModel;
@property(nonatomic,strong)UITextView *describeText;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UIButton *skipButton;
@property(nonatomic,assign)BOOL showRightTitle;
@property(nonatomic,strong)NSString *des;
@property (nonatomic, strong) UITextView *tipsTextField;
@property (nonatomic, strong) AlertDialogView *alertView;
@end

@implementation CPResumeOneWordController
- (instancetype)initWithModelId:(NSString *)resumeId defaultDes:(NSString*)des
{
    self = [super init];
    if (self) {
        self.showRightTitle = YES;
        ResumeNameModel *model = [ResumeNameModel new];
        model.ResumeId = resumeId;
        self.viewModel = [[AddDescriptionVM alloc] initWithResumeModel:model];
        self.des = des;
    }
    return self;
}
- (instancetype)initWithModelId:(NSString *)resumeId showRightTitle:(BOOL)show
{
    self = [super init];
    if (self) {
        self.showRightTitle = show;
        ResumeNameModel *model = [ResumeNameModel new];
        model.ResumeId = resumeId;
        self.viewModel = [[AddDescriptionVM alloc] initWithResumeModel:model];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一句话优势";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    if (self.showRightTitle) {
        [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender)
        {
            [self.describeText resignFirstResponder];
            if ( self.describeText.text.length == 0 )
            {
                self.alertView = [[AlertDialogView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight) Title:@"提示" content:@"请输入一句话优势" selector:nil target:self];
                [self.alertView showCancelButton];
                [self.view addSubview:self.alertView];
                return;
            }
            [self.viewModel saveInfo];
        }];
    }
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 32  / 3.0, kScreenWidth, 180 + 60 / 3.0 + 60 / 3.0)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    self.describeText = [[UITextView alloc]initWithFrame:CGRectMake( 40 / 3.0, 60 / 3.0, kScreenWidth - 40 / 3.0, back.viewHeight - 60 / 3.0 * 2 - 36 / 3.0 - 32 / 3.0)];
    self.describeText.font = [UIFont systemFontOfSize:42 / 3.0];
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
    self.titleLabel.font = [UIFont systemFontOfSize:42 / 3.0];
    [self.titleLabel setNumberOfLines:0];
    [self.describeText addSubview:self.titleLabel];
    self.titleLabel.hidden = YES;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.describeText.mas_top ).offset( 10 );
        make.left.equalTo( self.describeText.mas_left ).offset( 5 );
        make.width.equalTo( @( kScreenWidth - 40 / 3.0 * 1.8 ) );
    }];
    if(self.des && ![self.des isEqualToString:@""] && ![self.des isEqualToString:@"null"]){
        self.titleLabel.hidden = YES;
    }else{
        self.titleLabel.hidden = NO;
    }
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
    countLabel.font = [UIFont systemFontOfSize:36 / 3.0];
    [back addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(back.mas_bottom).offset( -60 / 3.0 );
        make.right.equalTo(back.mas_right).offset( -40 / 3.0 );
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
                NSString *des = [NSString stringWithFormat:@"100/100"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
                //设置：在0-3个单位长度内的内容显示成红色
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(0, 4)];
                countLabel.attributedText = str;
                self.viewModel.resumeModel.Introduces = [text substringToIndex:100];
                return ;
            }
            NSString *des = [NSString stringWithFormat:@"%ld/100",(long)text.length];
            NSString *lenStr = [NSString stringWithFormat:@"%ld",(unsigned long)text.length];
            NSInteger end = lenStr.length;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
            //设置：在0-3个单位长度内的内容显示成红色
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(0, end + 1)];
            countLabel.attributedText = str;
            self.viewModel.resumeModel.Introduces = text;
        }
    }];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            if (!self.showRightTitle) {
                TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
                [delegate ChangeToMainTwo];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    UILabel *annotationLabel = [[UILabel alloc] init];
    [annotationLabel setTextColor:[UIColor colorWithHexString:@"707070"]];
    [annotationLabel setFont:[UIFont systemFontOfSize:36 / 3.0]];
    [annotationLabel setText:@"介绍示例"];
    [self.view addSubview:annotationLabel];
    [annotationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( back.mas_bottom ).offset( 60 / 3.0 );
        make.left.equalTo( self.view.mas_left ).offset( 40 / 3.0 );
        make.right.equalTo( self.view.mas_right ).offset( -40 / 3.0 );
    }];
    UITextView *tipsTextField = [[UITextView alloc] init];
    [tipsTextField setFont:[UIFont systemFontOfSize:36 / 3.0 ]];
    [tipsTextField setTextColor:[UIColor colorWithHexString:@"9d9d9d"]];
    [tipsTextField setBackgroundColor:[UIColor clearColor]];
    [tipsTextField setUserInteractionEnabled:NO];
    [tipsTextField setContentInset:UIEdgeInsetsMake(-9, -4, 0, 0)];
    [self.view addSubview:tipsTextField];
    [tipsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( annotationLabel.mas_bottom ).offset( 60 / 3.0 );
        make.left.equalTo( annotationLabel.mas_left );
        make.right.equalTo( self.view.mas_right );
        make.bottom.equalTo( self.view.mas_bottom );
    }];
    self.tipsTextField = tipsTextField;
    NSString *tipsStr = @"提供几个思路，试着从这些点描述自己：\n*你认为值得称道的工作细节；\n*你曾经克服过的最大挑战；\n*你在找工作时最看重的方面；\n*你曾经引以为豪的个人项目或者事迹；\n*如果你是一位团队领导者，说说你的管理哲学以独到的行业见解；\n*其它你以为能展示你优势的事情";
    //    [tipsTextField setText:tipsStr];
    NSMutableAttributedString *attTipsStrM = [[NSMutableAttributedString alloc] initWithString:tipsStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:18 / 3.0];
    [attTipsStrM addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipsStr length])];
    [attTipsStrM addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"707070"] range:NSMakeRange(0, [tipsStr length])];
    [tipsTextField setAttributedText:attTipsStrM];
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
    [paragraphStyle setLineSpacing:18 / 3.0];
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:42 / 3.0],
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]};
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
}
@end

