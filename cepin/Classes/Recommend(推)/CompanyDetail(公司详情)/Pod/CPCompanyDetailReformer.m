//
//  CPCompanyDetailReformer.m
//  cepin
//
//  Created by ceping on 16/1/27.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPCompanyDetailReformer.h"
#import "CPRecommendModelFrame.h"
#import "JobSearchModel.h"
#import "CPCommon.h"
@implementation CPCompanyDetailReformer
+ (CGFloat)companyInforHeightWithCompanyData:(NSDictionary *)companyData
{
    CGFloat height = 0;
    CGFloat fixdHeight = ( 60 + 42 + 60 + 36 + 20 + 36 + 20 + 60 + 2 ) / CP_GLOBALSCALE;
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 5;
    NSString *industryStr = [companyData valueForKey:@"Industry"];
    NSString *addressStr = [companyData valueForKey:@"Address"];
    if([addressStr isKindOfClass:[NSNull class]] ||  [addressStr isEqual:[NSNull null]]){
        addressStr = @"";
    }
    NSString *webURLStr = nil;
    if ( ![[companyData valueForKey:@"WebSiteUrl"] isKindOfClass:[NSNull class]]){
     webURLStr = [companyData valueForKey:@"WebSiteUrl"];
    }else{
         webURLStr = @"";
    }
    UIFont *font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
    height = [self caculateTextHeightWtihText:industryStr font:font maxWidth:maxW] + [self caculateTextHeightWtihText:addressStr font:font maxWidth:maxW] + [self caculateTextHeightWtihText:webURLStr font:font maxWidth:maxW];
    height += 20 / CP_GLOBALSCALE;
    if ( webURLStr )
        height += 20 / CP_GLOBALSCALE;
    return height + fixdHeight;
}
+ (CGFloat)companyIntroduceHeightWithCampanyData:(NSDictionary *)companyData
{
    NSString *introduction = @"";
    if ( ![[companyData valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
        introduction = [companyData valueForKey:@"Description"];
    CGFloat height = 0;
    if ( 0 == [introduction length] )
        return height;
    CGFloat fixdHeight = ( 60 + 42 + 60 + 60 + 2 + 20 ) / CP_GLOBALSCALE;
    CGFloat buttonH = 144 / CP_GLOBALSCALE;
    CGFloat minHeight = ( 36 * 6 + 20 * 5 ) / CP_GLOBALSCALE;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    CGFloat tempHeight= [self companyIntroduceDescriptHeightWithCampanyData:companyData];
    if ( tempHeight > minHeight )
    {
        height += minHeight + buttonH;
    }
    else
        height += tempHeight - 20 / CP_GLOBALSCALE;
    return height + fixdHeight;
}
+ (CGFloat)companyIntroduceHeightWithCampanyData:(NSDictionary *)companyData isSelected:(BOOL)isSelecectd
{
    CGFloat height = 0;
    CGFloat fixdHeight = ( 60 + 42 + 60 + 60 + 2 + 20 ) / CP_GLOBALSCALE;
    CGFloat buttonH = 144 / CP_GLOBALSCALE;
    CGFloat minHeight = ( 36 * 6 + 20 * 5 ) / CP_GLOBALSCALE;
    CGFloat tempHeight= [CPCompanyDetailReformer companyIntroduceDescriptHeightWithCampanyData:companyData];
    if ( isSelecectd )
    {
        height += tempHeight;
        return height + fixdHeight + buttonH;
    }
    else
    {
        if ( tempHeight > minHeight )
        {
            height += minHeight + fixdHeight + buttonH;
        }
        else
        {
            height += tempHeight + ( 60 + 42 + 60 + 2 + 35 ) / CP_GLOBALSCALE;
        }
    }
    return height;
}
+ (CGFloat)companyIntroduceDescriptHeightWithCampanyData:(NSDictionary *)companyData
{
    NSString *introduction = @"";
    if ( ![[companyData valueForKey:@"Description"] isKindOfClass:[NSNull class]] )
        introduction = [companyData valueForKey:@"Description"];
    CGFloat height = 0;
    if ( 0 == [introduction length] )
        return height;
    CGFloat maxW = kScreenWidth - 40 / CP_GLOBALSCALE * 2;
    UIFont *font = [UIFont systemFontOfSize:36 / CP_GLOBALSCALE];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:20 / CP_GLOBALSCALE];
    CGSize tempSize = [introduction boundingRectWithSize:CGSizeMake(maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font} context:nil].size;
    return tempSize.height;
}
+ (CGFloat)companyDescriptViewHeightWithText:(NSDictionary *)companyData
{
    NSString *introduction = [companyData valueForKey:@"CompanyName"];
    NSString *desc = [companyData valueForKey:@"PulseEmployer"];
    CGFloat height = 0;
    CGFloat fixdHeight = ( 60 + 60 + 2 ) / CP_GLOBALSCALE;
    CGFloat describeHeight = ( 60 + 100 * 2 + 60) / CP_GLOBALSCALE;
    CGFloat maxW = kScreenWidth - 310/ CP_GLOBALSCALE ;
    UIFont *font = [UIFont systemFontOfSize:48 / CP_GLOBALSCALE];
    UIFont *desFont = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
    height += [self caculateTextHeightWtihText:introduction font:font maxWidth:maxW];
    if (NULL != desc && nil != desc && ![desc isKindOfClass:NSNull.class]) {
         height += [self caculateTextHeightWtihText:desc font:desFont maxWidth:maxW];
    }
    if( height+ 40 / CP_GLOBALSCALE > describeHeight ){
        return height + fixdHeight;
    }
    return describeHeight;
}
+ (CGFloat)companyPositionHeightWithCampanyData:(NSDictionary *)companyData offset:(NSInteger)offset
{
    CGFloat height = 0;
    CGFloat fixdHeight = 144 / CP_GLOBALSCALE;
    CGFloat rowHeight = (60 + 48 + 40 + 36 + 60) / CP_GLOBALSCALE;
    NSArray *positionArray = [self positionWithCompanyData:companyData toClass:[JobSearchModel class]];
    NSInteger count = 0;
    if ( offset > [positionArray count] )
        count = [positionArray count];
    else
        count = offset;
    height += rowHeight * count;
    return height + fixdHeight;
}
+ (CGFloat)companyWelfareHeightWithCompanyData:(NSDictionary *)companyData
{
    CGFloat height = 0;
    CGFloat fixdHeight = ( 60 + 42 + 60 + 60 + 2 ) / CP_GLOBALSCALE;
    CGFloat buttonX = 40 / CP_GLOBALSCALE;
    CGFloat buttonY = 0;
    CGFloat buttonH = ( 15 + 15 + 32 ) / CP_GLOBALSCALE;
    CGFloat buttonW = 0;
    NSString *buttonTitle = nil;
    CGFloat maxX = kScreenWidth - 40 / CP_GLOBALSCALE;
    NSUInteger stop = 0;
    NSArray *welfareArray = [self welfareWithCompanyData:companyData];
    if ( 0 == [welfareArray count] )
        return height;
    for ( NSUInteger index = 0; index < [welfareArray count]; index++ )
    {
        if ( 2 == stop )
            break;
        buttonTitle = welfareArray[index];
        buttonW = 15 / CP_GLOBALSCALE * 2 + 32 / CP_GLOBALSCALE * buttonTitle.length;
//        if ( maxX < buttonW + buttonX )
//            continue;
        buttonX += buttonW + 20 / CP_GLOBALSCALE;
        if ( buttonX > maxX )
        {
            stop++;
            buttonX = 40 / CP_GLOBALSCALE;
            buttonY += buttonH + 20 / CP_GLOBALSCALE;
        }
    }
    if ( 0 == stop )
        height += buttonH;
    else
        height += buttonH * 2.0 + 20 / CP_GLOBALSCALE;
    return height + fixdHeight;
}
+ (CGFloat)caculateTextHeightWtihText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    CGFloat height = 0;
    if ( !text || 0 == [text length] )
        return height;
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    height = textSize.height;
    return height;
}
+ (NSArray *)positionWithCompanyData:(NSDictionary *)companyData toClass:(Class)toClass
{
    NSArray *postionArray = nil;
    if ( [[companyData valueForKey:@"AppPositionInfoList"] isKindOfClass:[NSNull class]] )
        return nil;
    postionArray = [companyData valueForKey:@"AppPositionInfoList"];
    NSArray *tempArray = [CPRecommendModelFrame framesWithArray:postionArray modelClass:toClass];
    return tempArray;
}
+ (NSArray *)welfareWithCompanyData:(NSDictionary *)companyData
{
    NSArray *welfareArray = nil;
    if ( [[companyData valueForKey:@"WelfareList"] isKindOfClass:[NSNull class]] )
        return nil;
    welfareArray = [companyData valueForKey:@"WelfareList"];
    NSString *subRegexString = @"\\w+";
    NSRegularExpression *subRegex = [NSRegularExpression regularExpressionWithPattern:subRegexString options:NSRegularExpressionCaseInsensitive error:NULL];
    NSMutableArray *resultArray = [NSMutableArray array];
    for ( NSString *subStr in welfareArray )
    {
        if ( 8 < [subStr length] )
            continue;
        NSArray *regexArray = [subRegex matchesInString:subStr options:0 range:NSMakeRange(0, [subStr length])];
        if ( 0 == [regexArray count] )
            continue;
        [resultArray addObject:subStr];
    }
    if ( 0 == [resultArray count] )
        return nil;
    else
        return [resultArray copy];
}
@end
