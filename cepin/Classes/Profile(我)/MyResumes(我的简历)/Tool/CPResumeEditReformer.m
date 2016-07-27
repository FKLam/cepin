//
//  CPResumeEditReformer.m
//  cepin
//
//  Created by ceping on 16/1/22.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEditReformer.h"
#import "BaseCodeDTO.h"
#import "TBTextUnit.h"
#import "CPCommon.h"
CPResumeEditBlockType _resumeEditBlockType = CPResumeEditDefaultBlock;
@implementation CPResumeEditReformer
+ (CPResumeEditBlockType)resumeEditBlock
{
    return _resumeEditBlockType;
}
+ (void)saveResumeEditBlock:(CPResumeEditBlockType)resumeEditBlock
{
    _resumeEditBlockType = resumeEditBlock;
}
+ (CGFloat)informationHeight:(ResumeNameModel *)resumeModel
{
    // ResumeType;//（1：普通简历,2：应届生）简历类型(社招=1，校招=2)
    CGFloat height = 0;
    CGFloat fixldHeight = ( 40 + 120 + 2 + 60 + 36 * 9 + 50 * 8 + 60 + 6 ) / CP_GLOBALSCALE;
    NSInteger resumeTypeInt = [resumeModel.ResumeType intValue];
    if ( 2 == resumeTypeInt )
        height = fixldHeight;
    else if ( 1 == resumeTypeInt )
    {
        NSString *introducesStr = resumeModel.Introduces;
        height = fixldHeight + [self oneWordHeight:introducesStr];
    }
    return height;
}
+ (CGFloat)oneWordHeight:(NSString *)Introduces
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 3 - 255 / CP_GLOBALSCALE - 20 / CP_GLOBALSCALE;
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = 36 / CP_GLOBALSCALE;
    if (  Introduces && 0 < [Introduces length] )
    {
        NSString *temStr = Introduces;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if ( temStrSize.height > ( 36 / CP_GLOBALSCALE ) * 2 )
            totalHeight += temStrSize.height + 50 / CP_GLOBALSCALE;
        else
            totalHeight += 36 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
    }
    else
    {
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)expectWorkHeight:(ResumeNameModel *)resumeModel
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4;
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    CGFloat addButtonHeight = 144.0 / CP_GLOBALSCALE;
    if ( !resumeModel.ExpectCity || 0 == [resumeModel.ExpectCity length])
    {
        totalHeight += fixldHeight + addButtonHeight;
    }
    else
    {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
        NSMutableArray *array = [Region searchAddressWithAddressPathCodeString:resumeModel.ExpectCity];
        NSString *type = nil;
        if ([resumeModel.ExpectEmployType isEqualToString:@"1"]) {
            type = @"全职";
        }else if([resumeModel.ExpectEmployType isEqualToString:@"4"])
        {
            type = @"实习";
        }else
        {
            type = @"";
        }
        NSString *separatorLine = @"  |  ";
        NSMutableArray *arrarCode = [BaseCode baseCodeWithCodeKeys:resumeModel.ExpectJobFunction];
        for (BaseCode *i in arrarCode) {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.CodeName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        for (Region *i in array) {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.RegionName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        if ( 0 < [resumeModel.ExpectSalary length] )
        {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:resumeModel.ExpectSalary attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        if ( 0 < [type length] )
        {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        if( resumeModel.ResumeType.intValue == 2 )
        {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
            NSString *availabelStr = nil;
            if( resumeModel.AvailableType && resumeModel.AvailableType.length > 0 )
            {
                availabelStr = [NSString stringWithFormat:@"%@到岗", resumeModel.AvailableType];
            }
            else
            {
                availabelStr = [NSString stringWithFormat:@"%@到岗时间", @"不限"];
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:availabelStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
            // 1不服从，0服从
            NSString *allowStr = nil;
            if ( resumeModel.IsAllowDistribution && resumeModel.IsAllowDistribution > 0 )
            {
                allowStr = resumeModel.IsAllowDistribution.intValue ? @"，服从分配" : @"，不服从分配";
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:allowStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:18 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
        [attStr addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]} range:NSMakeRange(0, [attStr length])];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        if ( temStrSize.height > ( 36 / CP_GLOBALSCALE * 2 ) )
            totalHeight += temStrSize.height;
        else
            totalHeight += ( 36 + 18 ) / CP_GLOBALSCALE;
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)educationTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    CGFloat blockHeight = ( 36 + 40 + 36 + 40 + 36 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
    CGFloat addButtonHeight = 144.0 / CP_GLOBALSCALE;
    NSMutableArray<EducationListDateModel> *educationList = resumeModel.EducationList;
    for (EducationListDateModel *education in educationList)
    {
        if ( education )
        {
            totalHeight += blockHeight;
            if ( ![[education valueForKey:@"ScoreRanking"] isKindOfClass:[NSNull class]] )
            {
                totalHeight += ( 36 + 20 ) / CP_GLOBALSCALE;
            }
        }
    }
    if ( 0 == totalHeight )
    {
        totalHeight += fixldHeight + addButtonHeight;
    }
    else
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)workExperienceTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    CGFloat blockHeight = ( 36 + 40 + 36 + 20 + 70 ) / CP_GLOBALSCALE;
    CGFloat addButtonHeight = 144.0 / CP_GLOBALSCALE;
    NSNumber *resumeType = resumeModel.ResumeType;
    NSMutableArray<WorkListDateModel> *workList = resumeModel.WorkList;
    for ( WorkListDateModel *work in workList )
    {
        if ( ![[work valueForKey:@"Content"] isKindOfClass:[NSNull class]] && 1 == [resumeType intValue] )
        {
            CGFloat tempH = [self workDescribeHeight:work];
            totalHeight += tempH + blockHeight + 40 / CP_GLOBALSCALE + [self workPositionHeight:work resumeType:resumeType];
        }
        else
        {
            totalHeight += blockHeight + [self workPositionHeight:work resumeType:resumeType];
        }
    }
    if ( 0 == totalHeight )
    {
        totalHeight += fixldHeight + addButtonHeight;
    }
    else
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)workPositionHeight:(WorkListDateModel *)work resumeType:(NSNumber *)resumeType
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 3 - 48 / CP_GLOBALSCALE - 45 / CP_GLOBALSCALE - 30 / CP_GLOBALSCALE;
    CGFloat totalHeight = 0;
    NSMutableString *positonStr = [NSMutableString stringWithFormat:@"%@  |  %@", [work valueForKey:@"JobFunction"], [work valueForKey:@"Industry"]];
    NSString *natureString = [work valueForKey:@"Nature"];
    if ( 2 == [resumeType intValue] )
    {
        [positonStr appendFormat:@"  |  %@", natureString];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:positonStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
    CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    if ( temStrSize.height > 36 / CP_GLOBALSCALE * 2  )
        totalHeight += temStrSize.height;
    else
        totalHeight += temStrSize.height - 10 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)workDescribeHeight:(WorkListDateModel *)work
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 3 - 48 / CP_GLOBALSCALE - 45 / CP_GLOBALSCALE - 30 / CP_GLOBALSCALE;
    CGFloat maxH = ( 36  + 20  ) / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    NSString *placeholderString = @"项目描述 : ";
    NSMutableParagraphStyle *placeholderParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [placeholderParagraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    NSMutableAttributedString *placeholderAttString = [[NSMutableAttributedString alloc] initWithString:placeholderString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : placeholderParagraphStyle}];
    CGSize placeholderSize = [placeholderAttString boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    if (  ![[work valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
    {
        NSString *preStr = @"项目描述 : ";
        NSString *temStr = [NSString stringWithFormat:@"%@%@", preStr, [work valueForKey:@"Content"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if ( temStrSize.height > placeholderSize.height  )
            totalHeight += placeholderSize.height + 36 / CP_GLOBALSCALE + 10 / CP_GLOBALSCALE;
        else
            totalHeight += placeholderSize.height - 20 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)practiceTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    CGFloat addButtonHeight = 144.0 / CP_GLOBALSCALE;
    NSMutableArray<PracticeListDataModel> *practiceList = resumeModel.PracticeList;
    NSMutableArray<AwardsListDataModel> *awardList = resumeModel.AwardsList;
    NSMutableArray<StudentLeadersDataModel> *leaderList = resumeModel.StudentLeadersList;
    for ( PracticeListDataModel *practice in practiceList )
    {
        totalHeight += [self practiceDescribeHeight:practice] + (36 + 40 + 36 + 20 + 36 ) / CP_GLOBALSCALE + 60 / 3.0 + 40 / CP_GLOBALSCALE;
    }
    for ( NSInteger index = 0; index < [awardList count]; index++ )
    {
        totalHeight += ( 36 + 40 + 36 + 60 ) / CP_GLOBALSCALE;
    }
    for ( NSInteger index = 0; index < [leaderList count]; index++ )
    {
        totalHeight += ( 36 + 40 + 36 + 60 ) / CP_GLOBALSCALE;
    }
    if ( 0 == totalHeight )
    {
        totalHeight += fixldHeight + addButtonHeight;
    }
    else
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)practiceDescribeHeight:(PracticeListDataModel *)practice
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
    CGFloat maxH = ( 36  + 20  ) / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    if (  ![[practice valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
    {
        NSString *temStr = [NSString stringWithFormat:@"实践描述 : %@", [practice valueForKey:@"Content"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += maxH * 2;
        else
            totalHeight += maxH;
    }
    return totalHeight;
}
+ (CGFloat)trainTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    CGFloat addButtonHeight = 144.0 / CP_GLOBALSCALE;
    NSMutableArray<TrainingDataModel> *trainList = resumeModel.TrainingList;
    for ( TrainingDataModel *train in trainList )
    {
        totalHeight += [self trainDescribeHeight:train] + (36 + 40 + 36 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    }
    if ( 0 == totalHeight )
    {
        totalHeight += fixldHeight + addButtonHeight;
    }
    else
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)trainDescribeHeight:(TrainingDataModel *)train
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
    CGFloat maxH = ( 36  + 20  ) / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    if (  ![[train valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
    {
        NSString *temStr = [train valueForKey:@"Content"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += maxH * 2;
        else
            totalHeight += maxH;
    }
    return totalHeight;
}
+ (CGFloat)projectExperienceTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    CGFloat blockHeight = ( 36 + 40 + 36 + 40 + + 40 + 60 ) / CP_GLOBALSCALE;
    CGFloat addButtonHeight = 144.0 / CP_GLOBALSCALE;
    NSMutableArray<ProjectListDataModel> *projectList = resumeModel.ProjectList;
    for ( ProjectListDataModel *project in projectList )
    {
        if ( ![[project valueForKey:@"Duty"] isKindOfClass:[NSNull class]] )
        {
            CGFloat tempH = [self majorDescribeHeight:project];
            totalHeight += tempH;
        }
        
        if ( ![[project valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
        {
            CGFloat tempH = [self projectDescribeHeight:project];
            totalHeight += tempH + blockHeight;
        }
        else
        {
            totalHeight += blockHeight;
        }
    }
    if ( 0 == totalHeight )
    {
        totalHeight += fixldHeight + addButtonHeight;
    }
    else
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)projectDescribeHeight:(ProjectListDataModel *)work
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
    CGFloat maxH = ( 36  + 20  ) / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    if (  ![[work valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
    {
        NSString *preStr = @"项目描述 : ";
        NSString *temStr = [NSString stringWithFormat:@"%@%@", preStr, [work valueForKey:@"Content"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += maxH * 2;
        else
            totalHeight += maxH;
    }
    return totalHeight;
}
+ (CGFloat)majorDescribeHeight:(ProjectListDataModel *)work
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
//    CGFloat maxH = ( 36  + 20  ) / 3.0;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    if (  ![[work valueForKey:@"Duty"] isKindOfClass:[NSNull class]] )
    {
        NSString *temStr = [work valueForKey:@"Duty"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += temStrSize.height;
        else
            totalHeight += temStrSize.height - 20 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)selfDescribeTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    CGFloat maxH = ( 36  + 20  ) / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    CGFloat addButtonHeight = 144.0 / CP_GLOBALSCALE;
    if ( resumeModel.UserRemark && 0 < [resumeModel.UserRemark length] )
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:resumeModel.UserRemark attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += maxH * 2;
        else
            totalHeight += maxH;
    }
    if ( 0 == totalHeight )
    {
        totalHeight += fixldHeight + addButtonHeight;
    }
    else
    {
        if ( totalHeight == maxH )
            totalHeight += fixldHeight + 60 / 3.0 + 40 / CP_GLOBALSCALE;
        else
            totalHeight += fixldHeight + 60 / 3.0 + 60 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (NSDictionary *)CETKeyValueDict:(ResumeNameModel *)resumeModel
{
    if ( !resumeModel )
        return nil;
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    
    if ( resumeModel.IsHasCET4Score.intValue == 1 && resumeModel.CET4Score)
    {
        [tempDict setObject:resumeModel.CET4Score forKey:@"CET4"];
    }
    
    if ( resumeModel.IsHasCET6Score.intValue == 1 && resumeModel.TEM8Score)
    {
        [tempDict setObject:resumeModel.CET6Score forKey:@"CET6"];
    }
    
    if ( resumeModel.IsHasTEM4Score.intValue == 1 && resumeModel.TEM8Score)
    {
        [tempDict setObject:resumeModel.TEM4Score forKey:@"TEM4"];
    }
    
    if ( resumeModel.IsHasTEM8Score.intValue == 1 && resumeModel.TEM8Score)
    {
        [tempDict setObject:resumeModel.TEM8Score forKey:@"TEM8"];
    }
    
    if ( resumeModel.IsHasIELTSScore.intValue == 1 && resumeModel.IELTSScore)
    {
        [tempDict setObject:resumeModel.IELTSScore forKey:@"雅思"];
    }
    
    if ( resumeModel.IsHasTOEFLScore.intValue == 1  && resumeModel.TOEFLScore)
    {
        [tempDict setObject:resumeModel.TOEFLScore forKey:@"托福"];
    }
    return [tempDict copy];
}
+ (CGFloat)aboutSkillHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    CGFloat addButtonHeight = 144.0 / CP_GLOBALSCALE;
    NSMutableArray<CredentialListDataModel> *credentialList = resumeModel.CredentialList;
    for ( CredentialListDataModel *credential in credentialList )
    {
        totalHeight += [self credentialHeight:credential];
    }
    NSMutableArray<SkillDataModel> *skillList = resumeModel.SkillList;
    for ( SkillDataModel *skill in skillList )
    {
        totalHeight += [self skillHeight:skill];
    }
    for( NSNumber *number in [self CETKeyValueDict:resumeModel] )
    {
        if ( number )
            totalHeight += [self CETKeyValueHeigt];
    }
    NSMutableArray<LanguageDataModel> *langageList = resumeModel.LanguageList;
    for ( LanguageDataModel *langage in langageList )
    {
        totalHeight += [self langageHeight:langage];
    }
    if ( 0 == totalHeight )
    {
        totalHeight += fixldHeight + addButtonHeight;
    }
    else
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)credentialHeight:(CredentialListDataModel *)credential
{
    CGFloat totalHeight = (36 * 2 + 20 * 2 + 60) / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)skillHeight:(SkillDataModel *)skill
{
    CGFloat totalHeight = (36 + 60) / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)langageHeight:(LanguageDataModel *)langage
{
    CGFloat totalHeight = (36 + 60) / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)CETKeyValueHeigt
{
    CGFloat CETKeyValueHeight = (36 + 60) / CP_GLOBALSCALE;
    return CETKeyValueHeight;
}
+ (CGFloat)resumeEditAdditionInfoHeight:(NSString *)additionInfo
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4;
    CGFloat maxH = ( 36  + 20  ) / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:additionInfo];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    if ( temStrSize.height > tempMaxH  )
        totalHeight += maxH * 2 + 60 / CP_GLOBALSCALE;
    else
        totalHeight += temStrSize.height + 40 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)resumeEditAttachmentInfoImageMarge:(ResumeNameModel *)resumeModel
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:resumeModel.AdditionInfo];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    if ( temStrSize.height > tempMaxH  )
        totalHeight += 60 / CP_GLOBALSCALE;
    else
        totalHeight += 40 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)resumeEditAdditionHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    CGFloat addButtonHeight = 144.0 / CP_GLOBALSCALE;
    NSString *additionStr = resumeModel.AdditionInfo;
    if ( additionStr && 0 < [additionStr length] )
    {
        totalHeight += [self resumeEditAdditionInfoHeight:resumeModel.AdditionInfo];
        NSMutableArray *attachmentArrayM = resumeModel.ResumeAttachmentList;
        CGFloat imageHeight = ( kScreenWidth - 40 / CP_GLOBALSCALE * 8 ) / 5.0;
        if ( attachmentArrayM && 0 < [attachmentArrayM count] )
        {
            totalHeight += imageHeight + ( 60 + 30 + 24 + 24 ) / CP_GLOBALSCALE;
        }
    }else if(nil != resumeModel.ResumeAttachmentList && [resumeModel.ResumeAttachmentList count]>0){
//        totalHeight += [self resumeEditAdditionInfoHeight:resumeModel.AdditionInfo];
        NSMutableArray *attachmentArrayM = resumeModel.ResumeAttachmentList;
        CGFloat imageHeight = ( kScreenWidth - 40 / CP_GLOBALSCALE * 8 ) / 5.0;
        if ( attachmentArrayM && 0 < [attachmentArrayM count] )
        {
            totalHeight += imageHeight + ( 60 + 30 + 24 + 24 ) / CP_GLOBALSCALE;
        }
    }
    if ( 0 == totalHeight )
    {
        totalHeight += fixldHeight + addButtonHeight;
    }
    else
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
@end
