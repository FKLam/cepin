//
//  DynamicSystemVC.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicSystemVC.h"
#import "DynamicSystemVM.h"
#import "DynamicSystemNewCell.h"
#import "DynamicSystemModelDTO.h"
#import "DynamicSystemDetailVC.h"
#import "TBViewController.h"

@interface DynamicSystemVC ()<UIWebViewDelegate>

@property(nonatomic,retain)DynamicSystemVM *viewModel;

@end

@implementation DynamicSystemVC

-(instancetype)init
{
    if (self = [super init])
    {
        self.viewModel = [DynamicSystemVM new];
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"系统消息";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
  
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if (!stateCode)
        {
            return ;
        }
        switch ([self requestStateWithStateCode:stateCode])
        {
            case HUDCodeDownloading:
                self.viewModel.isLoading = YES;
                [self startRefleshAnimation];
                break;
            case HUDCodeLoadMore:
                self.viewModel.isLoading = YES;
                [self startUpdateAnimation];
                break;
            case HUDCodeReflashSucess:
                [self stopRefleshAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                if (self.viewModel.datas.count >= self.viewModel.size)
                {
                    [self setupDropDownScrollView];
                }
                break;
            case hudCodeUpdateSucess:
                [self stopUpdateAnimation];
                [self.tableView reloadData];
                self.viewModel.isLoading = NO;
                break;
            default:
                [self stopRefleshAnimation];
                [self stopUpdateAnimation];
                self.viewModel.isLoading = NO;
                break;
        }
    }];
    
    [self setupRefleshScrollView];
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

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IS_IPHONE_5?55:65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicSystemNewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DynamicSystemNewCell class])];
    
    if(cell==nil)
    {
        cell=[[DynamicSystemNewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DynamicSystemNewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    DynamicSystemModelDTO *bean = [DynamicSystemModelDTO beanFromDictionary:[self.viewModel.datas objectAtIndex:indexPath.row]];
    cell.lableTime.text = bean.CreateDate;
    cell.lableTitle.text = bean.Title;
    cell.subLabel.text = bean.Content;
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    DynamicSystemModelDTO *bean = [DynamicSystemModelDTO beanFromDictionary:[self.viewModel.datas objectAtIndex:indexPath.row]];
    DynamicSystemDetailVC *vc = [[DynamicSystemDetailVC alloc]initWithBean:bean];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
