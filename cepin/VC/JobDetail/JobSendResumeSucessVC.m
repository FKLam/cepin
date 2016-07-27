//
//  JobSendResumeSucessVC.m
//  cepin
//
//  Created by dujincai on 15/6/8.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobSendResumeSucessVC.h"
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

@interface JobSendResumeSucessVC ()
@property(nonatomic,strong) UIImageView  *sucessImage;
@property(nonatomic,strong) UILabel *sucessLabel;
@property(nonatomic,strong) UILabel *examLabel1;
@property(nonatomic,strong) UILabel *examLabel2;
@property(nonatomic,strong) UIButton *examButton;
@property(nonatomic,strong) JobSendResumeSucessVM * viewModel;
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation JobSendResumeSucessVC

- (instancetype)initWithPositionId:(NSString*)positionId
{
    self = [super init];
    if (self) {
        self.viewModel = [[JobSendResumeSucessVM alloc]initWithPositionId:positionId];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.viewModel allPositionId];
    [self.viewModel isOpenSpeedExam];

//    [self.tableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    //修改跳转逻辑 不进入编辑页面
    NSUInteger count = self.navigationController.viewControllers.count;
    UIViewController *vc = self.navigationController.viewControllers[count-2];
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if ([vc isKindOfClass:[ResumeNameVC class]]) {
            [array removeObject:vc];
    }
    self.navigationController.viewControllers  = [array copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.viewWidth, self.view.viewHeight)];
    [self.view addSubview:_scrollView];
    self.title = @"投递成功";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.sucessImage = [[UIImageView alloc]init];
    self.sucessImage.image = [UIImage imageNamed:@"ic_success"];
    [self.scrollView addSubview:self.sucessImage];
    self.sucessImage.hidden = YES;
    
    self.sucessLabel = [[UILabel alloc] init];
    self.sucessLabel.text = @"恭喜你,投递成功";
    self.sucessLabel.font = [[RTAPPUIHelper shareInstance] jobInformationDeliverButtonFont];
    self.sucessLabel.textAlignment = NSTextAlignmentCenter;
    self.sucessLabel.textColor = RGBCOLOR(246, 74, 47);
    self.sucessLabel.hidden = YES;
    [self.scrollView addSubview:self.sucessLabel];
    
    self.examLabel1 = [[UILabel alloc]init];
    self.examLabel1.text = @"只差一步,";
    self.examLabel1.font = [[RTAPPUIHelper shareInstance]titleFont];
    self.examLabel1.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.examLabel1.hidden = YES;
    self.examLabel1.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.examLabel1];
    
    self.examLabel2 = [[UILabel alloc]init];
    self.examLabel2.text = @"5分钟极速测评，面试成功率提高3.5倍";
    self.examLabel2.font = [[RTAPPUIHelper shareInstance]titleFont];
    self.examLabel2.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    self.examLabel2.textAlignment = NSTextAlignmentCenter;
    self.examLabel2.hidden = YES;
    [self.scrollView addSubview:self.examLabel2];
    
    self.examButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.examButton.backgroundColor = RGBCOLOR(241, 139, 74);
    self.examButton.layer.cornerRadius = 8;
    self.examButton.layer.masksToBounds = YES;
    self.examButton.hidden = YES;
    [self.examButton setTitle:@"马上测评" forState:UIControlStateNormal];
    self.examButton.titleLabel.font = [[RTAPPUIHelper shareInstance]bigTitleFont];
    [self.scrollView addSubview:self.examButton];
    
    
    [self.examButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.viewModel getExamList];
//        DynamicExamVC *vc = [[DynamicExamVC alloc]initWithType:examOne];
//        [self.navigationController pushViewController:vc animated:YES];
        
        [MobClick event:@"send_succeed_cepin"];
    }];
    
    [self.sucessImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    [self.sucessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.sucessImage.mas_bottom).offset(20);
        make.width.equalTo(@(150));
        make.height.equalTo(@(50));
    }];
    
    [self.examLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.sucessLabel.mas_bottom).offset(10);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
    [self.examLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.examLabel1.mas_bottom).offset(10);
        make.width.equalTo(@(300));
        make.height.equalTo(@(30));
    }];
    
    [self.examButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.examLabel2.mas_bottom).offset(30);
        make.width.equalTo(@(280));
        make.height.equalTo(@(50));
    }];
    
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    self.tableView.rowHeight = 77.0f;
    
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] backgroundColor];
    [self.scrollView addSubview:self.tableView];
    self.tableView.scrollEnabled = YES;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.sucessLabel.mas_bottom).offset(10);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
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
                self.tableView.hidden = YES;
            }
        }else
        {
            self.tableView.hidden = YES;
        }
        [self.tableView reloadData];
        
    }];
    
    [RACObserve(self.viewModel, isExamStateCode)subscribeNext:^(id isExamStateCode) {
        if ([self requestStateWithStateCode:isExamStateCode] == HUDCodeSucess) {
            
            
            if (self.viewModel.isExam) {
                self.examLabel1.hidden = YES;
                self.examLabel2.hidden = YES;
                self.examButton.hidden = YES;
                self.sucessLabel.hidden = NO;
                self.sucessImage.hidden = NO;
                [self reloadData];
                self.tableView.hidden = NO;
            }else
            {
                self.sucessLabel.hidden = NO;
                self.sucessImage.hidden = NO;
                self.examLabel1.hidden = NO;
                self.examLabel2.hidden = NO;
                self.examButton.hidden = NO;
                self.tableView.hidden = YES;
            }
        }
    }];
    
    [self.viewModel isOpenSpeedExam];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return IS_IPHONE_5?26:30;
    }
//    return IS_IPHONE_5?63:75;
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row - 1];
    
    return recommendModelFrame.totalFrame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count + 1;
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
    if (indexPath.row == 0) {
        JobSearchTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JobSearchTitleCell class])];
        if (cell == nil) {
            cell = [[JobSearchTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JobSearchTitleCell class])];
        }
        cell.lableTitle.text = @"你还可以看看其他的职位";
        return cell;
    }
    else{
        CPRecommendCell *cell = [CPRecommendCell recommendCellWithTableView:tableView];
        
        [self drawCell:cell withIndexPath:indexPath offSet:1];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row < 1)
        return;
    
    CPRecommendModelFrame *recommendModelFrame = self.viewModel.datas[indexPath.row-1];
    
    JobSearchModel *model;
    
    if( [recommendModelFrame.recommendModel isKindOfClass:[JobSearchModel class]] )
        model = (JobSearchModel *)recommendModelFrame.recommendModel;
    
    NewJobDetialVC *vc = [[NewJobDetialVC alloc]initWithJobId:model.PositionId companyId:model.CustomerId pstType:model.PositionType];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
