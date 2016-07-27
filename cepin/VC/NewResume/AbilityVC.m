//
//  AbilityVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AbilityVC.h"
#import "AbilltyListCell.h"
#import "UIViewController+NavicationUI.h"
#import "EditAbilityVC.h"
#import "AbilityVM.h"
#import "AddAbilityVC.h"
#import "CPSkillAbilityCell.h"
#import "CPCommon.h"
@interface AbilityVC ()<AbilltyListCellDelegate>
@property(nonatomic,strong)AbilityVM *viewModel;
@property(nonatomic,retain)NSIndexPath      *currentIndexPath;
@property(nonatomic,strong)UIImageView *wuImage;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)UILabel *secLabel;
@end
@implementation AbilityVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[AbilityVM alloc]initWithResumeModel:model];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"专业技能";
    [[self addNavicationObjectWithType:NavcationBarObjectTypeAddExperience] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        AddAbilityVC *vc = [[AddAbilityVC alloc] initWithResumeId:self.viewModel.resumeId];
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event:@"edit_skill"];
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
            self.networkButton.hidden = YES;
            self.networkLabel.hidden = YES;
            self.secLabel.hidden = YES;
             self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else if([self requestStateWithStateCode:stateCode] == HUDCodeNetWork){
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
            [self.viewModel getSkillList];
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
    self.networkImage.hidden = YES;
    self.subLabel.hidden = YES;
    self.secLabel.hidden = YES;
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getSkillList];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getSkillList];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ( 60 + 60 + 36 + 60 + 6 ) / CP_GLOBALSCALE;
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.skillDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPSkillAbilityCell *cell = [CPSkillAbilityCell skillCellWithTableView:tableView];
    SkillDataModel *model = [SkillDataModel beanFromDictionary:self.viewModel.skillDatas[indexPath.row]];
    [cell configCellWithSkill:model];
    [cell.editButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        EditAbilityVC *vc = [[EditAbilityVC alloc] initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SkillDataModel *model = [SkillDataModel beanFromDictionary:self.viewModel.skillDatas[indexPath.row]];
//    EditAbilityVC *vc = [[EditAbilityVC alloc]initWithModel:model];
//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)PushCellDelete:(AbilltyListCell *)cell model:(CredentialListDataModel *)model
{
    [self.viewModel deleteSkillListWith:model.Id];
}
-(void)GestureGo:(AbilltyListCell *)cell isReset:(BOOL)isReset
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (isReset)
    {
        if (self.currentIndexPath)
        {
            if (self.currentIndexPath.row != indexPath.row)
            {
                AbilltyListCell *cell = (AbilltyListCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
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
        AbilltyListCell *cell = (AbilltyListCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell resetCell];
        self.currentIndexPath = nil;
    }
}
@end
