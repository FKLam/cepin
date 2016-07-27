//
//  DynamicCompanyTalkVC.m
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicCompanyTalkVC.h"
#import "DynamicCompanyTalkVM.h"
#import "DynamicCompanyTalkCell.h"
#import "DynamicCompanyChatModel.h"

@interface DynamicCompanyTalkVC ()

@property(nonatomic,retain)NSMutableArray *datas;

@end

@implementation DynamicCompanyTalkVC

-(instancetype)initWithModel:(DynamicNewModel*)model
{
    if (self = [super init])
    {
        self.datas = [[NSMutableArray alloc]init];
        NSMutableArray *array = [DynamicCompanyChatModel SearchWithDynamicNewModel:model];
        [self.datas addObjectsFromArray:array];
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCompanyChatModel *model = [self.datas objectAtIndex:indexPath.row];
    return [DynamicCompanyTalkCell computerTalkCellHeight:model.message];
    //return [DynamicCompanyTalkCell computerTalkCellHeight:[self.testArray objectAtIndex:indexPath.row]];
    //return 132;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
    //return self.testArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellIndentify = @"DynamicCompanyTalkCell";
    DynamicCompanyTalkCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    
    if(cell==nil)
    {
        cell=[[DynamicCompanyTalkCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }

    [cell configureWithModel:[self.datas objectAtIndex:indexPath.row]];
    
    //cell.lableContent.text = [self.testArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
