//
//  CPResumeProjectReformer.m
//  cepin
//
//  Created by ceping on 16/1/25.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeProjectReformer.h"
#import "CPCommon.h"
@implementation CPResumeProjectReformer
+ (CGFloat)projectHeightWith:(ProjectListDataModel *)projectData
{
    CGFloat totalHeight = 0;
    CGFloat fixdHeight = ( 60 + 60 + 36 + 60 + 42 + 18 + 6 ) / CP_GLOBALSCALE;
    if ( projectData.Duty )
    {
        CGFloat tempH = [self dutyHeightWithProject:projectData];
        totalHeight += tempH;
    }
    if ( projectData.Content )
    {
        CGFloat tempH = [self projectDescribeWithProject:projectData];
        totalHeight += 40 / CP_GLOBALSCALE + tempH;
    }
    if ( projectData.ProjectLink && 0 < [projectData.ProjectLink length] )
    {
        totalHeight += 40 / CP_GLOBALSCALE + 48 / CP_GLOBALSCALE;
    }
    return totalHeight + 60 / CP_GLOBALSCALE + fixdHeight + 40 / CP_GLOBALSCALE;
}
+ (CGFloat)dutyHeightWithProject:(ProjectListDataModel *)projectModel
{
    CGFloat totalHeight = 0;
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
    CGFloat maxH = ( 36  + 20 + 36 ) / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    if ( projectModel.Duty )
    {
        NSString *temStr = [projectModel valueForKey:@"Duty"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += maxH;
        else
            totalHeight += temStrSize.height - 20 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
+ (CGFloat)projectDescribeWithProject:(ProjectListDataModel *)projectModel
{
    CGFloat totalHeight = 0;
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 4 - 48 / CP_GLOBALSCALE - 55 / CP_GLOBALSCALE;
    CGFloat maxH = ( 36  + 20 + 36 ) / CP_GLOBALSCALE;
    CGFloat tempMaxH = 21.0;
    if ( projectModel.Content )
    {
        NSString *temStr = [projectModel valueForKey:@"Content"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE], NSParagraphStyleAttributeName : paragraphStyle}];
        CGSize temStrSize = [attStr boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        if ( temStrSize.height > tempMaxH  )
            totalHeight += maxH;
        else
            totalHeight += temStrSize.height - 20 / CP_GLOBALSCALE;
    }
    return totalHeight;
}
@end
