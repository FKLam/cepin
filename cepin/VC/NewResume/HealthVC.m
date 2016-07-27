//
//  HealthVC.m
//  cepin
//
//  Created by dujincai on 15/11/3.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "HealthVC.h"
#import "ResumeChooseCell.h"
#import "UIViewController+NavicationUI.h"
#import "CPTipsView.h"
#import "CPCommon.h"
@interface HealthVC ()<UITextViewDelegate, UIGestureRecognizerDelegate, CPTipsViewDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UIView *healthView;
@property(nonatomic,strong)UILabel *defaultTitle;
@property (nonatomic, strong) CPTipsView *tipsView;
@property (nonatomic, strong) NSString *des;
@end
@implementation HealthVC
- (instancetype)initWithModel:(ResumeNameModel*)model
{
    self = [super init];
    if (self)
    {
        self.model = model;
        self.titleArray = @[@"健康", @"良好", @"有病史"];
        self.des = model.Health;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"健康状况";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        if ( self.model.HealthType.intValue == 3 )
        {
            if(!self.model.Health || [@"" isEqualToString:self.model.Health])
            {
                [self showMessageTips:@"请简单描述你的病史"];
                return;
            };
            if ( ![self checkWithString:self.des] )
            {
                [self showMessageTips:@"请简单描述你的病史"];
                return;
            }
            self.model.Health = self.des;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, 144 / CP_GLOBALSCALE * 3 + 32 / CP_GLOBALSCALE) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView setContentInset:UIEdgeInsetsMake( 32 / CP_GLOBALSCALE, 0, 0, 0)];
    self.healthView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame) + 30 / CP_GLOBALSCALE, self.view.viewWidth - 20, 100 + 30 / CP_GLOBALSCALE)];
    [self.healthView setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    [self.view addSubview:self.healthView];
    UITextView *healthTextView = [[UITextView alloc] initWithFrame:CGRectMake( 26 / CP_GLOBALSCALE, 38 / CP_GLOBALSCALE, self.healthView.viewWidth - 26 / CP_GLOBALSCALE, self.healthView.viewHeight - 38 / CP_GLOBALSCALE)];
      healthTextView.delegate = self;
    [healthTextView setFont:[[RTAPPUIHelper shareInstance] mainTitleFont]];
    [healthTextView setTextColor:[UIColor colorWithHexString:@"404040"]];
    [self.healthView addSubview:healthTextView];
    self.defaultTitle = [[UILabel alloc] init];
    self.defaultTitle.text = @"请简单描述你的病史，不超过50个字";
    self.defaultTitle.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
    self.defaultTitle.font = [[RTAPPUIHelper shareInstance] mainTitleFont];
    [self.healthView addSubview:self.defaultTitle];
    [self.defaultTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo( self.healthView.mas_top ).offset( 58 / CP_GLOBALSCALE );
        make.left.equalTo( self.healthView.mas_left ).offset( 40 / CP_GLOBALSCALE );
    }];
    if ( self.model.HealthType.intValue == 3 )
    {
        self.healthView.hidden = NO;
        healthTextView.text = self.des;
        self.defaultTitle.hidden = YES;
    }
    else
    {
        self.healthView.hidden = YES;
    }
    [[healthTextView rac_textSignal]subscribeNext:^(NSString *text) {
        if ( text.length > 0 )
        {
            NSInteger len = 50 - text.length;
            if( len < 0 )
            {
                 [OMGToast showWithText:@"描述不能超于50字"];
                healthTextView.text = [text substringToIndex:50];
                return ;
            }
            self.des = text;
            if ( !self.defaultTitle.isHidden )
                [self.defaultTitle setHidden:YES];
        }
        else
        {
            self.des = text;
            if ( self.defaultTitle.isHidden )
                [self.defaultTitle setHidden:NO];
        }
    }];
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClick)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
}
- (void)didClick
{
    [self.view endEditing:YES];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    self.defaultTitle.hidden = YES;
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil)
    {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    NSString *health = [NSString stringWithFormat:@"%@", self.model.HealthType];
    NSString *index = [NSString stringWithFormat:@"%d", (int)(indexPath.row + 1)];
    if ([health isEqualToString:index])
    {
        cell.isSelect = YES;
    }
    else
    {
        cell.isSelect = NO;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.titleArray count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model.HealthType = [NSNumber numberWithInteger:indexPath.row + 1];
    self.model.Health = self.titleArray[indexPath.row];
    if ( self.model.HealthType.intValue == 3 )
    {
        self.healthView.hidden = NO;
    }
    else
    {
        [self.view endEditing:YES];
        self.healthView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.tableView reloadData];
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
- (void)showMessageTips:(NSString *)tips
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
