//
//  SaveJobVC.m
//  cepin
//  收藏职位
//  Created by ricky.tang on 14-10-30.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "SaveJobVC.h"
#import "JobDetailVC.h"
#import "SaveJobVM.h"
#import "SaveJobDTO.h"
#import "NewJobDetialVC.h"
#import "SaveJobCell.h"
#import "CPRecommendModelFrame.h"
@interface SaveJobVC ()

@property(nonatomic,strong)SaveJobVM *viewModel;
@property(nonatomic,assign)BOOL isSelect;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subLabel;
@end

@implementation SaveJobVC

-(void)memoryRelease
{
    [self.viewModel momeryRelease];
    self.viewModel = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.viewModel = [SaveJobVM new];
        self.isSelect = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收藏职位";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - (IsIOS7?108:88)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
    self.titleLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"抱歉！你还没有收藏职位";
    self.titleLabel.hidden = YES;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(40));
        make.width.equalTo(@(250));
    }];
    
    self.subLabel = [[UILabel alloc]init];
    self.subLabel.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
    self.subLabel.font = [[RTAPPUIHelper shareInstance] mainTitleFont];
    self.subLabel.text = @"马上查看意向工作并果断收藏吧！";
    self.subLabel.hidden = YES;
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subLabel];
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(40));
        make.width.equalTo(@(300));
    }];
    
    
     @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        switch ([self requestStateWithStateCode:stateCode])
        {
            case HUDCodeDownloading:
                self.viewModel.isLoading = YES;
                [self startRefleshAnimation];
                self.titleLabel.hidden = YES;
                self.subLabel.hidden = YES;
                self.networkImage.hidden = YES;
                break;
            case HUDCodeLoadMore:
                self.viewModel.isLoading = YES;
                [self startUpdateAnimation];
                break;
            case HUDCodeReflashSucess:
                [self.viewModel.selectJobs removeAllObjects];
                [self stopRefleshAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                self.tableView.hidden = NO;
                self.titleLabel.hidden = YES;
                self.subLabel.hidden = YES;
                self.networkImage.hidden = YES;
                break;
            case hudCodeUpdateSucess:
                [self stopUpdateAnimation];
                [self.tableView reloadData];
                self.tableView.hidden = NO;
                self.viewModel.isLoading = NO;
                break;
            case HUDCodeNone:
            {
                self.titleLabel.hidden = NO;
                self.subLabel.hidden = NO;
                self.networkImage.hidden = NO;
                self.tableView.hidden = YES;
            }
                break;
            case HUDCodeNetWork:
            {
                self.networkImage.hidden = NO;
                self.networkLabel.hidden = NO;
                self.networkButton.hidden = NO;
                self.clickImage.hidden = NO;
                self.titleLabel.hidden = YES;
                self.subLabel.hidden = YES;
                self.tableView.hidden = YES;
            }
                break;
            default:
                [self stopRefleshAnimation];
                [self stopUpdateAnimation];
                self.viewModel.isLoading = NO;
                [self.tableView reloadData];
                self.titleLabel.hidden = NO;
                self.subLabel.hidden = NO;
                self.networkImage.hidden = NO;
                break;
        }
    }];
    
    [self setupRefleshScrollView];
    [self setupDropDownScrollView];
    [self refleshTable];
}

- (void)clickNetWorkButton
{
    self.networkImage.hidden = YES;
    self.networkLabel.hidden = YES;
    self.networkButton.hidden = YES;
    self.clickImage.hidden = YES;
    [self refleshTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refleshTable];
    [self.tableView reloadData];

    if (self.viewModel.datas.count>0) {
        
    }else{
        self.titleLabel.hidden = NO;
        self.subLabel.hidden = NO;
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPHONE_5?63:75;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaveJobCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SaveJobCell class])];
    if (cell == nil) {
        cell = [[SaveJobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SaveJobCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setChoice:[self.viewModel selectedWithIndex:indexPath.row]];
    
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
    
    SaveJobDTO *bean;
    
    if( [recommendModelFrame.recommendModel isKindOfClass:[SaveJobDTO class]] )
        bean = (SaveJobDTO *)recommendModelFrame.recommendModel;
    
    [cell configWithSaveBean:bean];
    cell.isChoice = NO;
    [cell.buttonDelete handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
         CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
        cell.isChoice = !cell.isChoice;
        [cell setChoice:cell.isChoice];
        if (cell.isChoice) {
            [self.viewModel.selectJobs addObject:recommendModelFrame];
        }else
        {
            [self.viewModel.selectJobs removeObject:recommendModelFrame];
        }
        
        if ([self.delegate respondsToSelector:@selector(getJobSelect:)]) {
            [self.delegate getJobSelect:self.viewModel.selectJobs];
        }
        
    }];
    
    if ( indexPath.row == [self.viewModel.datas count] - 1 )
        cell.lineView.hidden = YES;
    else
        cell.lineView.hidden = NO;
  
    return cell;
}


#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row];
    
    SaveJobDTO *bean;
    
    if( [recommendModelFrame.recommendModel isKindOfClass:[SaveJobDTO class]] )
        bean = (SaveJobDTO *)recommendModelFrame.recommendModel;
    
    NewJobDetialVC *vc = [[NewJobDetialVC alloc]initWithJobId:bean.PositionId companyId:bean.CustomerId pstType:bean.PositionType];
    
    vc.title = bean.PositionName;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
