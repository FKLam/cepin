//
//  JobpropertyVC.m
//  cepin
//
//  Created by dujincai on 15/6/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobpropertyVC.h"
#import "RTSelectedCell.h"
@interface JobpropertyVC ()
@property(nonatomic,strong)NSArray *titles;
@end

@implementation JobpropertyVC
- (instancetype)initWithJobModel:(SubscriptionJobModel *)model
{
    self = [super init];
    if (self) {
//        self.viewModel = [JobSalaryVM new];
        self.model = model;
        self.titles = @[@"不限",@"全职",@"实习"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职位类型";
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
    
    //    BaseCode *item = self.viewModel.datas[indexPath.row];
    
    cell.labelTitle.text = self.titles[indexPath.row];
    cell.labelSub.hidden = YES;
    
    if (indexPath.row == 0 && ([self.model.jobPropertys isEqualToString:@""] || !self.model.jobPropertys)) {
        cell.isSelected = YES;
    }else
    
    if (indexPath.row != 0 && [self.model.jobPropertys isEqualToString:self.titles[indexPath.row]]) {
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
        self.model.jobPropertys = @"";
        self.model.jobPropertyskey = @"";
    }else {
        self.model.jobPropertys = self.titles[indexPath.row];
        if (indexPath.row == 1) {
            self.model.jobPropertyskey = @"1";
        }else{
            self.model.jobPropertyskey = @"4";
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
