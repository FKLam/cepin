//
//  WorkYearsVC.m
//  cepin
//
//  Created by dujincai on 15/6/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "WorkYearsVC.h"
#import "ResumeChooseCell.h"
#import "BaseCodeDTO.h"
#import "CPCommon.h"
@interface WorkYearsVC ()
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,assign)Boolean isSocial;//是否社招
@end
@implementation WorkYearsVC
- (instancetype)initWithModel:(ResumeNameModel *)model isSocial:(Boolean)isSocial
{
    self = [super init];
    if (self) {
        self.isSocial = isSocial;
        if(!isSocial){
           NSMutableArray *data =  [BaseCode workYears];
            self.datas =[[NSMutableArray alloc]initWithCapacity:2];
            if(nil != data && data.count>0){
                [self.datas addObject:data[0]];
                [self.datas addObject:data[1]];
            }
        }
        else
        {
            self.datas = [BaseCode workYears];
        }
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isSocial)
    {
        self.title = @"工作年限";
    }
    else
    {
        self.title = @"就读状态";
    }
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    BaseCode *item = self.datas[indexPath.row];
    cell.titleLabel.text = item.CodeName;
    if ( self.model.WorkYearKey.intValue == item.CodeKey.intValue )
    {
        cell.chooseImage.hidden = NO;
    }
    else
        cell.chooseImage.hidden = YES;
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.datas count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *item = self.datas[indexPath.row];
    self.model.WorkYear = item.CodeName;
    self.model.WorkYearKey = [NSString stringWithFormat:@"%@", item.CodeKey];
    [self.navigationController popViewControllerAnimated:YES];
}
@end