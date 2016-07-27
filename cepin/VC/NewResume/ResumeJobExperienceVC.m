//
//  ResumeJobExperienceVC.m
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeJobExperienceVC.h"
#import "ResumeJobExperienceCell.h"
#import "UIViewController+NavicationUI.h"
#import "ResumuEditJobExperienceVC.h"
#import "ResumeJobExperienceVM.h"
#import "ResumeAddJobVC.h"
#import "SchoolResumeAddJobVC.h"
#import "SchoolEditJobVC.h"
#import "CPWorkExperienceCell.h"
#import "CPCommon.h"
@interface ResumeJobExperienceVC ()<ResumeJobExperienceCellDelegate>
@property(nonatomic,strong)ResumeJobExperienceVM *viewModel;
@property(nonatomic,strong)UIImageView *wuImage;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)UILabel *secLabel;
@property(nonatomic,retain)NSIndexPath      *currentIndexPath;
@property(nonatomic,strong)NSNumber *resumeType;
@property(nonatomic,assign)BOOL isSocial;
@property (nonatomic, strong) ResumeNameModel *resume;
@end
//ic_error
@implementation ResumeJobExperienceVC
- (instancetype)initWithModel:(ResumeNameModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [[ResumeJobExperienceVM alloc] initWithResumeModel:model];
        self.resumeType = model.ResumeType;
        self.resume = model;
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel getWorkList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"work_experience_launch"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    if(self.resumeType.intValue == 2){
        self.title = @"实习经历";
        self.isSocial = NO;
    }
    else
    {
        self.title = @"工作经历";
        self.isSocial = YES;
    }
    [[self addNavicationObjectWithType:NavcationBarObjectTypeAddExperience] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if( self.resumeType.intValue == 2 ){
            SchoolResumeAddJobVC *vc = [[SchoolResumeAddJobVC alloc] initWithResumeId:self.viewModel.resumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            ResumeAddJobVC *vc = [[ResumeAddJobVC alloc] initWithResume:self.viewModel.resume];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        }
        else if ([self requestStateWithStateCode:stateCode] == HUDCodeNetWork){
             [self.networkImage setImage:UIIMAGE(@"null_exam_linkbroken")];
            [self.networkLabel setText:@"当前网络不可用，请检查网络设置"];
            self.networkImage.hidden = NO;
            self.networkLabel.hidden = NO;
            self.networkButton.hidden = NO;
            self.clickImage.hidden = NO;
//            self.subLabel.hidden = YES;
//            self.secLabel.hidden = YES;
            self.tableView.hidden = YES;
        }
        else
        {
            if ( self.viewModel.jobDatas.count == 0 )
            {
                self.networkImage.hidden = NO;

            }
            else
            {
                self.networkImage.hidden = YES;
                
            }
            [self.networkImage setImage:UIIMAGE(@"null_info")];
            [self.networkLabel setText:@"您还没有填写任何信息,\n马上添加为简历加分吧!"];
            self.networkLabel.hidden = NO;
            self.networkImage.hidden = NO;
            self.tableView.hidden = YES;
//            self.subLabel.hidden = NO;
//            self.secLabel.hidden = NO;
        }
        
    }];
    [RACObserve(self.viewModel,deleteCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            [self.viewModel getWorkList];
        }
    }];
    self.subLabel = [[UILabel alloc]init];
    self.subLabel.text = @"您还没有填写任何信息,";
    self.subLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE] ;
    self.subLabel.textColor = [UIColor colorWithHexString:@"404040"];
    self.subLabel.hidden = YES;
    [self.view addSubview:self.subLabel];
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.networkImage.mas_bottom).offset(10);
        make.height.equalTo(@(40));
        make.width.equalTo(@(250));
    }];
    self.secLabel = [[UILabel alloc]init];
    self.secLabel.text = @"马上添加为简历加分吧!";
    self.secLabel.font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE] ;
    self.secLabel.textColor = [UIColor colorWithHexString:@"404040"];
    self.secLabel.textAlignment = NSTextAlignmentCenter;
    self.secLabel.hidden = YES;
    [self.view addSubview:self.secLabel];
    [self.secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.subLabel.mas_bottom);
        make.height.equalTo(@(40));
        make.width.equalTo(@(250));
    }];
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getWorkList];
}
#pragma mark - UITableViewDatasource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = ( 60 + 60 + 36 + 60 + 42 + 20 + 36 + 40 + 36 * 2 + 20 + 60 + 6 ) / CP_GLOBALSCALE;
    if ( 2 == [self.resume.ResumeType intValue] )
    {
        rowHeight = ( 60 + 60 + 36 + 60 + 42 + 20 + 36 + 60 + 6 ) / CP_GLOBALSCALE;
    }
    return rowHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.jobDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkListDateModel *model = [WorkListDateModel beanFromDictionary:self.viewModel.jobDatas[indexPath.row]];
    self.currentIndexPath = indexPath;
    CPWorkExperienceCell *cell = [CPWorkExperienceCell workExperienceCellWithTableView:tableView];
    [cell configCellWithWorkExperience:model resume:self.resume];
    __weak typeof( self ) weakSelf = self;
    [cell.editButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        WorkListDateModel *model = [WorkListDateModel beanFromDictionary:weakSelf.viewModel.jobDatas[indexPath.row]];
        if( weakSelf.resumeType.intValue == 2 ){
            SchoolEditJobVC *vc = [[SchoolEditJobVC alloc] initWithModel:model resume:self.resume];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            ResumuEditJobExperienceVC *vc = [[ResumuEditJobExperienceVC alloc] initWithModel:model isSocial:weakSelf.isSocial resume:self.resume];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(void)PushCellDelete:(ResumeJobExperienceCell *)cell model:(WorkListDateModel *)model
{
    [self.viewModel deleteWorkListWith:model.Id];
   
    [self.tableView reloadData];
}
-(void)GestureGo:(ResumeJobExperienceCell *)cell isReset:(BOOL)isReset
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (isReset)
    {
        if (self.currentIndexPath)
        {
            if (self.currentIndexPath.row != indexPath.row)
            {
                ResumeJobExperienceCell *cell = (ResumeJobExperienceCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
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
//    if (self.currentIndexPath)
//    {
//        ResumeJobExperienceCell *cell = (ResumeJobExperienceCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
//        [cell resetCell];
//        self.currentIndexPath = nil;
//    }
}

@end
