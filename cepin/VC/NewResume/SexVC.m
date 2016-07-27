//
//  SexVC.m
//  cepin
//
//  Created by dujincai on 15/6/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SexVC.h"
#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface SexVC ()
@property(nonatomic,strong)NSArray *titleArray;
@end

@implementation SexVC

- (instancetype)initWithModel:(ResumeNameModel*)model
{
    self = [super init];
    if (self) {
        self.model = model;
        self.titleArray = @[@"男",@"女"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"性别";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPHONE_5?40:48;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    NSString *gender = [NSString stringWithFormat:@"%@",self.model.Gender];
    NSString *index = [NSString stringWithFormat:@"%d",(int)(indexPath.row + 1)];
    
    if ([gender isEqualToString:index]) {
        cell.isSelect = YES;
    }else
    {
        cell.isSelect = NO;
    }
    
    
//    if (self.model.Gender == [NSNumber numberWithInteger:indexPath.row + 1]) {
//        cell.chooseImage.hidden = NO;
//    }else
//    {
//        cell.chooseImage.hidden = YES;
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model.Gender = [NSNumber numberWithInteger:indexPath.row + 1];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
