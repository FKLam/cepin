//
//  FullJobCellView.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullJobCellView.h"
#import "FullResumeDataModel.h"
#import "ExperienceCell.h"
#import "NSString+Extension.h"

@implementation FullJobCellView

- (instancetype)initWithFrame:(CGRect)frame model:(ResumeNameModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.JobModel = model;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.scrollsToTop = NO;
        
        CGFloat lineHeight = 0;
        CGFloat lineY = 40 / 3.0 - (21.0 - [[RTAPPUIHelper shareInstance] jobInformationDetaillFont].pointSize) / 2.0 + 21.0 / 2.0;
        
        for ( NSDictionary *dict in self.JobModel.WorkList )
        {
            if ([dict isEqual:[self.JobModel.WorkList lastObject]])
                break;
            
            WorkListDateModel *model = [WorkListDateModel beanFromDictionary:dict];
            lineHeight += [self caculateWith:model];
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake( 40 / 3.0 + 21 / 2.0 - 1 / 2.0, lineY, 1, lineHeight)];
        
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self addSubview:line];
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkListDateModel *work = [WorkListDateModel beanFromDictionary:self.JobModel.WorkList[indexPath.row]];
    
    return [self caculateWith:work];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.JobModel.WorkList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ExperienceCell class])];
    if (cell == nil) {
        cell = [[ExperienceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ExperienceCell class])];
    }
    WorkListDateModel *model = [WorkListDateModel beanFromDictionary:self.JobModel.WorkList[indexPath.row]];
    [cell getModel:model];
    
    if ( indexPath.row == self.JobModel.WorkList.count - 1 )
        cell.separatorView.hidden = YES;
    else
        cell.separatorView.hidden = NO;
    
    return cell;
}

/** 返回一个数据模型的高度 */
- (CGFloat)caculateWith:(WorkListDateModel *)work
{
    NSInteger totalH = 0;
    CGFloat tempH = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont].pointSize * 3 + 5 * 3 + 40 / 3.0 * 2;
    CGFloat maxMarge = kScreenWidth - 40  - 40 / 3.0;
    
    NSMutableString *proveStr = [NSMutableString string];
    if(work.AttestorName)
    {
        [proveStr appendFormat:@"证明人：%@", work.AttestorName];
    }
    
    if(work.AttestorRelation)
    {
        [proveStr appendFormat:@"／%@", work.AttestorRelation];
    }
    
    if(work.AttestorPosition)
    {
        [proveStr appendFormat:@"／%@", work.AttestorPosition];
    }
    
    if(work.AttestorPhone)
    {
        [proveStr appendFormat:@"／%@", work.AttestorPhone];
    }
    
    if(work.AttestorCompany)
    {
        [proveStr appendFormat:@"\n证明人单位：%@", work.AttestorCompany];
    }
    
    if ( proveStr.length > 0 )
        totalH += tempH + [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] jobInformationDetaillFont] text:proveStr andWith:maxMarge].height + 5.0;
    else
        totalH += tempH;
    
    return totalH;
}

@end
