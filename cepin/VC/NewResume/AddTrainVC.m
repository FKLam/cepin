//
//  AddTrainVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddTrainVC.h"
#import "UIViewController+NavicationUI.h"
#import "TrainListCell.h"
#import "EditTrainVC.h"
#import "AddTrainVM.h"
#import "TrainListVC.h"
#import "CPTrainExperienceCell.h"
#import "CPResumeEditReformer.h"
#import "CPCommon.h"
@interface AddTrainVC ()<TrainListCellDelegate>
@property(nonatomic,strong)AddTrainVM *viewModel;
@property(nonatomic,retain)NSIndexPath *currentIndexPath;
@property(nonatomic,strong)UIImageView *wuImage;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)UILabel *secLabel;
@end
@implementation AddTrainVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[AddTrainVM alloc] initWithResumeModel:model];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"培训经历";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeAddExperience] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        TrainListVC *vc = [[TrainListVC alloc] initWithResumeId:self.viewModel.resumeId];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            self.networkImage.hidden = YES;
            self.networkButton.hidden = YES;
            self.networkLabel.hidden = YES;
            self.subLabel.hidden = YES;
            self.secLabel.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else if ([self requestStateWithStateCode:stateCode] == HUDCodeNetWork){
            self.networkLabel.hidden = NO;
            [self.networkImage setImage:UIIMAGE(@"null_exam_linkbroken")];
            [self.networkLabel setText:@"当前网络不可用，请检查网络设置"];
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
            self.tableView.hidden = YES;
        }
        else
        {
            self.networkLabel.hidden = NO;
            [self.networkImage setImage:UIIMAGE(@"null_info")];
            [self.networkLabel setText:@"您还没有填写任何信息,\n马上添加为简历加分吧!"];
            self.networkImage.hidden = NO;
//            self.subLabel.hidden = NO;
//            self.secLabel.hidden = NO;
            self.tableView.hidden = YES;
        }
    }];
    [RACObserve(self.viewModel,deleteCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            
            [self.viewModel getTrainList];
            [self.tableView reloadData];
        }
    }];
    self.subLabel = [[UILabel alloc]init];
    self.subLabel.text = @"您还没有填写任何信息,";
    self.subLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.subLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.networkImage.mas_bottom).offset(10);
        make.height.equalTo(@(40));
        make.width.equalTo(@(250));
    }];
    self.secLabel = [[UILabel alloc]init];
    self.secLabel.text = @"马上添加为简历加分吧!";
    self.secLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.secLabel.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
    self.secLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.secLabel];
    [self.secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.subLabel.mas_bottom);
        make.height.equalTo(@(40));
        make.width.equalTo(@(250));
    }];
    self.wuImage.hidden = YES;
    self.subLabel.hidden = YES;
    self.secLabel.hidden = YES;
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getTrainList];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getTrainList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingDataModel *model = [TrainingDataModel beanFromDictionary:self.viewModel.trainDatas[indexPath.row]];
    CGFloat height = [CPResumeEditReformer trainDescribeHeight:model];
    CGFloat fixldH = ( 60 + 60 + 36 + 60 + 42 + 20 + 36 + 40 + 60 + 6 ) / CP_GLOBALSCALE;
    height += fixldH;
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.trainDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainingDataModel *model = [TrainingDataModel beanFromDictionary:self.viewModel.trainDatas[indexPath.row]];
    CPTrainExperienceCell *cell = [CPTrainExperienceCell trainCellWithTableView:tableView];
    [cell configCellWithtrain:model];
    [cell.editButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        EditTrainVC *vc = [[EditTrainVC alloc] initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }];    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TrainingDataModel *model = [TrainingDataModel beanFromDictionary:self.viewModel.trainDatas[indexPath.row]];
//    EditTrainVC *vc = [[EditTrainVC alloc]initWithModel:model];
//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)PushCellDelete:(TrainListCell *)cell model:(TrainingDataModel *)model
{
    [self.viewModel deleteTrainListWith:model.Id];
}
-(void)GestureGo:(TrainListCell *)cell isReset:(BOOL)isReset
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (isReset)
    {
        if (self.currentIndexPath)
        {
            if (self.currentIndexPath.row != indexPath.row)
            {
                TrainListCell *cell = (TrainListCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
                [cell resetCell];
            }
        }
        self.currentIndexPath = indexPath;
    }
    else
    {
        self.currentIndexPath = nil;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.currentIndexPath)
    {
        TrainListCell *cell = (TrainListCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell resetCell];
        self.currentIndexPath = nil;
    }
}
@end
