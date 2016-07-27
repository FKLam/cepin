//
//  CPResumeReviewReformer.m
//  cepin
//
//  Created by ceping on 16/2/4.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeReviewReformer.h"
#import "BaseCodeDTO.h"
#import "TBTextUnit.h"
#import "CPCommon.h"
@implementation CPResumeReviewReformer
+ (CGFloat)reviewExpectWorkHeight:(ResumeNameModel *)resumeModel
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4;
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0) / CP_GLOBALSCALE;
    if ( !resumeModel.ExpectCity || 0 == [resumeModel.ExpectCity length])
    {
        totalHeight = 0;
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
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.CodeName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
            BaseCode *last = [arrarCode lastObject];
            if ( ![i.CodeName isEqualToString:last.CodeName] )
            {
                if ( 0 < [attStr length] )
                {
                    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
                }
            }
        }
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]}]];
        for (Region *i in array)
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.RegionName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
            if ( ![i isEqual:[array lastObject]] )
            {
                if ( 0 < [attStr length] )
                {
                    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"/" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
                }
            }
        }
        if ( 0 < [type length] )
        {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        if ( 0 < [resumeModel.ExpectSalary length] )
        {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:resumeModel.ExpectSalary attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]}]];
        if( resumeModel.ResumeType.intValue == 2 )
        {
            NSString *availabelStr = nil;
            if( resumeModel.AvailableType && resumeModel.AvailableType.length > 0 )
            {
                availabelStr = [NSString stringWithFormat:@"%@到岗", resumeModel.AvailableType];
            }
            else
            {
                availabelStr = [NSString stringWithFormat:@"%@到岗时间", @"不限"];
            }
            if ( availabelStr )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:availabelStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
            }
            // 1不服从，0服从
            NSString *allowStr = nil;
            if ( resumeModel.IsAllowDistribution && resumeModel.IsAllowDistribution > 0 )
            {
                allowStr = resumeModel.IsAllowDistribution.intValue ? @"，服从分配" : @"，不服从分配";
            }
            if ( allowStr )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:allowStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
            }
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:40.5 / CP_GLOBALSCALE];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        totalHeight += temStrSize.height;
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)reviewSocailExpectWorkHeight:(ResumeNameModel *)resumeModel
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 40 + 120 + 6.0 + 2.0 ) / CP_GLOBALSCALE;
    if ( !resumeModel.ExpectCity || 0 == [resumeModel.ExpectCity length])
    {
        totalHeight = 0;
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
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.CodeName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
            BaseCode *last = [arrarCode lastObject];
            if ( ![i.CodeName isEqualToString:last.CodeName] )
            {
                if ( 0 < [attStr length] )
                {
                    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
                }
            }
        }
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]}]];
        for (Region *i in array)
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:i.RegionName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
            if ( ![i isEqual:[array lastObject]] )
            {
                if ( 0 < [attStr length] )
                {
                    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"/" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
                }
            }
        }
        if ( 0 < [type length] )
        {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        if ( 0 < [resumeModel.ExpectSalary length] )
        {
            if ( 0 < [attStr length] )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:separatorLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor grayColor]}]];
            }
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:resumeModel.ExpectSalary attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
        }
        if( resumeModel.ResumeType.intValue == 2 )
        {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]}]];
        }
        if( resumeModel.ResumeType.intValue == 2 )
        {
            NSString *availabelStr = nil;
            if( resumeModel.AvailableType && resumeModel.AvailableType.length > 0 )
            {
                availabelStr = [NSString stringWithFormat:@"%@到岗", resumeModel.AvailableType];
            }
            else
            {
                availabelStr = [NSString stringWithFormat:@"%@到岗时间", @"不限"];
            }
            if ( availabelStr )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:availabelStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
            }
            // 1不服从，0服从
            NSString *allowStr = nil;
            if ( resumeModel.IsAllowDistribution && resumeModel.IsAllowDistribution > 0 )
            {
                allowStr = resumeModel.IsAllowDistribution.intValue ? @"，服从分配" : @"，不服从分配";
            }
            if ( allowStr )
            {
                [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:allowStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"]}]];
            }
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:40.5 / CP_GLOBALSCALE];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        totalHeight += temStrSize.height;
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)reviewInformationHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 2 * 2 + 6.0 + 40 * 6 + 36 * 6 + 60 * 3 + 36 + 40 ) / CP_GLOBALSCALE;
    if ( ( resumeModel.QQ && 0 < [resumeModel.QQ length] ) || ( resumeModel.Hukou && 0 < [resumeModel.Hukou length] ) )
    {
        totalHeight += 36 / CP_GLOBALSCALE;
    }
    if ( totalHeight > 0 )
    {
        totalHeight += 40 / CP_GLOBALSCALE;
    }
    if ( resumeModel.Address && 0 < [resumeModel.Address length] )
    {
        NSString *staticAddressString = @"通讯地址         ";
        CGSize staticAddressSize = [staticAddressString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE ] } context:nil].size;
        CGFloat addressW = kScreenWidth - staticAddressSize.width - 40 / CP_GLOBALSCALE - 20 / CP_GLOBALSCALE;
        CGSize addressSize = [resumeModel.Address boundingRectWithSize:CGSizeMake(addressW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE ] } context:nil].size;
        totalHeight += 40 / CP_GLOBALSCALE + addressSize.height;
    }
    if ( resumeModel.ZipCode && 0 < [resumeModel.ZipCode length] )
    {
        totalHeight += 36 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    }
    if ( resumeModel.EmergencyContact && 0 < [resumeModel.EmergencyContact length] )
    {
        NSString *staticContactString = @"紧急联系人     ";
        CGSize staticContactSize = [staticContactString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE ] } context:nil].size;
        CGFloat contactW = kScreenWidth - staticContactSize.width - 40 / CP_GLOBALSCALE - 40 / CP_GLOBALSCALE;
        CGSize contactSize = [resumeModel.EmergencyContact boundingRectWithSize:CGSizeMake(contactW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} context:nil].size;
        totalHeight += contactSize.height + 40 / CP_GLOBALSCALE;
    }
    if ( resumeModel.EmergencyContactPhone && 0 < [resumeModel.EmergencyContactPhone length] )
    {
        totalHeight += 36 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    }
    return totalHeight + fixldHeight + 20 / CP_GLOBALSCALE;
}
+ (CGFloat)reviewEducationAdditionalHeight:(EducationListDateModel *)education
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
    CGFloat totalHeight = 0;
    if ( [[education valueForKey:@"ScoreRanking"] isKindOfClass:[NSNull class]] && [[education valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
        return totalHeight;
    NSMutableString *strM = [[NSMutableString alloc] init];
    if ( ![[education valueForKey:@"ScoreRanking"] isKindOfClass:[NSNull class]] )
    {
        [strM appendString:@"成绩排名 : "];
        NSString *scoreStr = [education valueForKey:@"ScoreRanking"];
        NSString *rankStr = nil;
        if([@"5" isEqualToString:scoreStr])
        {
            rankStr = @"年级前5%";
        }
        else if([@"10" isEqualToString:scoreStr])
        {
            rankStr = @"年级前10%";
        }
        else if([@"20" isEqualToString:scoreStr])
        {
            rankStr = @"年级前20%";
        }
        else if([@"50" isEqualToString:scoreStr])
        {
            rankStr = @"年级前50%";
        }
        else if([@"0" isEqualToString:scoreStr])
        {
            rankStr = @"其他";
        }
        [strM appendString:rankStr];
    }
    if ( ![[education valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
    {
        if ( 0 < [strM length] )
        {
            [strM appendString:@"\n"];
        }
        NSString *desStr = [education valueForKey:@"Description"];
        [strM appendString:@"主修课程 : "];
        [strM appendString:desStr];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[strM copy]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    CGSize testSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    totalHeight += testSize.height;
    return totalHeight + 20 / CP_GLOBALSCALE;
}
+ (CGFloat)reviewEducationHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 6.0 + 2 + 6 ) / CP_GLOBALSCALE;
    NSMutableArray<EducationListDateModel> *educationList = resumeModel.EducationList;
    for ( EducationListDateModel *education in educationList )
    {
        if ( education )
        {
            totalHeight += ( 36 + 40 + 36 + 20 + 36 + 60 ) / CP_GLOBALSCALE;
            if ( 2 == [resumeModel.ResumeType intValue] )
            {
                totalHeight += [self reviewEducationAdditionalHeight:education];
            }
        }
    }
    if ( totalHeight > 0 )
        totalHeight += fixldHeight + 40 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)reviewDescribeHeight:(ResumeNameModel *)resumeModel
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    CGFloat maxH = ( 36  + 20  ) / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 6.0 + 2 + 6 ) / CP_GLOBALSCALE;
    if ( resumeModel.UserRemark && 0 < [resumeModel.UserRemark length] )
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:resumeModel.UserRemark attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += temStrSize.height;
        else
            totalHeight += maxH;
    }
    if ( 0 < totalHeight )
    {
        if ( maxH == totalHeight )
            totalHeight += fixldHeight + 40 / CP_GLOBALSCALE + 20 / CP_GLOBALSCALE;
        else
            totalHeight += fixldHeight + 40 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)reviewStudyProveHeight:(WorkListDateModel *)study
{
    CGFloat maxW = kScreenWidth - ( 30 + 48 + 45 + 40 ) / CP_GLOBALSCALE;
    NSString *staticStr = @"证明人 : ";
    CGSize staticStrSize = [staticStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} context:nil].size;
    maxW -= staticStrSize.width;
    CGFloat totalHeight = 0;
    if (  [[study valueForKey:@"AttestorName"] isKindOfClass:[NSNull class]] )
        return totalHeight;
    NSMutableString *strM = [[NSMutableString alloc] init];
    [strM appendString:[study valueForKey:@"AttestorName"]];
    [strM appendString:[NSString stringWithFormat:@" /%@\n", [study valueForKey:@"AttestorRelation"]]];
    [strM appendString:[NSString stringWithFormat:@"%@ /%@", [study valueForKey:@"AttestorPosition"], [study valueForKey:@"AttestorPhone"]]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:strM];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    CGSize testSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    totalHeight += testSize.height;
    return totalHeight;
}
+ (CGFloat)reviewStudyProveCompanyHeight:(WorkListDateModel *)study
{
    CGFloat maxW = kScreenWidth - ( 30 + 48 + 45 + 40 ) / CP_GLOBALSCALE;
    NSString *staticStr = @"证明人单位 : ";
    CGSize staticStrSize = [staticStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} context:nil].size;
    maxW -= staticStrSize.width;
    CGFloat totalHeight = 0;
    if (  [[study valueForKey:@"AttestorCompany"] isKindOfClass:[NSNull class]] )
        return totalHeight;
    NSMutableString *strM = [[NSMutableString alloc] init];
    [strM appendString:[study valueForKey:@"AttestorCompany"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:strM];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    CGSize testSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    if ( 21 < testSize.height )
        totalHeight += testSize.height + 60.0 / CP_GLOBALSCALE;
    else
        totalHeight += testSize.height + 40 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)reviewStudyProveManCompanyMarge:(WorkListDateModel *)study
{
    CGFloat maxW = kScreenWidth - ( 30 + 48 + 45 + 40 ) / CP_GLOBALSCALE;
    NSString *staticStr = @"证明人单位 : ";
    CGSize staticStrSize = [staticStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} context:nil].size;
    maxW -= staticStrSize.width;
    CGFloat totalHeight = 0;
    if (  [[study valueForKey:@"AttestorCompany"] isKindOfClass:[NSNull class]] )
        return totalHeight;
    NSMutableString *strM = [[NSMutableString alloc] init];
    [strM appendString:[study valueForKey:@"AttestorCompany"]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:strM];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    CGSize testSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    if ( 21 < testSize.height )
        totalHeight += 60.0 / CP_GLOBALSCALE;
    else
        totalHeight += 40 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)reviewStudyTypeHeight:(WorkListDateModel *)study resume:(ResumeNameModel *)resume
{
    CGFloat totalHeight = 0;
    CGFloat maxW = kScreenWidth - ( 30 + 48 + 45 + 40 ) / CP_GLOBALSCALE;
    NSMutableString *positonStr = [NSMutableString stringWithFormat:@"%@  |  %@", [study valueForKey:@"JobFunction"], [study valueForKey:@"Industry"]];
    if ( 2 == [resume.ResumeType intValue] )
    {
        [positonStr appendFormat:@"  |  %@", [study valueForKey:@"Nature"]];
    }
    CGSize testSize = [positonStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} context:nil].size;
    totalHeight = testSize.height;
    return totalHeight;
}
+ (CGFloat)reviewStudyTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 6.0 + 2 ) / CP_GLOBALSCALE;
    CGFloat blockHeight = ( 36 + 40 + 36 + 20 + 60 ) / CP_GLOBALSCALE;
    NSMutableArray<WorkListDateModel> *workList = resumeModel.WorkList;
    for ( WorkListDateModel *work in workList )
    {
        if ( ![[work valueForKey:@"AttestorName"] isKindOfClass:[NSNull class]] )
        {
            CGFloat tempH = [self reviewStudyProveHeight:work] + 20 / CP_GLOBALSCALE;
            CGFloat companyH = [self reviewStudyProveCompanyHeight:work];
            totalHeight += tempH + blockHeight + companyH;
            totalHeight += [self reviewStudyTypeHeight:work resume:resumeModel];
        }
        else
        {
            totalHeight += blockHeight;
            totalHeight += [self reviewStudyTypeHeight:work resume:resumeModel];
        }
    }
    if ( 0 < totalHeight )
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)reviewProjectDescribeHeight:(ProjectListDataModel *)project
{
    CGFloat maxW = kScreenWidth - 163 / CP_GLOBALSCALE;
//    CGFloat maxH = ( 36  + 20  ) / 3.0;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    if ( ![[project valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
    {
        NSString *preStr = @"项目描述 : ";
        NSString *temStr = [NSString stringWithFormat:@"%@%@", preStr, [project valueForKey:@"Content"]];
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
+ (CGFloat)reviewProjectLinkHeight:(ProjectListDataModel *)project
{
    CGFloat maxW = kScreenWidth - 163 / CP_GLOBALSCALE;
//    CGFloat maxH = ( 36  + 20  ) / 3.0;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    if (  ![[project valueForKey:@"ProjectLink"] isKindOfClass:[NSNull class]] )
    {
        NSString *preStr = @"项目链接 : ";
        NSString *temStr = [NSString stringWithFormat:@"%@%@", preStr, [project valueForKey:@"ProjectLink"]];
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
+ (CGFloat)reviewProjectGainHeight:(ProjectListDataModel *)project
{
    CGFloat maxW = kScreenWidth - 163 / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    if (  ![[project valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
    {
        NSString *preStr = @"成果描述 : ";
        NSString *temStr = [NSString stringWithFormat:@"%@%@", preStr, [project valueForKey:@"Description"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += temStrSize.height;
        else
            totalHeight += temStrSize.height - 20 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)reviewProjectDutyHeight:(ProjectListDataModel *)project
{
    CGFloat maxW = kScreenWidth - 163 / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    if (  ![[project valueForKey:@"Duty"] isKindOfClass:[NSNull class]] )
    {
        NSString *temStr = [project valueForKey:@"Duty"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += temStrSize.height;
        else
            totalHeight += temStrSize.height - 20 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)reviewProjectTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 6.0 + 2 ) / CP_GLOBALSCALE;
    CGFloat blockHeight = ( 36 + 40 + 36 + 40 ) / CP_GLOBALSCALE;
    NSMutableArray<ProjectListDataModel> *projectList = resumeModel.ProjectList;
    for ( ProjectListDataModel *project in projectList )
    {
        if ( ![[project valueForKey:@"Duty"] isKindOfClass:[NSNull class]] )
        {
            if ( 0 < [[project valueForKey:@"Duty"] length] )
            {
                CGFloat tempH = [self reviewProjectDutyHeight:project];
                totalHeight += tempH + 40 / CP_GLOBALSCALE;
                if ( tempH > 21 )
                    totalHeight += 20 / CP_GLOBALSCALE;
            }
        }
        if ( ![[project valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
        {
            if ( 0 < [[project valueForKey:@"Content"] length] )
            {
                CGFloat tempH = [self reviewProjectDescribeHeight:project];
                totalHeight += tempH + blockHeight;
                totalHeight += 40 / CP_GLOBALSCALE;
                if ( tempH > 21 )
                    totalHeight += 20 / CP_GLOBALSCALE;
            }
        }
        else
        {
            totalHeight += blockHeight;
        }
        if ( ![[project valueForKey:@"ProjectLink"] isKindOfClass:[NSNull class]] )
        {
            if ( 0 < [[project valueForKey:@"ProjectLink"] length] )
            {
                CGFloat tempH = [self reviewProjectLinkHeight:project];
                if ( 0 < tempH )
                {
                    totalHeight += tempH + 40 / CP_GLOBALSCALE;
                    if ( tempH > 21 )
                        totalHeight += 20 / CP_GLOBALSCALE;
                }
            }
        }
        if ( 2 == [resumeModel.ResumeType intValue] )
        {
            totalHeight += 40 / CP_GLOBALSCALE + 36 / CP_GLOBALSCALE;
            if ( ![[project valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
            {
                if ( 0 < [[project valueForKey:@"Description"] length] )
                {
                    CGFloat tempH = [self reviewProjectGainHeight:project];
                    if ( 0 < tempH )
                    {
                        totalHeight += tempH + 40 / CP_GLOBALSCALE;
                        if ( tempH > 21 )
                            totalHeight += 20 / CP_GLOBALSCALE;
                    }
                }
            }
        }
    }
    if ( 0 < totalHeight )
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)reviewPraciticeDescribeHeight:(PracticeListDataModel *)pracitice
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
    CGFloat totalHeight = 0;
    if (  ![[pracitice valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
    {
        NSString *preStr = @"实践描述 : ";
        NSString *temStr = [NSString stringWithFormat:@"%@%@", preStr, [pracitice valueForKey:@"Content"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        totalHeight += temStrSize.height;
    }
    return totalHeight;
}
+ (CGFloat)reviewPraciticeTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 6.0 + 2 ) / CP_GLOBALSCALE;
    NSMutableArray<PracticeListDataModel> *practiceList = resumeModel.PracticeList;
    NSMutableArray<AwardsListDataModel> *awardList = resumeModel.AwardsList;
    NSMutableArray<StudentLeadersDataModel> *leaderList = resumeModel.StudentLeadersList;
    for ( PracticeListDataModel *practice in practiceList )
    {
        totalHeight += [self reviewPraciticeDescribeHeight:practice] + (36 + 40 + 36 + 20 + 36 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    }
    for ( NSInteger index = 0; index < [awardList count]; index++ )
    {
        totalHeight += ( 36 + 40 + 36 + 60 ) / CP_GLOBALSCALE;
    }
    for ( NSInteger index = 0; index < [leaderList count]; index++ )
    {
        totalHeight += ( 36 + 40 + 36 + 60 ) / CP_GLOBALSCALE;
    }
    if ( 0 < totalHeight )
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)reviewTrainContentHeight:(TrainingDataModel *)train
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
    CGFloat totalHeight = 0;
    if (  ![[train valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
    {
        NSString *temStr = [train valueForKey:@"Content"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        totalHeight += temStrSize.height;
    }
    return totalHeight;
}
+ (CGFloat)reviewTrainTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 6.0 + 2 ) / CP_GLOBALSCALE;
    NSMutableArray<TrainingDataModel> *trainList = resumeModel.TrainingList;
    for ( TrainingDataModel *train in trainList )
    {
        totalHeight += [self reviewTrainContentHeight:train] + (36 + 40 + 36 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    }
    if ( 0 < totalHeight )
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)reviewSkillTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 6.0 + 2 ) / CP_GLOBALSCALE;
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
    if ( 0 < totalHeight )
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
+ (CGFloat)reviewSocailInforHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 2 * 2 + 6.0 + 60.0 ) / CP_GLOBALSCALE;
    totalHeight += 36 / CP_GLOBALSCALE + 50 / CP_GLOBALSCALE;
    if ( resumeModel.Region && 0 < [resumeModel.Region length] )
    {
        totalHeight += 36 / CP_GLOBALSCALE + 50 / CP_GLOBALSCALE;
    }
    else
    {
        totalHeight += 36 / CP_GLOBALSCALE;
    }
    totalHeight += [self reviewIntroducesHeight:resumeModel];
    totalHeight += 40 / CP_GLOBALSCALE;
    totalHeight += 36 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE;
    if ( resumeModel.Politics && 0 < [resumeModel.Politics length] )
    {
        totalHeight += 36 / CP_GLOBALSCALE + 40 / CP_GLOBALSCALE + 50 / CP_GLOBALSCALE;
    }
    else
    {
        totalHeight += 40 / CP_GLOBALSCALE + 36 / CP_GLOBALSCALE;
    }
    return totalHeight + fixldHeight;
}
+ (CGFloat)reviewIntroducesHeight:(ResumeNameModel *)resumeModel
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    NSString *staticStr = @"一句话优势    ";
    CGSize staticSize = [staticStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} context:nil].size;
    maxW -= staticSize.width;
    CGFloat totalHeight = 0;
    if (  resumeModel.Introduces )
    {
        NSString *temStr = resumeModel.Introduces;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        totalHeight += temStrSize.height;
    }
    else
    {
        totalHeight += ( 20 + 36 ) / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)reviewWorkExperienceContentHeight:(WorkListDateModel *)work
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
    CGFloat totalHeight = 0;
    if (  ![[work valueForKey:@"Content"] isKindOfClass:[NSNull class]] )
    {
        NSMutableString *strM = [[NSMutableString alloc] initWithString:@"工作描述 : "];
        [strM appendString:[work valueForKey:@"Content"]];
        NSString *temStr = [strM copy];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        totalHeight += temStrSize.height;
    };
    return totalHeight;
}
+ (CGFloat)reviewWorkExperienceSalaryHeight:(WorkListDateModel *)work
{
    CGFloat totalHeight = 0;
    if ( ![[work valueForKey:@"Salary"] isKindOfClass:[NSNull class]] )
    {
        totalHeight += ( 36 + 20 ) / CP_GLOBALSCALE;
    }
    if ( ![[work valueForKey:@"Size"] isKindOfClass:[NSNull class]] && 0 == totalHeight )
    {
        totalHeight += ( 36 + 20 ) / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)reviewWorkExperienceTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 6.0 + 2 ) / CP_GLOBALSCALE;
    NSMutableArray<WorkListDateModel> *workList = resumeModel.WorkList;
    for ( WorkListDateModel *work in workList )
    {
        if ( 0 < [self reviewWorkExperienceSalaryHeight:work] )
            totalHeight += [self reviewWorkExperienceSalaryHeight:work] + 25 / CP_GLOBALSCALE;
        totalHeight += [self reviewWorkExperienceContentHeight:work] + (36 + 40 + 36 + 20 + 36 + 20 ) / CP_GLOBALSCALE + 60 / CP_GLOBALSCALE;
    }
    if ( 0 < totalHeight )
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)reviewAttachmentInfoImageMarge:(ResumeNameModel *)resumeModel
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
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
+ (CGFloat)reviewAttachmentInfoHeight:(ResumeNameModel *)resumeModel
{
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    CGFloat tempMaxH = 21.0;
    CGFloat totalHeight = 0;
    NSString *additionInfo = resumeModel.AdditionInfo;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:additionInfo];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"404040"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
    CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    if ( temStrSize.height > tempMaxH  )
        totalHeight += temStrSize.height + 60 / CP_GLOBALSCALE;
    else
        totalHeight += temStrSize.height + 40 / CP_GLOBALSCALE;
    return totalHeight;
}
+ (CGFloat)reviewAttachmentTotalHeight:(ResumeNameModel *)resumeModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 120 + 6.0 + 2 ) / CP_GLOBALSCALE;
    NSString *additionStr = resumeModel.AdditionInfo;
    if ( additionStr && 0 < [additionStr length] )
    {
        totalHeight += [self reviewAttachmentInfoHeight:resumeModel];
        NSMutableArray *attachmentArrayM = resumeModel.ResumeAttachmentList;
        CGFloat imageHeight = ( kScreenWidth - 40 / CP_GLOBALSCALE * 8 ) / 5.0;
        if ( attachmentArrayM && 0 < [attachmentArrayM count] )
        {
            totalHeight += imageHeight + ( 60 + 30 + 24 + 24 ) / CP_GLOBALSCALE;
        }
    }else if(nil != resumeModel.ResumeAttachmentList && [resumeModel.ResumeAttachmentList count]>0){
        NSMutableArray *attachmentArrayM = resumeModel.ResumeAttachmentList;
        CGFloat imageHeight = ( kScreenWidth - 40 / CP_GLOBALSCALE * 8 ) / 5.0;
        if ( attachmentArrayM && 0 < [attachmentArrayM count] )
        {
            totalHeight += imageHeight + ( 60 + 30 + 24 + 24 ) / CP_GLOBALSCALE;
        }
    }
    if ( 0 < totalHeight )
        totalHeight += fixldHeight + 60 / CP_GLOBALSCALE;
    return totalHeight;
}
@end