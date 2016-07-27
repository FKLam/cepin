//
//  CPResumeEducationReformer.m
//  cepin
//
//  Created by ceping on 16/3/7.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEducationReformer.h"
#import "SchoolDTO.h"
#import "BaseCodeDTO.h"
#import "CPCommon.h"
@implementation CPResumeEducationReformer
+ (NSArray *)searchSchoolWithMatchString:(NSString *)matchString
{
    NSMutableArray *matchArray = [NSMutableArray array];
    if ( !matchString || 0 == [matchString length] )
        return [matchArray copy];
    NSMutableArray *allSchool = [School school];
    for ( School *school in allSchool )
    {
        NSRange range = [school.Name rangeOfString:matchString];
        if ( range.location == NSNotFound )
            continue;
        [matchArray addObject:school];
    }
    return [matchArray copy];
}
+ (NSArray *)searchMajorWithMatchString:(NSString *)matchString
{
    NSMutableArray *matchArray = [NSMutableArray array];
    if ( !matchString || 0 == [matchString length] )
        return [matchArray copy];
    NSMutableArray *allMajor = [BaseCode AllMajor];
    for ( BaseCode *major in allMajor )
    {
        NSRange range = [major.CodeName rangeOfString:matchString];
        if ( range.location == NSNotFound )
            continue;
        [matchArray addObject:major];
    }
    return [matchArray copy];
}
+ (CGFloat)educationListRowHeightWithEducationModel:(EducationListDateModel *)educationModel
{
    CGFloat totalHeight = 0;
    CGFloat fixldHeight = ( 60 + 60 + 36 + 60 + 42 + 20 + 36 + 60 + 6 ) / CP_GLOBALSCALE;
//    CGFloat maxH = ( 36  + 20  ) / CP_GLOBALSCALE;
//    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4;
//    CGFloat tempMaxH = 21.0;
    if ( educationModel.ScoreRanking && 0 < [educationModel.ScoreRanking length] )
    {
        totalHeight += ( 36 + 20 ) / CP_GLOBALSCALE;
    }
//    if ( educationModel.Description && 0 < [educationModel.Description length] )
//    {
//        NSString *preStr = @"主修课程 : ";
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", preStr, educationModel.Description]];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
//        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
//        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attStr length])];
//        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9d9d9d"], NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE]} range:NSMakeRange(0, [attStr length])];
//        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//        if ( temStrSize.height > tempMaxH  )
//            totalHeight += maxH * 2;
//        else
//            totalHeight += temStrSize.height - 20 / CP_GLOBALSCALE;
//        totalHeight += 20 / CP_GLOBALSCALE;
//    }
    totalHeight += fixldHeight;
    return totalHeight;
}
@end
