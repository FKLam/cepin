//
//  EditLanguageVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EditLanguageVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeArrowCell.h"
#import "CategoryVC.h"
#import "SpeakVC.h"
#import "WriteVC.h"
#import "EditLanguageVM.h"
#import "CPTestEnsureArrowCell.h"
#import "RTNetworking+Resume.h"
#import "CPCommon.h"
@interface EditLanguageVC ()
@property (nonatomic, strong) EditLanguageVM *viewModel;
@property (nonatomic, strong) UIView *secondFooterView;
@property (nonatomic, strong) UIButton *deleteButton;
@end
@implementation EditLanguageVC
- (instancetype)initWithModel:(LanguageDataModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[EditLanguageVM alloc]initWithWork:model];
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
    self.title = @"编辑语言能力";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.viewModel saveLanguage];
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
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTestEnsureArrowCell *cell = [CPTestEnsureArrowCell ensureArrowCellWithTableView:tableView];
    switch (indexPath.row) {
        case 0:
        {
            [cell configCellLeftString:@"语言类别" placeholder:@"请选择"];
            [cell.inputTextField setTag:indexPath.row];
            cell.inputTextField.text = self.viewModel.langData.Name;
            [cell resetSeparatorLineShowAll:NO];
        }
            break;
        case 1:
        {
            [cell configCellLeftString:@"听说能力" placeholder:@"请选择"];
            [cell.inputTextField setTag:indexPath.row];
            cell.inputTextField.text = self.viewModel.langData.Speaking;
            [cell resetSeparatorLineShowAll:NO];
        }
            break;
        case 2:
        {
            [cell configCellLeftString:@"读写能力" placeholder:@"请选择"];
            [cell.inputTextField setTag:indexPath.row];
            cell.inputTextField.text = self.viewModel.langData.Writing;
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
    switch (indexPath.row) {
        case 0:
        {
            CategoryVC *vc = [[CategoryVC alloc] initWithEduModel:self.viewModel.langData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            SpeakVC *vc = [[SpeakVC alloc] initWithEduModel:self.viewModel.langData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            WriteVC *vc = [[WriteVC alloc] initWithEduModel:self.viewModel.langData];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
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
        [_deleteButton setTitle:@"删除该项语言能力" forState:UIControlStateNormal];
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
            RACSignal *signal = [[RTNetworking shareInstance]deleteThridResumeLanguageListWithResumeId:self.viewModel.resumeId Id:self.viewModel.langId userId:userId tokenId:TokenId];
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
