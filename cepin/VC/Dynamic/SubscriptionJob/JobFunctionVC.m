//
//  JobFunctionVC.m
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobFunctionVC.h"
#import "JobFunctionVM.h"

#import "TBTextUnit.h"
#import "ComChooseCell.h"
#import "JobFunctionHeaderView.h"
#import "JobFunctionSecondVC.h"
#import "AOTag.h"
#import "UIViewController+NavicationUI.h"
@interface JobFunctionVC ()<AOTagDelegate,JobFunctionHeaderViewDelegate>
@property(nonatomic,strong)JobFunctionVM *viewModel;
@property(nonatomic,strong) AOTagList *tagListView;
@property(nonatomic,strong)NSMutableArray *tagArray;
@property(nonatomic,strong)UIView *selectedFunctionView;
@property(nonatomic,strong)UIView *shadowView;
@property(nonatomic,assign)int selectedCount;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,assign)NSInteger currentSection;
@property(nonatomic,strong)NSMutableArray *headView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UIImageView *clickImage;
@end

@implementation JobFunctionVC
- (instancetype)initWithJobModel:(SubscriptionJobModel *)model
{
    if (self = [super init]) {
        
        self.viewModel = [[JobFunctionVM alloc]initWithJobModel:model];
        self.model = model;
        self.tagArray = [NSMutableArray new];
    }
    return self;
}

-(void)clickedBackBtn:(id)sender
{
    if ([self.viewModel.functions isEqualToString:@""] || !self.viewModel.functions) {
        self.model.jobFunctionskey = @"";
        self.model.jobFunctions = @"";
    }else{
        self.model.jobFunctions = self.viewModel.functions;
        self.model.jobFunctionskey = self.viewModel.functionKeys;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职能类型";
    
    self.view.backgroundColor = [[RTAPPUIHelper shareInstance] shadeColor];
    
    self.navigationItem.leftBarButtonItem = [RTAPPUIHelper backBarButtonWith:self selector:@selector(clickedBackBtn:)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    [button setBackgroundColor:[UIColor redColor]];
    
    [self createSelectedFunctionView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, self.view.viewWidth, (self.view.viewHeight) - CGRectGetMaxY(self.selectedFunctionView.frame)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    
    self.tableView.backgroundColor = [[RTAPPUIHelper shareInstance] shadeColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 44;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49.0, 0);
    
    self.dataArray = [NSMutableArray new];
    for (int i = 0; i < self.viewModel.datas.count; i++) {
        BaseCode *item = self.viewModel.datas[i];
        [self.dataArray addObject:item.CodeName];
    }
    [self loadModel];
    
    [RACObserve(self.viewModel, isShrink) subscribeNext:^(id isShrink) {
        if (!self.viewModel.isShrink) {
            self.selectedFunctionView.frame = CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, 50);
            self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight + (IS_IPHONE_5?18:21), self.view.viewWidth, (self.view.viewHeight) - self.selectedFunctionView.viewHeight -((IsIOS7)?64:44));
            self.tagListView.hidden = YES;
             self.clickImage.image = [UIImage imageNamed:@"ic_down"];
            [self.tableView reloadData];
        }else
        {
            self.selectedFunctionView.frame = CGRectMake(0, (IsIOS7)?44+20:44, self.view.viewWidth, 130);
            self.tableView.frame = CGRectMake(0, self.selectedFunctionView.viewY + self.selectedFunctionView.viewHeight + (IS_IPHONE_5?18:21), self.view.viewWidth, (self.view.viewHeight) - self.selectedFunctionView.viewHeight -((IsIOS7)?64:44));
            self.tagListView.hidden = NO;
             self.clickImage.image = [UIImage imageNamed:@"ic_up"];
            [self.tableView reloadData];
        }
    }];
}
- (void)loadModel
{
    self.headView = [NSMutableArray new];
    for (int i = 0; i < self.dataArray.count; i ++ ) {
        JobFunctionHeaderView *headView = [[JobFunctionHeaderView alloc]init];
        headView.delegate = self;
        headView.section = i;
        headView.jobName.text = [NSString stringWithFormat:@"%@",self.dataArray[i]];
        [self.headView addObject:headView];
    }
}
#pragma mark - HeadViewdelegate
-(void)selectedWith:(JobFunctionHeaderView *)view
{
    //    self.currentRow = -1;
    if (view.open) {
        for(int i = 0;i<[self.headView count];i++)
        {
            JobFunctionHeaderView *head = [self.headView objectAtIndex:i];
            head.open = NO;
        }
        [self.tableView reloadData];
        return;
    }
    self.currentSection = view.section;
    [self reset];
    
}

//界面重置
- (void)reset
{
    for(int i = 0;i<[self.headView count];i++)
    {
        JobFunctionHeaderView *head = [self.headView objectAtIndex:i];
        
        if(head.section == self.currentSection)
        {
            head.open = YES;
        }else {
            head.open = NO;
        }
        
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSelectedFunctionView
{
    self.selectedFunctionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth,130)];
    self.selectedFunctionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectedFunctionView];
    
    UIImageView *seleImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, imagehight, imagehight)];
    seleImage.image = [UIImage imageNamed:@"ic_selected"];
    [self.selectedFunctionView addSubview:seleImage];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(seleImage.viewX + seleImage.viewWidth, 12, 100, IS_IPHONE_5?12:14)];
    self.countLabel.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
    self.countLabel.font = [[RTAPPUIHelper shareInstance] titleFont];
    [self.selectedFunctionView addSubview:self.countLabel];
    
    self.tagListView = [[AOTagList alloc] init];
    [self.tagListView setDelegate:self];
    [self.selectedFunctionView addSubview:self.tagListView];
    [self.tagListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedFunctionView.mas_left).offset(10);
        make.right.equalTo(self.selectedFunctionView.mas_right).offset(-10);
        make.top.equalTo(self.countLabel.mas_bottom).offset(10);
        make.height.equalTo(@(80));
    }];
    
    UIButton *click = [UIButton buttonWithType:UIButtonTypeCustom];
    click.frame = CGRectMake(kScreenWidth - 50, seleImage.viewY, 70, 30);
    click.backgroundColor = [UIColor clearColor];
    [self.selectedFunctionView addSubview:click];
    [click handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.viewModel.isShrink = !self.viewModel.isShrink;
    }];
    self.clickImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.viewWidth - (imagehight) - 20, click.viewY, imagehight, imagehight)];
    self.clickImage.image = [UIImage imageNamed:@"ic_down"];
    [self.selectedFunctionView addSubview:self.clickImage];
    
//    self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, self.selectedFunctionView.viewHeight + self.selectedFunctionView.viewY, self.view.viewWidth, IS_IPHONE_5?18:21)];
//    self.shadowView.backgroundColor = [[RTAPPUIHelper shareInstance] shadeColor];
//    [self.view addSubview:self.shadowView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
   self.model.jobFunctions = [TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctions];
    self.model.jobFunctionskey = [TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctionsKey];
    
    
    self.countLabel.text = [NSString stringWithFormat:@"已选%lu/3",(unsigned long)self.viewModel.jobFunctions.count];
    
    [self.tagListView removeAllTag];
    for (NSInteger i = 0; i < self.viewModel.jobFunctions.count; i++)
    {
        [self.tagListView addTag:[self.viewModel.jobFunctions objectAtIndex:i] withImage:nil withLabelColor:[UIColor whiteColor]  withBackgroundColor:[[RTAPPUIHelper shareInstance] labelColorGreen] withCloseButtonColor:[UIColor whiteColor]];
    }
    
}

- (void)tagDidRemoveTag:(AOTag *)tag
{
    [self.viewModel.jobFunctions removeObject:tag.tTitle];
    self.model.jobFunctions = [TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctions];
    self.countLabel.text = [NSString stringWithFormat:@"已选%lu/3",(unsigned long)self.viewModel.jobFunctions.count];
    
    NSMutableArray *array = [BaseCode baseCodeWithCodeKeys:[TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctionsKey]];
    BaseCode *temp = nil;
    for (BaseCode *item in array) {
        if ([item.CodeName isEqualToString:tag.tTitle]) {
            temp = item;
            break;
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",temp.CodeKey];
    [self.viewModel.jobFunctionsKey removeObject:str];
     self.model.jobFunctionskey = [TBTextUnit baseCodeNameWithArray:self.viewModel.jobFunctionsKey];
}
#pragma mark UITableViewDataScource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobFunctionHeaderView* headView = [self.headView objectAtIndex:indexPath.section];
    
    if (headView.open) {
        return IS_IPHONE_5?40:48;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.headView objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JobFunctionHeaderView* headView = [self.headView objectAtIndex:section];
    BaseCode *code = self.viewModel.datas[section];
    NSArray * array = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
    return headView.open?array.count:0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headView count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ComChooseCell class])];
    
    if(cell == nil)
    {
        cell = [[ComChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ComChooseCell class])];
    }
    
    BaseCode *code = self.viewModel.datas[indexPath.section];
    NSMutableArray *array = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
    BaseCode *secondCode = array[indexPath.row];
    
    [cell configureLableTitleText:secondCode.CodeName];
    
    cell.chooseType = ComChooseNextType;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseCode *code = self.viewModel.datas[indexPath.section ];
    
    NSMutableArray *temp = [BaseCode secondLevelJobFunctionWithPathCode:code.PathCode];
    BaseCode *secondCode = temp[indexPath.row];
    NSMutableArray *thirdTemp = [BaseCode thirdLevelJobFunctionWithPathCode:secondCode.PathCode];
    
    
    JobFunctionSecondVC *vc = [[JobFunctionSecondVC alloc] initWithData:thirdTemp seletedData:self.viewModel.jobFunctions jobFunctionsKey:self.viewModel.jobFunctionsKey];
    vc.title = secondCode.CodeName;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
