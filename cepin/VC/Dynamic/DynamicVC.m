//
//  DynamicVC.m
//  cepin
//
//  Created by ricky.tang on 14-10-21.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicVC.h"
#import "UIViewController+NavicationUI.h"
#import "SubscriptionVC.h"
#import "DynamicVM.h"
#import "NSDate-Utilities.h"
#import "RACSignal+Error.h"
#import "AutoLoginVM.h"

#import "DynamicJobVC.h"
#import "DynamicSystemVC.h"
#import "DynamicExamVC.h"
#import "DynamicFairVC.h"

#import "DynamicCompanyTalkVC.h"

#import "DynamicNewCell.h"
#import "RCIM.h"
#import "RTChatViewController.h"
#import "RTChatViewModeDTO.h"
#import "NSDate-Utilities.h"

#import "DynamicBannerCell.h"
#import "DynamicWebVC.h"

#import "JobSearchVC.h"

#import "NewJobDetialVC.h"
@interface DynamicVC ()<DynamicCellDelegate>

@property(nonatomic,strong)DynamicVM *viewModel;
@property(nonatomic,strong)NSIndexPath *currentIndexPath;
@end

@implementation DynamicVC
-(instancetype)init
{
    if (self = [super init]) {
        self.viewModel = [DynamicVM new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, (self.view.viewHeight - ((IsIOS7)?108:66))) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.rowHeight = 84;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    [RACObserve(self.viewModel, stateCode) subscribeNext:^(id stateCode) {
        @strongify(self);
        NSInteger code = [self requestStateWithStateCode:stateCode];
        if (code == HUDCodeSucess)
        {
            [self.tableView reloadData];
        }
    }];
    
    [self.viewModel getBanner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self.parentViewController addNavicationObjectWithType:NavcationBarObjectTypeBooking] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender){
        
        SubscriptionVC *vc = [SubscriptionVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    self.parentViewController.navigationItem.titleView = nil;
    
    self.tableView.scrollsToTop = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tableView.scrollsToTop = NO;
}


#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.viewModel.bannerImage)
    {
        return self.viewModel.datas.count + 1;
    }
    return self.viewModel.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.bannerImage && indexPath.row == 0)
    {
        static  NSString *cellIndentify = @"DynamicBannerCell";
        DynamicBannerCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentify];
        if(cell==nil)
        {
            cell=[[DynamicBannerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
        }
        cell.bannerImage.image = self.viewModel.bannerImage;
        return cell;
    }
    
    int index = (int)indexPath.row;
    if (self.viewModel.bannerImage)
    {
        index--;
    }
    
    static  NSString *cellIndentify = @"DynamicNewCell";
    DynamicNewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if(cell==nil)
    {
        cell=[[DynamicNewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    DynamicNewModel *model = self.viewModel.datas[index];
    
    [cell configureWithModel:model];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell resetCell];
    
    
    return cell;
}

-(void)PushCellToTop:(DynamicNewCell *)cell
{
    self.currentIndexPath = nil;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath.row == 0)
    {
        return;
    }
    
    int index = (int)indexPath.row;
    if (self.viewModel.bannerImage)
    {
        index--;
        if (index == 0)
        {
            return;
        }
    }
    DynamicNewModel *model = self.viewModel.datas[index];
    if (model.type.intValue == DynamicModelChatType || model.type.intValue == DynamicModelCompanyChatType)
    {
        [model toTop];
        [self.viewModel toTop];
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)PushCellDelete:(DynamicNewCell *)cell
{
    self.currentIndexPath = nil;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    int index = (int)indexPath.row;
    if (self.viewModel.bannerImage)
    {
        index--;
    }
    DynamicNewModel *model = self.viewModel.datas[index];
    if (model.type.intValue == DynamicModelChatType || model.type.intValue == DynamicModelCompanyChatType)
    {
        [model deleteRecord];
        [self.viewModel.datas removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void)GestureGo:(DynamicNewCell *)cell isReset:(BOOL)isReset
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (isReset)
    {
        if (self.currentIndexPath)
        {
            DynamicNewCell *cell = (DynamicNewCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
            [cell resetCell];
        }
        self.currentIndexPath = indexPath;
    }
    else
    {
        self.currentIndexPath = nil;
    }
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.viewModel.bannerImage)
    {
        DynamicWebVC *vc = [[DynamicWebVC alloc]initWithTitleAndlUrl:self.viewModel.bannerModel.Title url:self.viewModel.bannerModel.LinkUrl];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    int index = (int)indexPath.row;
    if (self.viewModel.bannerImage)
    {
        index--;
    }
    
    //这些界面都要传入一个viewmodel的数组，以及当前的model 和index 这样内页改变属性之后返回这个界面就可以重绘制了
    DynamicNewModel *model = self.viewModel.datas[index];
    if (model.UnReadCount.intValue >= 0)
    {
        model.UnReadCount = @(0);
        [self.viewModel.datas replaceObjectAtIndex:index withObject:model];
        [model update];

        //DynamicNewCell *cell = (DynamicNewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        DynamicNewCell *cell = (DynamicNewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.labelNumber.hidden = YES;
    }
    
    switch (model.type.intValue)
    {
        case DynamicModelJobType:
        {
            DynamicJobVC *vc = [DynamicJobVC new];
            [self.navigationController pushViewController:vc animated:YES];
       
        }
            break;
        case DynamicModelFairType:
        {
            //跳转到宣讲会列表
            DynamicFairVC *vc = [DynamicFairVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case DynamicModelFairSystemType:
        {
            //跳转系统消息
            DynamicSystemVC *vc = [DynamicSystemVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case DynamicModelExamType:
        {
            //跳转到测评中心
            DynamicExamVC *vc = [DynamicExamVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case DynamicModelCompanyChatType:
        {
            //跳转到聊天界面
            DynamicCompanyTalkVC *vc = [[DynamicCompanyTalkVC alloc]initWithModel:model];
            vc.title = model.name;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case DynamicModelChatType:
        {
            RTChatGetSendModeDTO *bean = [RTChatGetSendModeDTO new];
            bean.tokenId = [[MemoryCacheData shareInstance]userTokenId];
            bean.userId = [[MemoryCacheData shareInstance]userId];
            bean.TargetUserId = model.ToUserId;
            bean.SendUserId = [[MemoryCacheData shareInstance]userId];
            
            RTChatViewController *chatViewController = [[RTChatViewController alloc]initWithTypeAndBean:ChatGetType save:nil get:bean];
            chatViewController.enableSettings = NO;
            chatViewController.enableVoIP = NO;
            chatViewController.conversationType = ConversationType_PRIVATE;
            chatViewController.currentTargetName = model.name;
            chatViewController.currentTarget = model.ToUserId;
            
            [[RCIM sharedRCIM]launchPrivateChat:chatViewController targetUserId:model.ToUserId title:model.name completion:^{
                [self.navigationController pushViewController:chatViewController animated:YES];
            }];
        }
            break;
        default:
            break;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.currentIndexPath)
    {
        DynamicNewCell *cell = (DynamicNewCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell resetCell];
        self.currentIndexPath = nil;
    }
}


@end
