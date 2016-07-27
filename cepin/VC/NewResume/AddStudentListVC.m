//
//  AddStudentListVC.m
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddStudentListVC.h"
#import "AddStudentListVM.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "ResumeEditCell.h"
#import "ResumeThridTimeView.h"
#import "NSDate-Utilities.h"
#import "GanBuLeiXingVC.h"
#import "CPTestEnsureEditCell.h"
#import "CPTestEnsureArrowCell.h"
#import "CPCommon.h"
@interface AddStudentListVC ()<UITextFieldDelegate, ResumeThridTimeViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,retain)ResumeThridTimeView *timeView;
@property(nonatomic,strong)AddStudentListVM *viewModel;
@property(nonatomic,strong)UITextField *textField;
@end

@implementation AddStudentListVC
- (instancetype)initWithResumeId:(NSString *)resumeId
{
    self = [super init];
    if (self) {
        self.viewModel = [[AddStudentListVM alloc]initWithResumeid:resumeId];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加学生干部";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        [self.viewModel addStudent];
        [MobClick event:@"edit_pratical_experience"];
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
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClick)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
}
- (void)didClick
{
    [self.view endEditing:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
        [cell.inputTextField setTag:indexPath.row];
        switch (indexPath.row) {
            case 2:
            {
                [cell configCellLeftString:@"职务名称" placeholder:@"请输入职务名称"];
                cell.inputTextField.text = self.viewModel.studData.Name;
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    if ( indexPath.row != cell.inputTextField.tag )
                        return;
                    self.viewModel.studData.Name = text;
                }];
            }
                break;
            default:
                break;
        }
        return cell;
    }
    CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
    [cell.inputTextField setTag:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            [cell configCellLeftString:@"开始时间" placeholder:@"请选择开始时间"];
            cell.inputTextField.text = [NSDate cepinYMDFromString:self.viewModel.studData.StartDate];
            [cell resetSeparatorLineShowAll:NO];
        }
            break;
        case 1:
        {
            [cell configCellLeftString:@"结束时间" placeholder:@"请选择结束时间"];
            if (!self.viewModel.studData.EndDate || [self.viewModel.studData.EndDate isEqualToString:@""]) {
                cell.inputTextField.text = @"至今";
            }else{
                cell.inputTextField.text = [NSDate cepinYMDFromString:self.viewModel.studData.EndDate];
            }        }
            [cell resetSeparatorLineShowAll:NO];
            break;
        case 3:
        {
            [cell configCellLeftString:@"类型" placeholder:@"请选择类型"];
            cell.inputTextField.text = self.viewModel.studData.Level;
            [cell resetSeparatorLineShowAll:YES];
        }
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.textField) {
        [self.textField resignFirstResponder];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    switch (indexPath.row) {
        case 0:
        {
            [self displayTimeView:indexPath.row];
        }
            break;
        case 1:
        {
            [self displayTimeView:indexPath.row];
        }
            break;
        case 3:
        {
            GanBuLeiXingVC *vc = [[GanBuLeiXingVC alloc] initWithModel:self.viewModel.studData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 250, 0);
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    });
    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)displayTimeView:(NSInteger)tag
{
    if (self.textField) {
        [self.textField resignFirstResponder];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
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
    if (self.timeView.tag == 0)
    {
        if (!self.viewModel.studData.StartDate || [self.viewModel.studData.StartDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        str = [NSDate cepinYMDFromString:self.viewModel.studData.StartDate];
    }
    else
    {
        if (!self.viewModel.studData.EndDate || [self.viewModel.studData.EndDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        str = [NSDate cepinYMDFromString:self.viewModel.studData.EndDate];
    }
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue];
}
-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if (self.timeView.tag == 1)
    {
        self.viewModel.studData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    else
    {
        self.viewModel.studData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
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