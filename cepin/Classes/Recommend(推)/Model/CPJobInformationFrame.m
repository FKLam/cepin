//
//  CPJobInformationFrame.m
//  cepin
//
//  Created by ceping on 15/12/3.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "CPJobInformationFrame.h"
#import "JobDetailModelDTO.h"
#import "TBTextUnit.h"
#import "NSDate-Utilities.h"


@implementation CPJobInformationFrame

#pragma mark - setter
- (void)setJobInformation:(JobDetailModelDTO *)jobInformation
{
    _jobInformation = jobInformation;
    
    CGFloat maxWidth = kScreenWidth - 20 * 2;
    CGFloat vertical_marge = 10.0;
    
    // 职位
    CGSize positionSize = [jobInformation.PositionName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] jobInformationPositionFont] } context:nil].size;
    CGFloat positionX = 20;
    CGFloat positionY = vertical_marge;
    CGFloat positionW = positionSize.width;
    CGFloat positionH = positionSize.height;
    if( positionW > maxWidth )
    {
        NSInteger modeNum = positionW / maxWidth;
        
        if ( modeNum * maxWidth < positionW )
            positionH = positionSize.height * (modeNum + 1);
        
        positionW = maxWidth;
    }
    _positionFrame = CGRectMake(positionX, positionY, positionW, positionH);
    
    // 薪水
    NSString *tempSaleStr = [NSString stringWithFormat:@"%@ %@", jobInformation.Salary, @"/月"];
    CGSize saleSize = [tempSaleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] jobInformationSaleFont] } context:nil].size;
    CGFloat saleX = 20;
    CGFloat saleY = CGRectGetMaxY(_positionFrame) + 8.0;
    CGFloat saleW = saleSize.width;
    CGFloat saleH = saleSize.height;
    if ( saleW > maxWidth )
    {
        NSInteger modeNum = saleW / maxWidth;
        if ( maxWidth * modeNum < saleW )
            modeNum += 1;
        
        saleH = saleSize.height * modeNum;
        saleW = maxWidth;
    }
    _saleFrame = CGRectMake(saleX, saleY, saleW, saleH);
    
    // 具体详情
    NSString *person = jobInformation.PersonNumber?[NSString stringWithFormat:@"%@人",jobInformation.PersonNumber]:@"";
    NSString *age = jobInformation.Age ? [NSString stringWithFormat:@"%@岁", jobInformation.Age] : @"";
    NSString *tempInformationStr = [TBTextUnit jobDetailWithAddress:jobInformation.City function:jobInformation.PositionNature educationLevel:jobInformation.EducationLevel age:age experience:jobInformation.WorkYear time:[NSDate cepinJobYearMonthDayFromString:jobInformation.PublishDate] PersonNumber:person];
    
    CGSize informationLabelSize = [tempInformationStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] jobInformationDetaillFont] } context:nil].size;
    CGFloat informationLabelX = 20;
    CGFloat informationLabelY = CGRectGetMaxY(_saleFrame) + 8.0;
    CGFloat informationLabelW = informationLabelSize.width;
    CGFloat informationLabelH = informationLabelSize.height;
    if ( informationLabelSize.width > kScreenWidth - 20 * 2 )
    {
        NSInteger modeNum = informationLabelW / maxWidth;
        if( maxWidth * modeNum < informationLabelW )
            modeNum += 1;
        
        informationLabelH = informationLabelSize.height * modeNum;
        informationLabelW = maxWidth;
    }
    _informatonFrame = CGRectMake(informationLabelX, informationLabelY, informationLabelW, informationLabelH);
    
    // 公司名称
    CGSize companyNameSize = [jobInformation.CompanyName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] jobInformationCompanyFont] } context:nil].size;
    
    CGFloat companyNameX = 20.0;
    CGFloat companyNameY = CGRectGetMaxY(_informatonFrame) + 8.0;
    CGFloat companyNameW = companyNameSize.width;
    CGFloat companyNameH = companyNameSize.height;
    
    if ( companyNameW > maxWidth )
    {
        NSInteger modeNum = companyNameW / maxWidth;
        if( maxWidth * modeNum < companyNameW )
            modeNum += 1;
        
        companyNameH = companyNameSize.height * modeNum;
        companyNameW = maxWidth;
    }
    _companyNameFrame = CGRectMake(companyNameX, companyNameY, companyNameW, companyNameH);
    
    _totalHeight = CGRectGetMaxY(_companyNameFrame) + 4.0;
}

@end
