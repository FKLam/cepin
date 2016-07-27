//
//  FullEducationCellView.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullEducationCellView.h"
#import "FullViewCell.h"
#import "ResumeNameModel.h"
#import "TBTextUnit.h"
#import "NSString+Extension.h"

@implementation FullEducationCellView
- (instancetype)initWithFrame:(CGRect)frame model:(ResumeNameModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.EduModel = model;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.scrollsToTop = NO;
        
        CGFloat lineHeight = 0;
        CGFloat lineY = 40 / 3.0 - (21.0 - [[RTAPPUIHelper shareInstance] searchResultSubFont].pointSize) / 2.0 + 21.0 / 2.0;
        for (NSDictionary *dict in self.EduModel.EducationList)
        {
            if ( [dict isEqual:[self.EduModel.EducationList lastObject]] )
                break;
            EducationListDateModel *educationM = [EducationListDateModel beanFromDictionary:dict];
            
            lineHeight += [self caculateHeight:educationM];
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake( 40 / 3.0 + 21 / 2.0 - 1 / 2.0, lineY, 1, lineHeight)];
        line.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        [self addSubview:line];
        
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (CGFloat)caculateHeight:(EducationListDateModel *)educationModel
{
    CGFloat height = 0;
    CGFloat tempH = [[RTAPPUIHelper shareInstance] searchResultSubFont].pointSize * 3 + 5 * 3 + 40 / 3.0 * 2;
    
    NSMutableString *detailStrM = [NSMutableString string];
    
    if ( educationModel.ScoreRanking && educationModel.ScoreRanking.length > 0 )
    {
        if ( [educationModel.ScoreRanking intValue] == 0 )
        {
            [detailStrM appendFormat:@"成绩排名 : 其他"];
        }
        else
            [detailStrM appendFormat:@"成绩排名 : 年级前%@%@", educationModel.ScoreRanking, @"%"];
    }
    
    if ( educationModel.Description && educationModel.Description.length > 0 )
    {
        if ( detailStrM.length > 0 )
        {
            [detailStrM appendFormat:@"\n主修课程 : %@", educationModel.Description];
        }
        else
        {
            [detailStrM appendFormat:@"主修课程 : %@", educationModel.Description];
        }
    }
    
    if ( detailStrM.length > 0 )
    {
        height += tempH + [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] searchResultSubFont] text:detailStrM andWith:kScreenWidth - 40 - 40 / 3.0].height + 5.0;
    }
    else
        height += tempH;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationListDateModel *model = [EducationListDateModel beanFromDictionary:self.EduModel.EducationList[indexPath.row]];
    return [self caculateHeight:model];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.EduModel.EducationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FullViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FullViewCell class])];
    if (cell == nil) {
        cell = [[FullViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FullViewCell class])];
    }
    EducationListDateModel *model = [EducationListDateModel beanFromDictionary:self.EduModel.EducationList[indexPath.row]];
    [cell getModel:model];
    
    if ( indexPath.row == self.EduModel.EducationList.count - 1 )
        cell.separatorView.hidden = YES;
    else
        cell.separatorView.hidden = NO;
    
    
    return cell;
}


@end
