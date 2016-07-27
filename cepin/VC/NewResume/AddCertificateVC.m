//
//  AddCertificateVC.m
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddCertificateVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "ResumeThridTimeView.h"
#import "NSDate-Utilities.h"
#import "CertificateNameVC.h"
#import "AddCertificateVM.h"
#import "CPTestEnsureArrowCell.h"
#import "CPCommon.h"
@interface AddCertificateVC ()<ResumeThridTimeViewDelegate>
@property(nonatomic,retain)ResumeThridTimeView *timeView;
@property(nonatomic,strong)AddCertificateVM *viewModel;
@end
@implementation AddCertificateVC
- (instancetype)initWithResumeId:(NSString *)resumeId
{
    self = [super init];
    if (self) {
        self.viewModel = [[AddCertificateVM alloc]initWithResumeid:resumeId];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加专业证书";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.viewModel addCredential];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
    [cell.inputTextField setTag:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            [cell configCellLeftString:@"证书名称" placeholder:@"请选择"];
            cell.inputTextField.text = self.viewModel.credData.Name;
            [cell resetSeparatorLineShowAll:NO];
        }
            break;
        case 1:
        {
            [cell configCellLeftString:@"获得时间" placeholder:@"请选择"];
            cell.inputTextField.text = [NSDate cepinYMDFromString:self.viewModel.credData.Date];
            [cell resetSeparatorLineShowAll:YES];
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            CertificateNameVC *vc = [[CertificateNameVC alloc] initWithEduModel:self.viewModel.credData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            [self displayTimeView:indexPath.row];
        }
            break;
        default:
            break;
    }
}
-(void)displayTimeView:(NSInteger)tag
{
    if (!self.timeView)
    {
        self.timeView = [[ResumeThridTimeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.timeView.center = CGPointMake(self.view.viewCenterX, self.view.viewCenterY);
        self.timeView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:self.timeView];
        self.timeView.tag = tag;
        
        [self resetYearMonth];
    }
    else
    {
        self.timeView.tag = tag;
        [self resetYearMonth];
        self.timeView.hidden = NO;
    }
    
}
-(void)resetYearMonth
{
    NSString *str = nil;
    if (!self.viewModel.credData.Date || [self.viewModel.credData.Date isEqualToString:@""])
    {
        NSDate *date = [NSDate date];
        NSString *strYear = [date stringyyyyFromDate];
        NSString *strMonth = [date stringMMFromDate];
        [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
        return;
    }
    str = [NSDate cepinYMDFromString:self.viewModel.credData.Date];
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue];
}
-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if (self.timeView.tag == 1)
    {
        self.viewModel.credData.Date = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    [self.tableView reloadData];
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
- (void)clickCancelButton
{
    [self.timeView removeFromSuperview];
    self.timeView = nil;
}
@end
