//
//  AddProjectVC.m
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AddProjectVC.h"
#import "UIViewController+NavicationUI.h"
#import "ResumeProjectCell.h"
#import "EditProjectVC.h"
#import "AddProjectVM.h"
#import "ProjectListVC.h"
#import "CPProjectExperienceCell.h"
#import "CPResumeProjectReformer.h"
@interface AddProjectVC ()<ResumeProjectCellDelegate>
@property(nonatomic,strong)AddProjectVM *viewModel;
@property(nonatomic,retain)NSIndexPath      *currentIndexPath;
@property(nonatomic,strong)UIImageView *wuImage;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)UILabel *secLabel;
@property (nonatomic, strong) ResumeNameModel *resume;
@end

@implementation AddProjectVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[AddProjectVM alloc] initWithResumeModel:model];
        self.viewModel.showMessageVC = self;
        self.resume = model;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getProjectList];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目经验";
    [MobClick event:@"project_experience_launch"];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeAddExperience] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        ProjectListVC *vc = [[ProjectListVC alloc] initWithResume:self.resume];
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
            self.subLabel.hidden = YES;
            self.secLabel.hidden = YES;
             self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else if([self requestStateWithStateCode:stateCode] == HUDCodeNetWork)
        {
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
            [self.networkImage setImage:UIIMAGE(@"null_info")];
            [self.networkLabel setText:@"您还没有填写任何信息,\n马上添加为简历加分吧!"];
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
//            self.subLabel.hidden = NO;
//            self.secLabel.hidden = NO;
            self.tableView.hidden = YES;
        }
        
    }];
    [RACObserve(self.viewModel,deleteCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            [self.viewModel getProjectList];
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
- (void)clickNetWorkButton{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getProjectList];
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListDataModel *model = [ProjectListDataModel beanFromDictionary:self.viewModel.projectDatas[indexPath.row]];
    return [CPResumeProjectReformer projectHeightWith:model];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.projectDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListDataModel *model = [ProjectListDataModel beanFromDictionary:self.viewModel.projectDatas[indexPath.row]];
    CPProjectExperienceCell *cell = [CPProjectExperienceCell projectExperienceCellWithTableView:tableView];
    [cell configCellWithProjectExperience:model];
    __weak typeof( self ) weakSelf = self;
    [cell.editButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        ProjectListDataModel *model = [ProjectListDataModel beanFromDictionary:weakSelf.viewModel.projectDatas[indexPath.row]];
        EditProjectVC *vc = [[EditProjectVC alloc] initWithModel:model resume:self.resume];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [MobClick event:@"edit_project_experience"];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ProjectListDataModel *model = [ProjectListDataModel beanFromDictionary:self.viewModel.projectDatas[indexPath.row]];
//    EditProjectVC *vc = [[EditProjectVC alloc]initWithModel:model];
//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)PushCellDelete:(ResumeProjectCell *)cell model:(EducationListDateModel *)model
{
    [self.viewModel deleteProjectListWith:model.Id];
}
-(void)GestureGo:(ResumeProjectCell *)cell isReset:(BOOL)isReset
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (isReset)
    {
        if (self.currentIndexPath)
        {
            if (self.currentIndexPath.row != indexPath.row)
            {
                ResumeProjectCell *cell = (ResumeProjectCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
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
        ResumeProjectCell *cell = (ResumeProjectCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell resetCell];
        self.currentIndexPath = nil;
    }
}
@end
