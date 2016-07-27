//
//  ResumeEditDegreeVC.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeEditDegreeVC.h"
#import "BaseCodeDTO.h"
#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface ResumeEditDegreeVC ()
@property(nonatomic,strong)NSMutableArray *degreeData;
@property(nonatomic,assign)Boolean isXuew;
@end

@implementation ResumeEditDegreeVC

- (instancetype)initWithEduModel:(EducationListDateModel *)model isXueWei:(Boolean)isXueWei
{
    self = [super init];
    if (self) {
        self.isXuew = isXueWei;
        self.degreeData = [NSMutableArray new];
        if( self.isXuew ){
            NSArray *data = @[@"学士", @"双学士", @"硕士", @"MBA", @"博士", @"其他", @"无"];
            self.degreeData = [NSMutableArray arrayWithArray:data];
        }
        else
        {
            self.degreeData = [BaseCode degrees];
            NSMutableArray *arrayM = [NSMutableArray array];
            NSUInteger count = [self.degreeData count];
            for ( NSInteger index = count - 1; index >= 0; index-- )
            {
                BaseCode *obj = self.degreeData[index];
                [arrayM addObject:obj];
            }
            self.degreeData = [arrayM copy];
        }
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isXuew) {
        self.title = @"学位";
    }else{
        self.title = @"学历";
    }
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self.tableView setContentInset:UIEdgeInsetsMake( 30 / CP_GLOBALSCALE, 0, 0, 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.degreeData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if ( cell == nil )
    {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    if( self.isXuew )
    {
        cell.titleLabel.text = self.degreeData[indexPath.row];
        if ([self.model.XueWei isEqualToString:self.degreeData[indexPath.row]]) {
            cell.chooseImage.hidden = NO;
        }
    }
    else
    {
        BaseCode *item = self.degreeData[indexPath.row];
        cell.titleLabel.text = item.CodeName;
        if ([self.model.Degree isEqualToString:item.CodeName])
        {
            cell.chooseImage.hidden = NO;
        }
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.degreeData count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isXuew)
    {
        self.model.XueWei = self.degreeData[indexPath.row];
    }
    else
    {
        BaseCode *item = self.degreeData[indexPath.row];
        self.model.Degree = item.CodeName;
        self.model.DegreeKey = [NSString stringWithFormat:@"%@",item.CodeKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end