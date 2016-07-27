//
//  JobWorkYearsVC.m
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobWorkYearsVC.h"
#import "RTSelectedCell.h"
#import "BaseCodeDTO.h"
@interface JobWorkYearsVC ()
@property(nonatomic,strong)NSMutableArray *titles;
@end

@implementation JobWorkYearsVC
- (instancetype)initWithJobModel:(SubscriptionJobModel *)model
{
    self = [super init];
    if (self) {
        //        self.viewModel = [JobSalaryVM new];
        self.model = model;
        self.titles = [BaseCode workYears];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作年限";
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
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTSelectedCell *cell = [RTSelectedCell cellForTableView:tableView fromNib:[RTSelectedCell nib] andOwner:self];
    
    
     BaseCode *item = nil;
    if (indexPath.row == 0) {
        cell.labelTitle.text = @"不限";
    }else{
         item = self.titles[indexPath.row - 1];
        cell.labelTitle.text = item.CodeName;
       
    }
    cell.labelSub.hidden = YES;
    
    if (indexPath.row == 0 && ([self.model.workYear isEqualToString:@""] || !self.model.workYear)) {
        cell.isSelected = YES;
    }else if (indexPath.row != 0 && [self.model.workYear isEqualToString:item.CodeName]) {
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
        self.model.workYear = @"";
        self.model.workYearkey = @"";
    }else
    {
         BaseCode *item = self.titles[indexPath.row - 1];
        self.model.workYear = item.CodeName;
        self.model.workYearkey = [NSString stringWithFormat:@"%@",item.CodeKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
