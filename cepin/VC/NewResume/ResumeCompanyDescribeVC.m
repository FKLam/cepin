//
//  ResumeCompanyDescribeVC.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyDescribeVC.h"
#import "UIViewController+NavicationUI.h"
#import "CPCommon.h"
@interface ResumeCompanyDescribeVC ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *describeText;
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic, strong) NSString *des;
@end

@implementation ResumeCompanyDescribeVC

- (instancetype)initWithWorkModel:(WorkListDateModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
        self.des = model.Content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作职责";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        if (self.describeText.text.length > 500)
        {
            [OMGToast showWithText:@"工作职责不能超过500字符" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            return ;
        }
        if ( self.describeText.text.length == 0 )
        {
            [OMGToast showWithText:@"请输入工作职责" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            return;
        }
        if ( ![self checkWithString:self.describeText.text] )
        {
            [OMGToast showWithText:@"请输入工作职责" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            self.des = nil;
            return;
        }
        self.model.Content = self.des;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 30  / CP_GLOBALSCALE, kScreenWidth, 180 + 60 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    self.describeText = [[UITextView alloc]initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, 60 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE, back.viewHeight - 60 / CP_GLOBALSCALE * 2 - 36 / CP_GLOBALSCALE - 32 / CP_GLOBALSCALE)];
    self.describeText.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.describeText.textColor = [UIColor colorWithHexString:@"404040"];
    self.describeText.backgroundColor = [UIColor clearColor];
    self.describeText.delegate = self;
    [self.describeText setContentInset:UIEdgeInsetsMake(-10.0, -4.0, 0, 0)];
    if(self.model.Content && ![self.model.Content isEqualToString:@""] && ![self.model.Content isEqualToString:@"null"])
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
    self.titleLabel.text = @"请输入工作职责，最多不超过500个字符";
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
    if(self.des && ![self.des isEqualToString:@""] && ![self.des isEqualToString:@"null"])
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
        if ([text isEqualToString:@""])
        {
            self.titleLabel.hidden = NO;
        }
        else
        {
            self.titleLabel.hidden = YES;
        }
        if ( text ) {
            NSInteger len = 500 - text.length;
            if( len < 0 )
            {
                self.describeText.text = [self.describeText.text substringToIndex:500];
                NSString *des = [NSString stringWithFormat:@"您还可以输入0个字符"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
                //设置：在0-3个单位长度内的内容显示成红色
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, 1)];
                countLabel.attributedText = str;
                self.des = [text substringToIndex:500];
                return ;
            }
            NSString *des = [NSString stringWithFormat:@"您还可以输入%ld个字符",(long)len];
            NSString *lenStr = [NSString stringWithFormat:@"%ld",len];
            NSInteger end = lenStr.length;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
            //设置：在0-3个单位长度内的内容显示成红色
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, end)];
            countLabel.attributedText = str;
            self.des = text;
        }
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
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.describeText resignFirstResponder];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
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
@end
