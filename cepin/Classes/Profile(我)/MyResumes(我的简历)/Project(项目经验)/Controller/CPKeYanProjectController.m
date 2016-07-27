//
//  CPKeYanProjectController.m
//  cepin
//
//  Created by ceping on 16/3/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPKeYanProjectController.h"
#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface CPKeYanProjectController ()
@property (nonatomic, strong) ProjectListDataModel *model;
@property (nonatomic, strong) NSMutableArray *projectClassArrayM;
@end

@implementation CPKeYanProjectController
- (instancetype)initWithProjectModel:(ProjectListDataModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"科研项目";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projectClassArrayM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    NSString *item = self.projectClassArrayM[indexPath.row];
    cell.titleLabel.text = item;
    if ( [item isEqualToString:@"否"] )
        item = @"0";
    else
        item = @"1";
    if ( [self.model.IsKeyuan intValue] == [item intValue] ) {
        cell.chooseImage.hidden = NO;
    }
    else
    {
        cell.chooseImage.hidden = YES;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.projectClassArrayM count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *item = self.projectClassArrayM[indexPath.row];
    if ( [item isEqualToString:@"否"] )
        self.model.IsKeyuan = @"0";
    else
        self.model.IsKeyuan = @"1";
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)projectClassArrayM
{
    if ( !_projectClassArrayM )
    {
        _projectClassArrayM = [NSMutableArray array];
        [_projectClassArrayM addObject:@"是"];
        [_projectClassArrayM addObject:@"否"];
        
    }
    return _projectClassArrayM;
}
@end
