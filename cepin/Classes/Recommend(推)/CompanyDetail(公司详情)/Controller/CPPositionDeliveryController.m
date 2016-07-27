//
//  CPPositionDeliveryController.m
//  cepin
//
//  Created by ceping on 16/3/21.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPPositionDeliveryController.h"
#import "DynamicExamVC.h"
#import "JobSearchTitleCell.h"
#import "RecommendCell.h"
#import "JobSearchModel.h"
#import "JobSendResumeSucessVM.h"
#import "NewJobDetialVC.h"
#import "DynamicExamDetailVC.h"
#import "DynamicExamModelDTO.h"
#import "CPRecommendModelFrame.h"
#import "CPRecommendCell.h"
#import "ResumeNameVC.h"
#import "CPYouCanLookOtherHeaderView.h"
#import "CPCompanyDetailPositionCell.h"
#import "CPHomePositionDetailController.h"
#import "CPCommon.h"
@interface CPPositionDeliveryController ()
@property (nonatomic, strong) CPYouCanLookOtherHeaderView *youCanLookOtherHeaderView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *sucessImageView;
@property (nonatomic, strong) UILabel *sucessLabel;
@property (nonatomic, strong) UILabel *testTipsLabel;
@property (nonatomic, strong) UIButton *testButton;
@property(nonatomic,strong) JobSendResumeSucessVM *viewModel;
@property (nonatomic, strong) NSIndexPath *custemSelecetdIndexPath;
@end

@implementation CPPositionDeliveryController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {
        [self setTitle:@"投递成功"];
    }
    return self;
}
- (instancetype)initWithPositionId:(NSString*)positionId
{
    self = [super init];
    if (self) {
        self.viewModel = [[JobSendResumeSucessVM alloc] initWithPositionId:positionId];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"投递成功"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    [self createNoHeadImageTable];
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setHidden:YES];
    [self.tableView setRowHeight:(60 + 48 + 40 + 36 + 60) / CP_GLOBALSCALE];
    [self.view addSubview:self.tableView];
//    self.tableView.tableHeaderView = self.topView ;
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo( self.view.mas_top );
//        make.left.equalTo( self.view.mas_left );
//        make.bottom.equalTo( self.view.mas_bottom );
//        make.right.equalTo( self.view.mas_right );
//    }];
    [RACObserve(self.viewModel, examListStateCode) subscribeNext:^(id stateCode) {
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            DynamicExamModelDTO *model = [DynamicExamModelDTO beanFromDictionary:self.viewModel.datas[0]];
            DynamicExamDetailVC *vc = [[DynamicExamDetailVC alloc]initWithUrl:model.ExamUrl examDetail:examDetailOther];
            vc.title = model.Title;
            vc.strTitle = model.Title;
            vc.urlPath = model.ExamUrl;
            vc.urlLogo = model.ImgFilePath;
            vc.isJiSuCepin = YES;
            vc.contentText = model.Introduction;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if (!stateCode)
        {
            return ;
        }
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            if (self.viewModel.datas.count > 0) {
                self.tableView.hidden = NO;
            }
            else
            {
                self.tableView.hidden = NO;
            }
        }
        else
        {
            self.tableView.hidden = NO;
        }
        [self.tableView reloadData];
    }];
    [RACObserve(self.viewModel, isExamStateCode)subscribeNext:^(id isExamStateCode) {
        if ([self requestStateWithStateCode:isExamStateCode] == HUDCodeSucess) {
            if ( self.viewModel.isExam )
            {
                self.testTipsLabel.hidden = YES;
                self.testButton.hidden = YES;
                self.tableView.hidden = NO;
                self.tableView.tableHeaderView = self.topView;
                [self.topView setFrame:CGRectMake(0, 64, kScreenWidth, ( 216 + 280 + 84 + 48 + 144 ) / CP_GLOBALSCALE)];
                [self.viewModel loadDataWithPage:0];
            }
            else
            {
                self.testTipsLabel.hidden = NO;
                self.tableView.tableHeaderView = self.topView;
                self.testButton.hidden = NO;
                self.tableView.hidden = NO;
//                self.topView
                [self.topView setFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
            }
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel isOpenSpeedExam];
    [self.viewModel allPositionId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( self.custemSelecetdIndexPath )
            {
                NSArray *indexPathArray = [NSArray arrayWithObject:self.custemSelecetdIndexPath];
                [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                self.custemSelecetdIndexPath = nil;
            }
        });
    });
}
-(void)reloadData
{
    [self refleshTable];
}
-(void)refleshTable
{
    [self.viewModel reflashPage];
}
-(void)updateTable
{
    [self.viewModel nextPage];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( 0 == [self.viewModel.datas count] )
        [self.youCanLookOtherHeaderView setHidden:YES];
    else
        [self.youCanLookOtherHeaderView setHidden:NO];
    return self.youCanLookOtherHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeaderHeight = ( 40 + 42 + 20) / CP_GLOBALSCALE;
    return sectionHeaderHeight;
}
// 绘制cell
- (void)drawCell:(CPRecommendCell *)cell withIndexPath:(NSIndexPath *)indexPath offSet:(NSInteger)offSet
{
    [cell clear];
    CPRecommendModelFrame *recommendModelFrame;
    recommendModelFrame = self.viewModel.datas[indexPath.row -offSet];
    // 检查cell是否被查阅过
    BOOL isChecked = NO;
    JobSearchModel *recommendModel = nil;
    if( [recommendModelFrame.recommendModel isKindOfClass:[JobSearchModel class]] )
        recommendModel = (JobSearchModel *)recommendModelFrame.recommendModel;
    if( nil != recommendModel )
    {
        for (PositionIdModel *model in self.viewModel.positionIdArray) {
            
            if ([model.positionId isEqualToString:recommendModel.PositionId]) {
                isChecked = YES;
                break;
            }
        }
    }
    recommendModelFrame.isCheck = isChecked;
    cell.recommendModelFrame = recommendModelFrame;
    [cell draw];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPCompanyDetailPositionCell *cell = [CPCompanyDetailPositionCell guessCellWithTableView:tableView];
    CPRecommendModelFrame *recommend = self.viewModel.datas[indexPath.row];
    BOOL isRead = NO;
    JobSearchModel *model = recommend.recommendModel;
    BOOL isHideSeparatorLine = NO;
    if ( indexPath.row == [self.viewModel.datas count] - 1 )
        isHideSeparatorLine = YES;
    for (PositionIdModel *positionID in self.viewModel.positionIdArray )
    {
        if ( [model.PositionId isEqualToString:positionID.positionId] )
        {
            isRead = YES;
            break;
        }
    }
    [cell setContentIsRead:isRead];
    [cell configCellWithDatas:recommend];
    [cell setLastCellIsHide:isHideSeparatorLine];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
    JobSearchModel *bean = recommendModelFrame.recommendModel;
    CPHomePositionDetailController *companyDetailVC = [[CPHomePositionDetailController alloc] init];
    [companyDetailVC configWithPosition:bean];
    [self.navigationController pushViewController:companyDetailVC animated:YES];
    self.custemSelecetdIndexPath = indexPath;
}
#pragma mark - getter methods
- (UIView *)topView
{
    if ( !_topView )
    {
        _topView = [[UIView alloc] init];
        [self.topView setFrame:CGRectMake(0, 64, kScreenWidth, ( 216 + 280 + 84 + 48 + 144 ) / CP_GLOBALSCALE)];
        [_topView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        [_topView addSubview:self.sucessImageView];
        [self.sucessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( _topView.mas_top ).offset( 216 / CP_GLOBALSCALE );
            make.centerX.equalTo( _topView.mas_centerX );
            make.width.equalTo( @( 280 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 280 / CP_GLOBALSCALE ) );
        }];
        [_topView addSubview:self.sucessLabel];
        [self.sucessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.sucessImageView.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
            make.centerX.equalTo( _topView.mas_centerX );
        }];
        [_topView addSubview:self.testTipsLabel];
        [self.testTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.sucessLabel.mas_bottom ).offset( 20 / CP_GLOBALSCALE );
            make.centerX.equalTo( _topView.mas_centerX );
        }];
        [_topView addSubview:self.testButton];
        [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.testTipsLabel.mas_bottom ).offset( 84 / CP_GLOBALSCALE );
            make.centerX.equalTo( _topView.mas_centerX );
            make.height.equalTo( @( 120 / CP_GLOBALSCALE ) );
            make.width.equalTo( @( 330 / CP_GLOBALSCALE ) );
        }];
    }
    return _topView;
}
- (UIImageView *)sucessImageView
{
    if ( !_sucessImageView )
    {
        _sucessImageView = [[UIImageView alloc] init];
        _sucessImageView.image = [UIImage imageNamed:@"exam_finished"];
    }
    return _sucessImageView;
}
- (UILabel *)sucessLabel
{
    if ( !_sucessLabel )
    {
        _sucessLabel = [[UILabel alloc] init];
        [_sucessLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_sucessLabel setTextAlignment:NSTextAlignmentCenter];
        [_sucessLabel setTextColor:[UIColor colorWithHexString:@"6cbb56"]];
        [_sucessLabel setText:@"恭喜你，投递成功！"];
    }
    return _sucessLabel;
}
- (UILabel *)testTipsLabel
{
    if ( !_testTipsLabel )
    {
        _testTipsLabel = [[UILabel alloc] init];
        [_testTipsLabel setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        [_testTipsLabel setTextAlignment:NSTextAlignmentCenter];
        [_testTipsLabel setTextColor:[UIColor colorWithHexString:@"404040"]];
        [_testTipsLabel setText:@"只差一步，5分钟极速测评提高面试邀请机率80%"];
        [_testTipsLabel setHidden:YES];
    }
    return _testTipsLabel;
}
- (UIButton *)testButton
{
    if ( !_testButton )
    {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testButton setTitle:@"马上测评" forState:UIControlStateNormal];
        [_testButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_testButton.titleLabel setFont:[UIFont systemFontOfSize:48 / CP_GLOBALSCALE]];
        [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff5252"] cornerRadius:0.0] forState:UIControlStateNormal];
        [_testButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d84545"] cornerRadius:0.0] forState:UIControlStateHighlighted];
        [_testButton.layer setCornerRadius:10 / CP_GLOBALSCALE];
        [_testButton.layer setMasksToBounds:YES];
        [_testButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.viewModel getExamList];
            [MobClick event:@"send_succeed_cepin"];
        }];
        [_testButton setHidden:YES];
    }
    return _testButton;
}
- (CPYouCanLookOtherHeaderView *)youCanLookOtherHeaderView
{
    if ( !_youCanLookOtherHeaderView )
    {
        _youCanLookOtherHeaderView = [[CPYouCanLookOtherHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (40 + 42 + 20) / CP_GLOBALSCALE)];
    }
    return _youCanLookOtherHeaderView;
}
@end
