//
//  EditDesVC.m
//  cepin
//
//  Created by dujincai on 15/6/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditDesVC.h"
#import "UIViewController+NavicationUI.h"
#import "CPTipsView.h"
#import "CPCommon.h"
@interface EditDesVC ()<UITextViewDelegate, CPTipsViewDelegate>
@property(nonatomic,strong)UITextView *describeText;
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic, strong) CPTipsView *tipsView;
@property (nonatomic, strong) NSString *tempString;
@end

@implementation EditDesVC
- (instancetype)initWithEduModel:(PracticeListDataModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
        self.tempString = model.Content;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑实践描述";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        if (self.describeText.text.length > 500) {
            [self shomMessageTips:@"实践描述不能超过500字符"];
            return ;
        }
        else
        {
            if ( [self.tempString length] > 0 )
            {
                if ( ![self checkWithString:self.tempString] )
                {
                    [self shomMessageTips:@"实践描述不能为空"];
                    self.tempString = nil;
                    return;
                }
            }
            else
            {
                [self shomMessageTips:@"实践描述不能为空"];
                return;
            }
        }
        self.model.Content = self.tempString;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 32  / CP_GLOBALSCALE, kScreenWidth, 180 + 60 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    self.describeText = [[UITextView alloc]initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE , 0, kScreenWidth - 40 / CP_GLOBALSCALE, 200)];
    self.describeText = [[UITextView alloc]initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, 60 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE, back.viewHeight - 60 / CP_GLOBALSCALE * 2 - 36 / CP_GLOBALSCALE - 32 / CP_GLOBALSCALE)];
    self.describeText.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.describeText.textColor = [UIColor colorWithHexString:@"404040"];
    self.describeText.backgroundColor = [UIColor clearColor];
    self.describeText.delegate = self;
    [self.describeText setContentInset:UIEdgeInsetsMake(-10.0, -4.0, 0, 0)];
    self.describeText.text = self.tempString;
    if(self.tempString && ![self.tempString isEqualToString:@""] && ![self.tempString isEqualToString:@"null"])
    {
        self.describeText.text = self.tempString;
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
    self.titleLabel.text = @"请输入实践描述，最多不超过500个字符";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"9d9d9d"];
    self.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [self.describeText addSubview:self.titleLabel];
    self.titleLabel.hidden = YES;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.describeText.mas_top ).offset( 10 );
        make.left.equalTo( self.describeText.mas_left ).offset( 5 );
        make.height.equalTo( @( self.titleLabel.font.pointSize ) );
        make.right.equalTo( self.describeText.mas_right );
    }];
    if(self.tempString && ![self.tempString isEqualToString:@""] && ![self.tempString isEqualToString:@"null"])
    {
        self.titleLabel.hidden = YES;
    }
    else
    {
        self.titleLabel.hidden = NO;
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
        if (text) {
            if ([text isEqualToString:@""])
            {
                self.titleLabel.hidden = NO;
            }
            else
            {
                self.titleLabel.hidden = YES;
            }
            NSInteger len = 500 - text.length;
            if( len < 0 ){
                self.describeText.text = [self.describeText.text substringToIndex:500];
                NSString *des = [NSString stringWithFormat:@"您还可以输入0个字符"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, 1)];
                countLabel.attributedText = str;
                self.tempString = [text substringToIndex:500];
                return ;
            }
            NSString *des = [NSString stringWithFormat:@"您还可以输入%ld个字符",(long)len];
            NSString *lenStr = [NSString stringWithFormat:@"%ld",len];
            NSInteger end = lenStr.length;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, end)];
            countLabel.attributedText = str;
            self.tempString = text;
        }
    }];
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.titleLabel.hidden = YES;
    return YES;
}
//关闭键盘
-(void) dismissKeyBoard
{
    [self.describeText resignFirstResponder];
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
