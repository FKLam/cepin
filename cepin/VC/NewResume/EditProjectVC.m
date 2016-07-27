//
//  EditProjectVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditProjectVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeChooseCell.h"
#import "ResumeThridTimeView.h"
#import "ResumeArrowCell.h"
#import "NSDate-Utilities.h"
#import "ResumeEditCell.h"
#import "ResumeAddMoreCell.h"
#import "ProjectDescripeVC.h"
#import "DutyDescribeVC.h"
#import "ProjectLeverVC.h"
#import "EditProjectVM.h"
#import "CPTestEnsureEditCell.h"
#import "CPTestEnsureArrowCell.h"
#import "CPResumeMoreButton.h"
#import "RTNetworking+Resume.h"
#import "CPProjectExperienceTimeView.h"
#import "CPSuccessDescripteController.h"
#import "CPKeYanProjectController.h"
#import "CPCommon.h"
@interface EditProjectVC ()<ResumeThridTimeViewDelegate,UITextFieldDelegate, CPProjectExperienceTimeViewDelegate>
@property(nonatomic,retain)CPProjectExperienceTimeView *timeView;
@property(nonatomic,assign)BOOL addMore;
@property(nonatomic,strong)EditProjectVM *viewModel;
@property(nonatomic,strong)UITextField *textField;
@property (nonatomic, strong) UIView *firstFooterView;
@property (nonatomic, strong) UIView *secondFooterView;
@property (nonatomic, strong) CPResumeMoreButton *moreButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) CGFloat lastRoWHeight;
@property (nonatomic, strong) ResumeNameModel *resume; // 简历类型(社招=1，校招=2)
@end
@implementation EditProjectVC
- (instancetype)initWithModel:(ProjectListDataModel *)model
{
    self = [super init];
    if (self) {
        self.addMore = NO;
        self.viewModel = [[EditProjectVM alloc] initWithWork:model];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (instancetype)initWithModel:(ProjectListDataModel *)model resume:(ResumeNameModel *)resume
{
    self = [super init];
    if ( self )
    {
        self.addMore = NO;
        self.viewModel = [[EditProjectVM alloc] initWithWork:model];
        self.viewModel.showMessageVC = self;
        self.resume = resume;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick endEvent:@"project_experience_launch"];
    self.title = @"编辑项目经验";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    self.lastRoWHeight = 0.0;
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.textField resignFirstResponder];
        [self.viewModel saveProject];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(32 / CP_GLOBALSCALE, 0, 0, 0)];
    self.tableView.tableFooterView = self.secondFooterView;
    @weakify(self)
    [RACObserve(self.viewModel,saveStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
           [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            [self.tableView reloadData];
        }
    }];
    // 增加对键盘消息的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 监听键盘的弹出和隐藏的方法
- (void)listenKeyboardWillShow:(NSNotification *)userNotification
{
    if ( 10 != self.textField.tag )
        return;
    NSValue *userValue = [userNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [userValue CGRectValue];
    CGFloat keyboardTop = keyboardEndFrame.origin.y;
    CGFloat duration = [[userNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.tableView.frame = viewFrame;
    }];
}
- (void)listenKeyboardWillHide:(NSNotification *)userNotification
{
    if ( 10 != self.textField.tag )
        return;
    CGFloat duration = [[userNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect viewFrame = self.view.bounds;
    viewFrame.origin.y = self.view.bounds.origin.y + 40.0 + 20.0;
    viewFrame.size.height = self.view.bounds.size.height - 40 - 20;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.tableView.frame = viewFrame;
    }];
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 1 == indexPath.section )
    {
            return self.lastRoWHeight;
    }
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section )
    {
        return 5;
    }
    else
    {
        if ( 1 == [self.resume.ResumeType intValue] )
            return 1;
        else if ( 2 == [self.resume.ResumeType intValue] )
            return 4;
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 0 == indexPath.section )
    {
    if ( indexPath.row == 0 ) {
        CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
        switch (indexPath.row) {
            case 0:
            {
                [cell configCellLeftString:@"项目名称" placeholder:@"请输入项目名称"];
                cell.inputTextField.delegate = self;
                cell.inputTextField.text = self.viewModel.projectData.Name;
                [cell.inputTextField setTag:indexPath.row];
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    if ( indexPath.row != cell.inputTextField.tag )
                        return;
                    self.viewModel.projectData.Name = text;
                }];
            }
                break;
            default:
                break;
        }
        return cell;
    }
    CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
        switch (indexPath.row) {
            case 1:
            {
                [cell configCellLeftString:@"你的职责" placeholder:@"一句话描述你的职责"];
                if ( self.viewModel.projectData.Duty && ![self.viewModel.projectData.Duty isEqualToString:@""]) {
                    cell.inputTextField.text = @"已添加";
                }
            }
                break;
        case 2:
        {
            [cell configCellLeftString:@"开始时间" placeholder:@"请选择开始时间"];
            cell.inputTextField.text = [NSDate cepinYMDFromString:self.viewModel.projectData.StartDate];
        }
            break;
        case 3:
        {
            [cell configCellLeftString:@"结束时间" placeholder:@"请选择结束时间"];
            if (!self.viewModel.projectData.EndDate || [self.viewModel.projectData.EndDate isEqualToString:@""]) {
            
                cell.inputTextField.text = @"至今";
            }else{
                cell.inputTextField.text = [NSDate cepinYMDFromString:self.viewModel.projectData.EndDate];
            }
        }
            break;
        case 4:
        {
            [cell configCellLeftString:@"项目描述" placeholder:@"请输入项目描述"];
            if (self.viewModel.projectData.Content && ![self.viewModel.projectData.Content isEqualToString:@""])
            {
                cell.inputTextField.text = @"已添加";
            }
            else
            {
                [cell.inputTextField setText:@""];
            }
        }
            break;
        default:
            break;
    }
        if ( 4 == indexPath.row )
        {
            [cell resetSeparatorLineShowAll:YES];
        }
        else
            [cell resetSeparatorLineShowAll:NO];
    return cell;
    }
    else if ( 1 == indexPath.section )
    {
        if ( 0 == indexPath.row )
        {
            CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
            [cell configCellLeftString:@"项目链接" placeholder:@"请输入项目链接"];
            cell.inputTextField.delegate = self;
            cell.inputTextField.text = self.viewModel.projectData.ProjectLink;
            [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                    return;
                self.viewModel.projectData.ProjectLink = text;
            }];
            if ( 1 == [self.resume.ResumeType intValue] )
                [cell resetSeparatorLineShowAll:YES];
            else
                [cell resetSeparatorLineShowAll:NO];
            if ( self.moreButton.isSelected )
                [cell setHidden:NO];
            else
                [cell setHidden:YES];
            return cell;
        }
        else if ( 1 == indexPath.row )
        {
            CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
            [cell configCellLeftString:@"项目级别" placeholder:@"请选择项目级别"];
            cell.inputTextField.text = self.viewModel.projectData.KeyanLevel;
            if ( self.moreButton.isSelected )
                [cell setHidden:NO];
            else
                [cell setHidden:YES];
            [cell resetSeparatorLineShowAll:NO];
            return cell;
        }
        else if ( 2 == indexPath.row )
        {
            CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
            [cell configCellLeftString:@"成果描述" placeholder:@"请完善"];
            if ( !self.viewModel.projectData.Description || 0 == [self.viewModel.projectData.Description length] )
            {
                [cell.inputTextField setText:@""];
            }
            else
            {
                [cell.inputTextField setText:@"已添加"];
            }
            if ( self.moreButton.isSelected )
                [cell setHidden:NO];
            else
                [cell setHidden:YES];
            [cell resetSeparatorLineShowAll:NO];
            return cell;
        }
        else if ( 3 == indexPath.row )
        {
            CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
            [cell configCellLeftString:@"科研项目" placeholder:@"请选择"];
            if ( !self.viewModel.projectData.IsKeyuan )
                self.viewModel.projectData.IsKeyuan = @"0";
            if ( [self.viewModel.projectData.IsKeyuan intValue] == 0 )
            {
                [cell.inputTextField setText:@"否"];
            }
            else if( [self.viewModel.projectData.IsKeyuan intValue] == 1 )
            {
                [cell.inputTextField setText:@"是"];
            }
            if ( self.moreButton.isSelected )
                [cell setHidden:NO];
            else
                [cell setHidden:YES];
            [cell resetSeparatorLineShowAll:YES];
            return cell;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ( 0 == indexPath.section )
    {
        switch ( indexPath.row )
        {
            case 1:
            {
                DutyDescribeVC *vc = [[DutyDescribeVC alloc] initWithEduModel:self.viewModel.projectData];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:
            {
                [self displayTimeView:indexPath.row];
                break;
            }
            case 3:
            {
                [self displayTimeView:indexPath.row];
                break;
            }
            case 4:
            {
                ProjectDescripeVC *vc = [[ProjectDescripeVC alloc] initWithEduModel:self.viewModel.projectData];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    else if ( 1 == indexPath.section )
    {
        switch ( indexPath.row )
        {
            case 1:
            {
                ProjectLeverVC *vc = [[ProjectLeverVC alloc] initWithEduModel:self.viewModel.projectData];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:
            {
                CPSuccessDescripteController *vc = [[CPSuccessDescripteController alloc] initWithEduModel:self.viewModel.projectData];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3:
            {
                CPKeYanProjectController *vc = [[CPKeYanProjectController alloc] initWithProjectModel:self.viewModel.projectData];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( 0 == section )
    {
        return self.firstFooterView;
    }
    else
    {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight = 0;
    if ( 0 == section )
    {
        footerHeight = ( 40 + 144 + 40 ) / CP_GLOBALSCALE;
    }
    else
    {
        footerHeight = 0;
    }
    return footerHeight;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    return YES;
}
-(void)displayTimeView:(NSInteger)tag
{
    if (self.textField) {
        [self.textField resignFirstResponder];
    }
    if (!self.timeView)
    {
        self.timeView = [[CPProjectExperienceTimeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
    if (self.timeView.tag == 2)
    {
        if (!self.viewModel.projectData.StartDate || [self.viewModel.projectData.StartDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        str = [NSDate cepinYMDFromString:self.viewModel.projectData.StartDate];
    }
    else
    {
        if (!self.viewModel.projectData.EndDate || [self.viewModel.projectData.EndDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        
        str = [NSDate cepinYMDFromString:self.viewModel.projectData.EndDate];
    }
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue];
}
-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if (self.timeView.tag == 3)
    {
        self.viewModel.projectData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    else
    {
        self.viewModel.projectData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
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
#pragma mark - getter 
- (UIView *)firstFooterView
{
    if ( !_firstFooterView )
    {
        _firstFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 40 + 144 + 40 ) / CP_GLOBALSCALE)];
        [_firstFooterView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_firstFooterView addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _firstFooterView.mas_top ).offset( 40 / CP_GLOBALSCALE );
            make.left.equalTo( _firstFooterView.mas_left );
            make.bottom.equalTo( _firstFooterView.mas_bottom ).offset( -40 / CP_GLOBALSCALE );
            make.right.equalTo( _firstFooterView.mas_right );
        }];
    }
    return _firstFooterView;
}
- (UIView *)secondFooterView
{
    if ( !_secondFooterView )
    {
        _secondFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ( 60 + 144 + 60 ) / CP_GLOBALSCALE)];
        [_secondFooterView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_secondFooterView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _secondFooterView.mas_top ).offset( 60 / CP_GLOBALSCALE );
            make.left.equalTo( _secondFooterView.mas_left ).offset( 40 / CP_GLOBALSCALE );
            make.bottom.equalTo( _secondFooterView.mas_bottom ).offset( -60 / CP_GLOBALSCALE );
            make.right.equalTo( _secondFooterView.mas_right ).offset( -40 / CP_GLOBALSCALE );
        }];
    }
    return _secondFooterView;
}
- (CPResumeMoreButton *)moreButton
{
    if ( !_moreButton )
    {
        _moreButton = [CPResumeMoreButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"288add"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"247ec9"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_moreButton setTitle:@"展开更多模块" forState:UIControlStateNormal];
        [_moreButton setTitle:@"收起更多模块" forState:UIControlStateSelected];
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_moreButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_moreButton.layer setMasksToBounds:YES];
        [_moreButton setImage:[UIImage imageNamed:@"ic_down"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"ic_up"] forState:UIControlStateSelected];
        [_moreButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(CPResumeMoreButton *sender) {
            sender.selected = !sender.isSelected;
            if ( sender.selected )
                self.lastRoWHeight = 144 / CP_GLOBALSCALE;
            else
                self.lastRoWHeight = 0.0;
            if ( 1 == [self.resume.ResumeType intValue] )
            {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else if ( 2 == [self.resume.ResumeType intValue] )
            {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1], [NSIndexPath indexPathForRow:1 inSection:1], [NSIndexPath indexPathForRow:2 inSection:1], [NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    return _moreButton;
}
- (UIButton *)deleteButton
{
    if ( !_deleteButton )
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE ]];
        [_deleteButton setTitle:@"删除该项项目经验" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor colorWithHexString:@"288add"] forState:UIControlStateNormal];
        [_deleteButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_deleteButton.layer setBorderColor:[UIColor colorWithHexString:@"288add"].CGColor];
        [_deleteButton.layer setBorderWidth:2 / CP_GLOBALSCALE];
        [_deleteButton.layer setMasksToBounds:YES];
        [_deleteButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            TBLoading *load = [TBLoading new];
            [load start];
            NSString *userId = [MemoryCacheData shareInstance].userLoginData.UserId;
            NSString *TokenId = [MemoryCacheData shareInstance].userLoginData.TokenId;
            RACSignal *signal = [[RTNetworking shareInstance]deleteThridResumeProjectListWithResumeId:self.viewModel.resumeId Id:self.viewModel.projectId userId:userId tokenId:TokenId];
            @weakify(self);
            [signal subscribeNext:^(RACTuple *tuple){
                @strongify(self);
                if (load)
                {
                    [load stop];
                }
                NSDictionary *dic = (NSDictionary *)tuple.second;
                if ([dic resultSucess])
                {
//                    [OMGToast showWithText:@"操作成功" topOffset:ShowTextBottomAboveKeyboard duration:ShowTextTimeout];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    if ([dic isMustAutoLogin])
                    {
                        [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                    }
                    else
                    {
                        [OMGToast showWithText:[dic resultErrorMessage] bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
                    }
                }
            } error:^(NSError *error){
                if (load)
                {
                    [load stop];
                }
                [OMGToast showWithText:NetWorkError bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            }];
        }];
    }
    return _deleteButton;
}
@end
