//
//  ProjectDescripeVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ProjectDescripeVC.h"
#import "UIViewController+NavicationUI.h"
#import "CPTipsView.h"
#import "CPCommon.h"
@interface ProjectDescripeVC ()<UITextViewDelegate, CPTipsViewDelegate>
@property(nonatomic,strong)UITextView *describeText;
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic, strong) CPTipsView *tipsView;
@property (nonatomic, strong) NSString *Content;
@end
@implementation ProjectDescripeVC
- (instancetype)initWithEduModel:(ProjectListDataModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
        self.Content = model.Content;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"项目描述";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        if (self.describeText.text.length > 500) {
            [self shomMessageTips:@"项目描述不能超过500字符"];
            return ;
        }
        if ( [self.Content length] > 0 )
        {
            if ( ![self checkWithString:self.Content] )
            {
                [self shomMessageTips:@"请输入项目描述"];
                return;
            }
        }
        else
        {
            [self shomMessageTips:@"请输入项目描述"];
            return;
        }
        self.model.Content = self.Content;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 30  / CP_GLOBALSCALE, kScreenWidth, 180 + 60 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    self.describeText = [[UITextView alloc]initWithFrame:CGRectMake( 40 / CP_GLOBALSCALE, 25 / CP_GLOBALSCALE, kScreenWidth - 40 / CP_GLOBALSCALE, back.viewHeight - 60 / CP_GLOBALSCALE * 2 - 36 / CP_GLOBALSCALE - 32 / CP_GLOBALSCALE)];
    self.describeText.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    self.describeText.textColor = [UIColor colorWithHexString:@"404040"];
    self.describeText.backgroundColor = [UIColor clearColor];
    self.describeText.delegate = self;
    [self.describeText setContentInset:UIEdgeInsetsMake(0, -4.0, 0, 0)];
    [back addSubview:self.describeText];
    self.describeText.text = self.Content;
    [[self.describeText rac_textSignal] subscribeNext:^(NSString *text) {
        self.Content = text;
    }];
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [self.describeText setInputAccessoryView:topView];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"请输入项目描述，最多不超过500个字符";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"9d9d9d"];
    self.titleLabel.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    [self.describeText addSubview:self.titleLabel];
    self.titleLabel.hidden = YES;
    [self.titleLabel setFrame:CGRectMake(5, 10, self.describeText.viewWidth - 5, self.titleLabel.font.pointSize)];
    if (!self.model.Content || [self.model.Content isEqualToString:@""]) {
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
                self.Content = [text substringToIndex:500];
                return ;
            }
            NSString *des = [NSString stringWithFormat:@"您还可以输入%ld个字符",(long)len];
            NSString *lenStr = [NSString stringWithFormat:@"%ld",(long)len];
            NSInteger end = lenStr.length;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:des];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"288add"] range:NSMakeRange(6, end)];
            countLabel.attributedText = str;
            self.Content = text;
        }
    }];
}
- (void)shomMessageTips:(NSString *)tips
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
//关闭键盘
-(void) dismissKeyBoard
{
    [self.describeText resignFirstResponder];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    self.titleLabel.hidden = YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.describeText resignFirstResponder];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 283, 0);
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    });
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
