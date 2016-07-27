//
//  DynamicFairVC.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicFairVC.h"
#import "DynamicFairVM.h"
//#import "TalkInCell.h"
#import "DynamicFairCell.h"
#import "DynamicFairModelDTO.h"

@interface DynamicFairVC ()

@property(nonatomic,retain)DynamicFairVM *viewModel;

@end

@implementation DynamicFairVC

-(instancetype)init
{
    if (self = [super init])
    {
        self.viewModel = [DynamicFairVM new];
        return self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"宣讲会";
    
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110;
    
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
                /*if (self.viewModel.datas.count < self.viewModel.page * self.viewModel.size) {
                 [self.tableView removeInfiniteAction];
                 }*/
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicFairCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DynamicFairCell class])];
    
    if(cell == nil)
    {
        cell = [[DynamicFairCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DynamicFairCell class])];
    }
    
    DynamicFairModelDTO *bean = [DynamicFairModelDTO beanFromDictionary:[self.viewModel.datas objectAtIndex:indexPath.row]];
    cell.lableTitle.text = bean.FairName;
    cell.lableTime.text = bean.CreateDate;
    cell.lableAddress.text = bean.Address;
    
    return cell;
 }



#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

}

@end
