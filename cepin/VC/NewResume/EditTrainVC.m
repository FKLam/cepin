//
//  EditTrainVC.m
//  cepin
//
//  Created by dujincai on 15/6/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditTrainVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "ResumeEditCell.h"
#import "EditDesVC.h"
#import "ResumeThridTimeView.h"
#import "NSDate-Utilities.h"
#import "TrainContentVC.h"
#import "EditTrainVM.h"
#import "CPTestEnsureArrowCell.h"
#import "CPTestEnsureEditCell.h"
#import "RTNetworking+Resume.h"
#import "CPCommon.h"
@interface EditTrainVC ()<UITextFieldDelegate, ResumeThridTimeViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,retain)ResumeThridTimeView *timeView;
@property(nonatomic,strong)EditTrainVM *viewModel;
@property(nonatomic,strong)UITextField *textField;
@property (nonatomic, strong) UIView *secondFooterView;
@property (nonatomic, strong) UIButton *deleteButton;
@end
@implementation EditTrainVC
- (instancetype)initWithModel:(TrainingDataModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[EditTrainVM alloc]initWithWork:model];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑培训经历";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.textField resignFirstResponder];
        [self.viewModel saveTrain];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
    self.tableView.tableFooterView = self.secondFooterView;
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
#pragma mark - UITableViewDatasoure UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 || indexPath.row == 3) {
        CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
        switch (indexPath.row) {
            case 2:
            {
                [cell configCellLeftString:@"培训课程" placeholder:@"请填写"];
                [cell.inputTextField setTag:indexPath.row];
                cell.inputTextField.text = self.viewModel.trainData.Name;
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    if ( indexPath.row != cell.inputTextField.tag )
                        return;
                    self.viewModel.trainData.Name = text;
                }];
            }
                break;
            case 3:
            {
                [cell configCellLeftString:@"培训结构" placeholder:@"请填写"];
                [cell.inputTextField setTag:indexPath.row];
                cell.inputTextField.text = self.viewModel.trainData.Organization;
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    if ( indexPath.row != cell.inputTextField.tag )
                        return;
                    self.viewModel.trainData.Organization = text;
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
        case 0:
        {
            [cell configCellLeftString:@"开始时间" placeholder:@"请输入开始时间"];
            [cell.inputTextField setTag:indexPath.row];
            cell.inputTextField.text = [NSDate cepinYMDFromString:self.viewModel.trainData.StartDate];
        }
            break;
        case 1:
        {
            [cell configCellLeftString:@"结束时间" placeholder:@"请输入结束时间"];
            [cell.inputTextField setTag:indexPath.row];
            if (!self.viewModel.trainData.EndDate || [self.viewModel.trainData.EndDate isEqualToString:@""]) {
                cell.inputTextField.text = @"至今";
            }else{
                cell.inputTextField.text = [NSDate cepinYMDFromString:self.viewModel.trainData.EndDate];
            }
        }
            break;
        case 4:
        {
            [cell configCellLeftString:@"培训内容" placeholder:@"请填写"];
            [cell.inputTextField setTag:indexPath.row];
            if (self.viewModel.trainData.Content && ![self.viewModel.trainData.Content isEqualToString:@""]) {
                cell.inputTextField.text = @"已添加";
            }
        }
            break;
        default:
            break;
    }
    if ( 4 == indexPath.row )
        [cell resetSeparatorLineShowAll:YES];
    else
        [cell resetSeparatorLineShowAll:NO];
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
            [self.view endEditing:YES];
            [self displayTimeView:indexPath.row];
        }
            break;
        case 1:
        {
            [self.view endEditing:YES];
            [self displayTimeView:indexPath.row];
        }
            break;
        case 4:
        {
            TrainContentVC *vc = [[TrainContentVC alloc] initWithModel:self.viewModel.trainData];
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
-(void)displayTimeView:(NSInteger)tag
{
    if (self.textField) {
        [self.textField resignFirstResponder];
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
    if ( self.timeView.tag == 0 )
    {
        if (!self.viewModel.trainData.StartDate || [self.viewModel.trainData.StartDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        str = [NSDate cepinYMDFromString:self.viewModel.trainData.StartDate];
    }
    else
    {
        if (!self.viewModel.trainData.EndDate || [self.viewModel.trainData.EndDate isEqualToString:@""])
        {
            NSDate *date = [NSDate date];
            NSString *strYear = [date stringyyyyFromDate];
            NSString *strMonth = [date stringMMFromDate];
            [self.timeView setCurrentYearAndMonth:strYear.intValue month:strMonth.intValue];
            return;
        }
        str = [NSDate cepinYMDFromString:self.viewModel.trainData.EndDate];
    }
    NSArray *array = [str componentsSeparatedByString:@"."];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    [self.timeView setCurrentYearAndMonth:year.intValue month:month.intValue];
}
-(void)clickEnsureButton:(NSUInteger)year month:(NSUInteger)month
{
    if ( self.timeView.tag == 1 )
    {
        self.viewModel.trainData.EndDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
    }
    else
    {
        self.viewModel.trainData.StartDate = [NSString stringWithFormat:@"%lu-%lu-1",(unsigned long)year,(unsigned long)month];
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - getter
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
- (UIButton *)deleteButton
{
    if ( !_deleteButton )
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE ]];
        [_deleteButton setTitle:@"删除该项培训经历" forState:UIControlStateNormal];
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
            
            RACSignal *signal = [[RTNetworking shareInstance]deleteThridResumeTrainListWithResumeId:self.viewModel.resumeId Id:self.viewModel.trainId userId:userId tokenId:TokenId];
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
