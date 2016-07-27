//
//  AllResumeVC.m
//  cepin
//
//  Created by ceping on 15-3-10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "AllResumeVC.h"
#import "AllResumeCell.h"
#import "ResumeMenuView.h"
#import "UmengView.h"
#import "TBUmengShareConfig.h"
#import "AllResumeVM.h"
#import "AllResumeDataModel.h"
#import "AutoLoginVM.h"
#import "TBTextUnit.h"
#import "FullResumeMenuView.h"
#import "FullResumeVC.h"
#import "UIViewController+NavicationUI.h"
#import "AddResumeVC.h"
#import "ResumuEditJobExperienceVC.h"
#import "ResumeJobExperienceVC.h"
#import "ResumeNameVC.h"
#import "ResumeGuildView.h"
#import "CreateResumeDialogView.h"
#import "CreateResumeByInfoVC.h"
#import "CreateSchoolResumeByInfoVC.h"
#import "NSString+Extension.h"
#import "CPCommon.h"
#import "CPProfileMyResumesCell.h"
#import "CPWatchResumeController.h"
#import "CPSchoolResumeEditController.h"
#import "CPSocialResumeReviewController.h"
#import "CPTipsView.h"
@interface AllResumeVC ()<ResumeMenuDelegate,CreateResumeDialogViewDelegate, CPTipsViewDelegate>
@property (nonatomic, retain) FullResumeMenuView *fullMenuView;
@property (nonatomic, retain) ResumeMenuView *menuView;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) AllResumeVM *viewModel;
@property (nonatomic, strong) ResumeGuildView *guildView;
@property (nonatomic, assign) NSUInteger currentMenuView;
@property (nonatomic, strong) CreateResumeDialogView *createResumeDialog;
/** 没有简历时的提示页面 */
@property (nonatomic, weak) UIImageView *noResumeView;
@property (nonatomic, strong) CPTipsView *tipsView;
@end
@implementation AllResumeVC
#pragma mark － 懒加载
/** 没有简历时的提示视图 */
- (UIImageView *)noResumeView
{
    if ( !_noResumeView )
    {
        UIImageView *noResumeView = [[UIImageView alloc] init];
        noResumeView.contentMode = UIViewContentModeCenter;
        noResumeView.frame = self.view.bounds;
        [self.view addSubview:_noResumeView = noResumeView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageNamed:@"null_info"];
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            [[[RTAPPUIHelper shareInstance] backgroundColor] set];
            CGContextFillRect(context, self.view.bounds);
            CGRect imageFrame = CGRectMake((kScreenWidth - image.size.width / 2.0) / 2.0, (336)/CP_GLOBALSCALE+64, image.size.width / 2.0, image.size.height / 2.0);
            [image drawInRect:imageFrame];
            CGContextRestoreGState(context);
            CGContextSaveGState(context);
            [[UIColor blueColor] set];
            NSString *str = @"你还没有简历哦，即刻创建简历投递好工作。";
            CGSize strSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [[RTAPPUIHelper shareInstance] mainTitleFont]} context:nil].size;
            CGRect strFrame = CGRectMake((kScreenWidth - strSize.width) / 2.0, CGRectGetMaxY(imageFrame) + 5.0+90/CP_GLOBALSCALE, strSize.width, strSize.height);
            [str drawInContext11:context withPosition:strFrame.origin andColor:[[RTAPPUIHelper shareInstance] mainTitleColor] andFont:[[RTAPPUIHelper shareInstance] mainTitleFont] andHeight:strSize.height andWidth:strSize.width];
            CGContextRestoreGState(context);
            UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                if( tempImage )
                    self.noResumeView.image = tempImage;
            });
        });
    }
    return _noResumeView;
}
- (id)init
{
    if (self = [super init])
    {
        self.viewModel = [AllResumeVM new];
        self.viewModel.showMessageVC = self;
        self.currentMenuView = -1;
    }
    return self;
}
- (void)clickResume:(int)tag
{
    NSString *resumeId;
    if (nil == self.viewModel.datas || self.viewModel.datas.count==0) {
        resumeId = @"";
    }
    else
    {
        AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:self.viewModel.datas[0]];
        resumeId = model.ResumeId;
    }
    if ( tag == 1 )
    {
        //社招
        CreateResumeByInfoVC *vc = [[CreateResumeByInfoVC alloc] initWithModelId:resumeId resumeName:[self getResumeNameByType:1] ];
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event:@"creat_social_resume"];
    }
    else
    {
        //校招
        CreateSchoolResumeByInfoVC *vc = [[CreateSchoolResumeByInfoVC alloc] initWithModelId:resumeId resumeName:[self getResumeNameByType:2] ];
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event:@"creat_school_resume"];
    }
    [self.createResumeDialog removeFromSuperview];
    self.createResumeDialog = nil;
}
- (void)clickedCancel
{
    [self.createResumeDialog removeFromSuperview];
    self.createResumeDialog = nil;
    if ( [self.viewModel.datas count] > 0 )
        [self.noResumeView setHidden:YES];
    else
        [self.noResumeView setHidden:NO];
}
- (NSString *)getResumeNameByType:(int)type
{
    NSString *name = nil;
    NSString *endname = nil;
    if( 1 == type )
    {
        name = @"我的简历";
    }
    else
    {
        name = @"学生简历";
    }
    endname = name;
    int i = 0;
    int j = 0;
    if ( nil == self.viewModel.datas || self.viewModel.datas.count == 0 )
    {
        return endname;
    }
    while ( i < self.viewModel.datas.count )
    {
        AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:self.viewModel.datas[i]];
        if( model.ResumeType.intValue == type )
        {
            j++;
            endname = [[NSString alloc] initWithFormat:@"%@%d", name, j];
        }
        i++;
    }
    return endname;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"resume_list_launch"];
    self.title = @"我的简历";
    [self createNoHeadImageTable];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeAdd] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.noResumeView.hidden = YES;
        if( self.viewModel.datas.count >= 10 ){
            [OMGToast showWithText:@"一个用户最多创建10份简历" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            return;
        }
        [self.createResumeDialog show];
        [MobClick event:@"create_resume"];
        [MobClick event:@"add_resume_click"];
    }];
    self.menuView = [[ResumeMenuView alloc]initWithFrame:self.view.bounds];
    self.menuView.hidden = YES;
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(!stateCode)
        {
            return;
        }
        switch ([self requestStateWithStateCode:stateCode])
        {
            case HUDCodeSucess:
            {
                self.tableView.hidden = NO;
                self.noResumeView.hidden = YES;
                [self.tableView reloadData];
            }
                break;
            case HUDCodeNone:
            {
                [self.tableView reloadData];
                self.tableView.hidden = YES;
                self.noResumeView.hidden = NO;
            }
                break;
            case HUDCodeNetWork:
            {
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.networkButton.hidden = NO;
                self.clickImage.hidden = NO;
                self.tableView.hidden = YES;
                self.noResumeView.hidden = YES;
            }
            default:
            {
            }
                break;
        }
    }];
    [RACObserve(self.viewModel, cpStateCode) subscribeNext:^(id cpStateCode){
        @strongify(self);
        if(!cpStateCode)
        {
            return;
        }
        switch ([self requestStateWithStateCode:cpStateCode])
        {
            case HUDCodeSucess:
            {
                self.tableView.hidden = NO;
                [self.tableView reloadData];
                ResumeNameVC *vc = [[ResumeNameVC alloc]initWithResumeId:self.viewModel.cpresumeModel.ResumeId];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case HUDCodeNone:
            {
                [self.tableView reloadData];
            }
                break;
            case HUDCodeNetWork:
            {
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.networkButton.hidden = NO;
                self.clickImage.hidden = NO;
                self.tableView.hidden = YES;
            }
            default:
            {
            }
                break;
        }
    }];
    [RACObserve(self.viewModel,AddStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        { 
            ResumeNameVC *vc = [[ResumeNameVC alloc]initWithResumeId:self.viewModel.resumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [RACObserve(self.viewModel,toTopStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.tableView reloadData];
            // 发送设置默认简历的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:CP_DEFAULT_RESUME object:nil userInfo:@{ CP_DEFAULT_RESUME_CHANGE : [NSNumber numberWithInteger:HUDCodeSucess] }];
        }
    }];
    [RACObserve(self.viewModel,deleteStateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if(stateCode && [self requestStateWithStateCode:stateCode] == HUDCodeSucess)
        {
            [self.tableView reloadData];
        }
    }];
//    [self.viewModel getAllResume];
}
- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self.viewModel getAllResume];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPProfileMyResumesCell *cell = [CPProfileMyResumesCell resumeCellWithTableView:tableView];
    AllResumeDataModel *resumeModel = [AllResumeDataModel beanFromDictionary:self.viewModel.datas[indexPath.row]];
    [cell setResumeModel:resumeModel indexPath:indexPath];
    // 预览
    [cell.resumeReviewButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.viewModel.currentIndex = indexPath.row;
        AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:[self.viewModel.datas objectAtIndex:self.viewModel.currentIndex]];
//        ResumeType;//(1社招，2校招)
        if ( 2 == [model.ResumeType intValue] )
        {
            FullResumeVC *vc = [[FullResumeVC alloc] initWithResumeId:model.ResumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( 1 == [model.ResumeType intValue] )
        {
            CPSocialResumeReviewController *vc = [[CPSocialResumeReviewController alloc] initWithResumeId:model.ResumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        [MobClick event:@"show_full_resume"];
    }];
    // 设为默认
    [cell.resumeSetDefualtButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.viewModel.currentIndex = indexPath.row;
        if( self.currentMenuView == indexPath.row )
        {
            self.currentMenuView = -1;
        }
        else
        {
            self.currentMenuView = indexPath.row;
        }
       [self.viewModel toTop];
        [MobClick event:@"set_resume_top"];
        [[NSNotificationCenter defaultCenter] postNotificationName:CP_DEFAULT_RESUME object:nil userInfo:@{ CP_DEFAULT_RESUME_CHANGE : [NSNumber numberWithInt:HUDCodeSucess]}];
    }];
    // 复制
    [cell.resumeCopyButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.viewModel.currentIndex = indexPath.row;
        if( self.viewModel.datas.count == 10 )
        {
            [OMGToast showWithText:@"一个用户最多创建10份简历" bottomOffset:ShowTextBottomOffsetY duration:ShowTextTimeout];
            return;
        }
        if(self.currentMenuView==indexPath.row)
        {
            self.currentMenuView = -1;
        }
        else
        {
            self.currentMenuView = indexPath.row;
        }
        [self.viewModel copyResume];
        [MobClick event:@"btn_copy_resume"];
    }];
    // 删除
    [cell.resumeDeleteButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.viewModel.currentIndex = indexPath.row;
        if( self.currentMenuView == indexPath.row )
        {
            self.currentMenuView = -1;
        }
        else
        {
            self.currentMenuView = indexPath.row;
        }
        [self shomMessageTips:@"是否要删除简历"];
        [MobClick event:@"delete_resume"];
    }];
    // 编辑
    [cell.resumeEditButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.viewModel.currentIndex = indexPath.row;
        AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:[self.viewModel.datas objectAtIndex:indexPath.row]];
        NSInteger typeInt = [model.ResumeType intValue];
        if ( 1 == typeInt )
        {
            ResumeNameVC *vc = [[ResumeNameVC alloc] initWithResumeId:model.ResumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ( 2 == typeInt )
        {
            CPSchoolResumeEditController *vc = [[CPSchoolResumeEditController alloc] initWithResumeId:model.ResumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
        [MobClick event:@"resumelist_item_click"];
    }];
    // 查看我简历的
    [cell.resumeReviewLabel handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.viewModel.currentIndex = indexPath.row;
         AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:[self.viewModel.datas objectAtIndex:indexPath.row]];
        CPWatchResumeController *watchResumeVC = [[CPWatchResumeController alloc] init];
        [watchResumeVC configResumeId:model.ResumeId];
        [self.navigationController pushViewController:watchResumeVC animated:YES];
        [MobClick event:@"btn_see_number"];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 432.0 / CP_GLOBALSCALE;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)didResumeMenuTouch:(NSUInteger)index
{
    switch (index)
    {
        case 0:
        {
            AllResumeDataModel *model = [AllResumeDataModel beanFromDictionary:[self.viewModel.datas objectAtIndex:self.viewModel.currentIndex]];
            FullResumeVC *vc = [[FullResumeVC alloc]initWithResumeId:model.ResumeId];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            [self.viewModel toTop];
        }
            break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除简历" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.viewModel deleteResume];
        });
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x288add" alpha:1.0] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
     [self.viewModel getAllResume];
}
- (void)shomMessageTips:(NSString *)tips
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
}
- (void)tipsView:(CPTipsView *)tipsView clickEnsureButton:(UIButton *)enSureButton
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewModel deleteResume];
    });
    self.tipsView = nil;
}
- (CPTipsView *)messageTipsViewWithTips:(NSString *)tips
{
    if ( !_tipsView )
    {
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"取消", @"确定"] showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
- (CreateResumeDialogView *)createResumeDialog
{
    if ( !_createResumeDialog )
    {
        _createResumeDialog = [[CreateResumeDialogView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _createResumeDialog.delegate = self;
        [_createResumeDialog initView];
        [[UIApplication sharedApplication].keyWindow addSubview:_createResumeDialog];
    }
    return _createResumeDialog;
}
@end