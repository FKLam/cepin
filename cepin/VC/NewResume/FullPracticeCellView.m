//
//  FullPracticeCellView.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullPracticeCellView.h"
#import "PracticeCell.h"
#import "MajorCell.h"
#import "ExperienceCell.h"
#import "StudentLeadersCell.h"
#import "HonourListCell.h"
#import "NSString+Extension.h"
#import "NSDate-Utilities.h"

@implementation FullPracticeCellView
- (instancetype)initWithFrame:(CGRect)frame model:(ResumeNameModel *)model;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.praModel = model;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.scrollsToTop = NO;
        [self addSubview:self.tableView];
        
        CGFloat lineHeight = 0;
        
        CGFloat lineY = 40 / 3.0 - (21.0 - [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize) / 2.0 + 21.0 / 2.0;
        
        CGFloat tempPracticeH = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize * 3 + 5 * 3 + 40 / 3.0 * 2;
        // 社会实践
        for ( NSDictionary *dict in self.praModel.PracticeList )
        {
            if ( [dict isEqualToDictionary:[self.praModel.PracticeList lastObject] ])
            {
                if ( self.praModel.AwardsList.count == 0 && self.praModel.StudentLeadersList.count == 0 )
                    break;
                    
            }
            
            CGFloat maxMarge = kScreenWidth - 40 - 40 / 3.0;
            
            CGSize practiceSize = CGSizeZero;
            
            PracticalListDataModel *practice = [PracticalListDataModel beanFromDictionary:dict];
            
            if ( practice.Content && practice.Content.length > 0 )
            {
                practiceSize = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:practice.Content andWith:maxMarge];
                lineHeight += practiceSize.height + 5.0;
            }
            
            lineHeight += tempPracticeH;
        }
        
        // 获奖情况
        for ( NSDictionary *dict in self.praModel.AwardsList )
        {
            if ( [dict isEqualToDictionary:[self.praModel.AwardsList lastObject]] )
            {
                if ( self.praModel.StudentLeadersList.count == 0 )
                    break;
            }
            AwardsListDataModel *award = [AwardsListDataModel beanFromDictionary:dict];
            NSString *star = [self manageStrTime:award.StartDate];
            NSString *time = [NSString stringWithFormat:@"%@",star];
            NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
            NSString *app = @"  |  获奖情况";
            NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
            [timeAttStr appendAttributedString:appAttStr];
            NSMutableString *strM = [[NSMutableString alloc] initWithString:[timeAttStr string]];
            NSString *nameStr = [NSString stringWithFormat:@"%@  |  %@", award.Name, award.Level];
            if ( nameStr && nameStr.length > 0 )
                [strM appendFormat:@"\n%@", nameStr];
            
            if ( strM && strM.length > 0 )
            {
                CGFloat awardTempHeight = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:strM andWith:kScreenWidth - 40 - 40 / 3.0].height;
                
                lineHeight += awardTempHeight + 5 * 2 + 40 / 3.0 * 2;
            }
        }
        
        // 学生干部
        for ( NSDictionary *dict in self.praModel.StudentLeadersList )
        {
            if ( [dict isEqualToDictionary:[self.praModel.StudentLeadersList lastObject]])
            {
                break;
            }
            
            StudentLeadersDataModel *StuModel = [StudentLeadersDataModel beanFromDictionary:dict];
            NSString *star = [self manageStrTime:StuModel.StartDate];
            NSString *end = [self manageStrTime:StuModel.EndDate];
            
            NSString *time = [NSString stringWithFormat:@"%@ - %@", star, end];
            NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
            NSString *app = @"  |  学生干部";
            NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
            [timeAttStr appendAttributedString:appAttStr];
            
            NSMutableString *strM = [[NSMutableString alloc] initWithString:[timeAttStr string]];
            NSString *nameStr = [NSString stringWithFormat:@"%@  |  %@", StuModel.Name, StuModel.Level];
            if ( nameStr && nameStr.length > 0 )
                [strM appendFormat:@"\n%@", nameStr];
            
            if ( strM && strM.length > 0 )
            {
                CGFloat studentTempHeight = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:strM andWith:kScreenWidth - 40 - 40 / 3.0].height;
                
                lineHeight += studentTempHeight + 5 * 2 + 40 / 3.0 * 2;
            }
        }
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(40.0 / 3.0 + 21 / 2.0 - 1 / 2.0, lineY, 1, lineHeight + 5.0)];
        line.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        [self insertSubview:line belowSubview:self.tableView];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 社会实践
    if ( indexPath.row < self.praModel.PracticeList.count )
    {
        PracticeListDataModel *model = [PracticeListDataModel beanFromDictionary:self.praModel.PracticeList[indexPath.row]];
        return [self caculatePracticeHeight:model];
    }
    
    NSInteger index = (NSInteger)indexPath.row;
    
    // 获奖情况
    if (self.praModel.PracticeList.count > 0) {
        index = indexPath.row - self.praModel.PracticeList.count;
    }
    
    if ( self.praModel.AwardsList.count > 0 && self.praModel.AwardsList.count > index )
    {
        AwardsListDataModel *awardModel = [AwardsListDataModel beanFromDictionary:self.praModel.AwardsList[index]];
        return [self caculateAwardHeight:awardModel];
    }
    
    NSInteger indexSec = index;
    // 学生干部
    if (self.praModel.AwardsList.count > 0) {
        indexSec = index - self.praModel.AwardsList.count;
    }
    
    if (self.praModel.StudentLeadersList.count > 0 && indexSec < self.praModel.StudentLeadersList.count)
    {
        StudentLeadersDataModel *studentModel = [StudentLeadersDataModel beanFromDictionary:self.praModel.StudentLeadersList[indexSec]];
        return [self cacultateStudentHeight:studentModel];
    }
    
    return 0.0;
}

- (CGFloat)cacultateStudentHeight:(StudentLeadersDataModel *)studentModel
{
    if ( !studentModel )
        return 0;
    
    StudentLeadersDataModel *StuModel = studentModel;
    NSString *star = [self manageStrTime:StuModel.StartDate];
    NSString *end = [self manageStrTime:StuModel.EndDate];
    
    NSString *time = [NSString stringWithFormat:@"%@ - %@", star, end];
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  学生干部";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    NSMutableString *strM = [[NSMutableString alloc] initWithString:[timeAttStr string]];
    NSString *nameStr = [NSString stringWithFormat:@"%@  |  %@", StuModel.Name, StuModel.Level];
    if ( nameStr && nameStr.length > 0 )
        [strM appendFormat:@"\n%@", nameStr];
    
    CGFloat awardHeight = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:strM andWith:kScreenWidth - 40 - 40 / 3.0].height;
    
    return awardHeight + 5 * 2 + 40 / 3.0 * 2;
}

- (CGFloat)caculateAwardHeight:(AwardsListDataModel *)awardModel
{
    if ( !awardModel )
        return 0;
    
    AwardsListDataModel *honModel = awardModel;
    NSString *star = [self manageStrTime:honModel.StartDate];
    NSString *time = [NSString stringWithFormat:@"%@",star];
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  获奖情况";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    NSMutableString *strM = [[NSMutableString alloc] initWithString:[timeAttStr string]];
    NSString *nameStr = [NSString stringWithFormat:@"%@  |  %@", honModel.Name, honModel.Level];
    if ( nameStr && nameStr.length > 0 )
        [strM appendFormat:@"\n%@", nameStr];
    
    CGFloat awardHeight = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:strM andWith:kScreenWidth - 40 - 40 / 3.0].height;
    
    return awardHeight + 5 * 2 + 40 / 3.0 * 2;
}

- (NSString *)manageStrTime:(NSString *)time
{
    if (!time || [time isEqualToString:@""]) {
        return @"至今";
    }else{
        //    NSArray *array = [time componentsSeparatedByString:@" "];
        return [NSDate cepinYMDFromString:time];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.praModel.StudentLeadersList.count + self.praModel.AwardsList.count + self.praModel.PracticeList.count;
}

- (CGFloat)caculatePracticeHeight:(PracticeListDataModel *)practice
{
    CGFloat height = 0;
    CGFloat tempH = [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize * 3 + 5 * 3 + 40 / 3.0 * 2;
    CGFloat maxMarge = kScreenWidth - 40 - 40 / 3.0;
    
    CGSize practiceSize = CGSizeZero;
    
    if ( practice.Content && practice.Content.length > 0 )
    {
        practiceSize = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:practice.Content andWith:maxMarge];
        height += practiceSize.height + 5.0;
    }
    
    height += tempH;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger counts = self.praModel.StudentLeadersList.count + self.praModel.AwardsList.count + self.praModel.PracticeList.count;
    
    // 社会实践
    if (self.praModel.PracticeList.count > 0 && indexPath.row < self.praModel.PracticeList.count) {
        PracticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PracticeCell class])];
        if (cell == nil) {
            cell = [[PracticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PracticeCell class])];
        }
        PracticeListDataModel *model = [PracticeListDataModel beanFromDictionary:self.praModel.PracticeList[indexPath.row]];
        [cell getModel:model];
        
        if ( indexPath.row == counts - 1 )
            cell.baseSeparatorView.hidden = YES;
        else
            cell.baseSeparatorView.hidden = NO;
        
        return cell;
    }
    
    NSInteger index = (NSInteger)indexPath.row;
    
    // 获奖情况
    if (self.praModel.PracticeList.count > 0) {
        index = indexPath.row - self.praModel.PracticeList.count;
    }
    if (self.praModel.AwardsList.count > 0 && index < self.praModel.AwardsList.count) {
        HonourListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HonourListCell class])];
        if (cell == nil) {
            cell = [[HonourListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HonourListCell class])];
        }
        AwardsListDataModel *model = [AwardsListDataModel beanFromDictionary:self.praModel.AwardsList[index]];
        [cell getModel:model];
        
        if ( indexPath.row == counts - 1 )
            cell.baseSeparatorView.hidden = YES;
        else
            cell.baseSeparatorView.hidden = NO;
        
        return cell;
    }
    
    NSInteger indexSec = index;
    
    // 学生干部
    if (self.praModel.AwardsList.count > 0) {
        indexSec = index - self.praModel.AwardsList.count;
    }
    
    if (self.praModel.StudentLeadersList.count > 0 && indexSec < self.praModel.StudentLeadersList.count) {
        StudentLeadersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StudentLeadersCell class])];
        if (cell == nil) {
            cell = [[StudentLeadersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([StudentLeadersCell class])];
        }
        StudentLeadersDataModel *model = [StudentLeadersDataModel beanFromDictionary:self.praModel.StudentLeadersList[indexSec]];
        [cell getModel:model];
        
        if ( indexPath.row == counts - 1 )
            cell.baseSeparatorView.hidden = YES;
        else
            cell.baseSeparatorView.hidden = NO;
        
        return cell;
    }
    
    return nil;
}

@end
