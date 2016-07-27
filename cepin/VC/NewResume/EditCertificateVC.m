//
//  EditCertificateVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditCertificateVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "ResumeThridTimeView.h"
#import "NSDate-Utilities.h"
#import "CertificateNameVC.h"
#import "EditCertificateVM.h"
#import "CPTestEnsureArrowCell.h"
#import "RTNetworking+Resume.h"
#import "CPCommon.h"
@interface EditCertificateVC ()<ResumeThridTimeViewDelegate>
@property(nonatomic,retain)ResumeThridTimeView *timeView;
@property(nonatomic,strong)EditCertificateVM *viewModel;
@property (nonatomic, strong) UIView *secondFooterView;
@property (nonatomic, strong) UIButton *deleteButton;
@end
@implementation EditCertificateVC
- (instancetype)initWithModel:(CredentialListDataModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[EditCertificateVM alloc] initWithWork:model];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑专业证书";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.viewModel saveCred];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
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
    switch (indexPath.row) {
        case 0:
        {
            [cell configCellLeftString:@"证书名称" placeholder:@"请选择"];
            [cell.inputTextField setTag:indexPath.row];
            cell.inputTextField.text = self.viewModel.credData.Name;
        }
            break;
        case 1:
        {
            [cell configCellLeftString:@"获得时间" placeholder:@"请选择"];
            [cell.inputTextField setTag:indexPath.row];
            cell.inputTextField.text = [NSDate cepinYMDFromString:self.viewModel.credData.Date];
        }
            break;
        default:
            break;
    }
    BOOL isShowAll = NO;
    if ( 1 == indexPath.row )
        isShowAll = YES;
    [cell resetSeparatorLineShowAll:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            [MobClick event:@"fill_zyzs"];
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
        [_deleteButton setTitle:@"删除该项专业证书" forState:UIControlStateNormal];
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
            RACSignal *signal = [[RTNetworking shareInstance]deleteThridResumeCredentialListWithResumeId:self.viewModel.resumeId Id:self.viewModel.credId userId:userId tokenId:TokenId];
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
