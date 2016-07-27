//
//  JobSalaryVC.m
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobSalaryVC.h"
#import "RTSelectedCell.h"
#import "JobSalaryVM.h"
#import "BaseCodeDTO.h"
#import "ComChooseCell.h"
@interface JobSalaryVC ()
@property(nonatomic,strong)JobSalaryVM *viewModel;
@end

@implementation JobSalaryVC
- (instancetype)initWithJobModel:(SubscriptionJobModel *)model
{
    self = [super init];
    if (self) {
        self.viewModel = [JobSalaryVM new];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"期望薪酬";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.rowHeight = 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTSelectedCell *cell = [RTSelectedCell cellForTableView:tableView fromNib:[RTSelectedCell nib] andOwner:self];
    
    if (indexPath.row == 0) {
        cell.labelTitle.text = @"不限";
    }else{
        cell.labelTitle.text = self.viewModel.datas[indexPath.row -1];
    }
   cell.labelSub.hidden = YES;
    
    if (indexPath.row == 0&&([self.model.salary isEqualToString:@""] || !self.model.salary)) {
        cell.isSelected = YES;
    }else if (indexPath.row != 0 &&[self.model.salary isEqualToString:self.viewModel.datas[indexPath.row - 1]]) {
        cell.isSelected = YES;
    }else
    {
        cell.isSelected = NO;
    }
    
    cell.buttonSelected.userInteractionEnabled = NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTSelectedCell *c = (RTSelectedCell *)[tableView cellForRowAtIndexPath:indexPath];
  
    //将现在的选中
    c.isSelected = YES;
    if (indexPath.row == 0) {
        self.model.salary = @"";
        self.model.salarykey = @"";
    }else
    {
        self.model.salary = self.viewModel.datas[indexPath.row - 1];
        self.model.salarykey = self.viewModel.datas[indexPath.row - 1];
    }

    [self.navigationController popViewControllerAnimated:YES];
}
@end
