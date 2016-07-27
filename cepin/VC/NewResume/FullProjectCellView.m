//
//  FullProjectCellView.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullProjectCellView.h"
#import "ProjectCell.h"
#import "NSString+Extension.h"

@implementation FullProjectCellView

- (instancetype)initWithFrame:(CGRect)frame model:(ResumeNameModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.projectModel = model;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.scrollsToTop = NO;
        
        int a = 0;
        
        CGFloat fixdHeiht = [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont].pointSize * 3 + 40 / 3.0 * 2 + 5 * 3.0;
        
        CGFloat maxMarge = kScreenWidth - 40 - 40 / 3.0;
        CGFloat lineY = 40 / 3.0 - (21.0 - [[RTAPPUIHelper shareInstance] searchResultSubFont].pointSize) / 2.0 + 21.0 / 2.0;
        
        for (int i = 0; i < self.projectModel.ProjectList.count - 1; i++) {
            
            ProjectDataModel *model = [ProjectDataModel beanFormDic:self.projectModel.ProjectList[i]];
            if (model.Content && ![model.Content isEqualToString:@""]) {
                NSString *str = model.Content?model.Content:@"";
                
                if ( str.length == 0 )
                {
                    a += fixdHeiht;
                    continue;
                }
                
                int height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultTipsHeadFont] text:str andWith:maxMarge].height + 5.0;
                a += height + fixdHeiht;
            }
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake( 40 / 3.0 + 21 / 2.0 - 1 / 2.0, lineY, 1, a)];
        line.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        [self insertSubview:line belowSubview:self.tableView];
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListDataModel *model = [ProjectListDataModel beanFromDictionary:self.projectModel.ProjectList[indexPath.row]];
    
    CGFloat fixdHeiht = [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont].pointSize * 3 + 40 / 3.0 * 2 + 5 * 3.0;
    
    if (model.Content && ![model.Content isEqualToString:@""]) {
        
        NSString *str = model.Content?model.Content:@"";
        CGFloat maxMarge = kScreenWidth - 40 - 40 / 3.0;
        if ( str.length != 0 )
        {
            int height = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultTipsHeadFont] text:str andWith:maxMarge].height + 5.0;
            fixdHeiht += height;
        }
    }
    return fixdHeiht;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projectModel.ProjectList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProjectCell class])];
    if (cell == nil) {
        cell = [[ProjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ProjectCell class])];
    }
    ProjectListDataModel *model = [ProjectListDataModel beanFromDictionary:self.projectModel.ProjectList[indexPath.row]];
    [cell getModel:model];
    
    if ( indexPath.row == self.projectModel.ProjectList.count - 1 )
    {
        cell.separatorView.hidden = YES;
    }
    else
    {
        cell.separatorView.hidden = NO;
    }
    
    return cell;
}

@end
