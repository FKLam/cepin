//
//  CPRecommendModelFrame.m
//  cepin
//
//  Created by ceping on 15/11/19.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CPRecommendModelFrame.h"
#import "JobSearchModel.h"
#import "CPCommon.h"
#import "BaseBeanModel.h"
#import "NSDate-Utilities.h"
#import "DynamicExamModelDTO.h"
#import "SaveJobDTO.h"
#import "SaveCompanyModel.h"
#import "SendReumeModel.h"
#import "DynamicSystemModelDTO.h"
#import "KeywordModel.h"
@implementation CPRecommendModelFrame
/**
 *  获取到职位模型数据，计算各个控件的frame
 */
- (void)setRecommendModel:(id)recommendModel
{
    _recommendModel = recommendModel;
    if(![recommendModel isKindOfClass:[JobSearchModel class]])
        return;
    JobSearchModel *recommendModelCopy = (JobSearchModel *)recommendModel;
    // 整个职位模型数据在cell中显示的高度
    CGFloat totalHeight = 0;
    _totalHeight = ( 50 + 70 + 24 + 42 + 28 + 36 + 50 ) / CP_GLOBALSCALE;
    // 职位发布时间
    CGSize timeTextSize = [[NSDate cepinJobYearMonthDayFromString:recommendModelCopy.PublishDate] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE] } context:nil].size;
    // 职位
    CGSize positionTextSize = [recommendModelCopy.PositionName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE] } context:nil].size;
    _positionSize = positionTextSize;
    CGFloat timeX = CPScreenWidth - CPRECOMMEND_POSITION_HORIZONTAL_MARGE - timeTextSize.width;
    CGFloat timeY = CPRECOMMEND_POSITION_VERTITAL_MARGE + positionTextSize.height / 2.0;
    _timeFrame = CGRectMake(timeX, timeY, timeTextSize.width, timeTextSize.height);
    CGFloat positionX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE;
    CGFloat positionY = CPRECOMMEND_POSITION_VERTITAL_MARGE;
    _maxMarge = timeX - CPRECOMMEND_POSITION_HORIZONTAL_MARGE * 2;
    CGFloat positionW = positionTextSize.width;
    CGFloat positionH = positionTextSize.height;
    if( positionTextSize.width > _maxMarge )
    {
        positionW = _maxMarge;
        positionH = positionTextSize.height * 2;
    }
    _positionFrame = CGRectMake(positionX, positionY, positionW, positionH);
    // 工作地址
    if( nil != recommendModelCopy.City && 0 < recommendModelCopy.City.length )
    {
        CGFloat addressX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE + CPRecommendAddressWidthHeight;
        CGFloat addressY = CGRectGetMaxY(_positionFrame) + CPRECOMMEND_POSITION_VERTITAL_SPACE;
        CGSize addressTextSize = [recommendModelCopy.City boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE] } context:nil].size;
        _addressFrame = CGRectMake(addressX, addressY, addressTextSize.width, addressTextSize.height);
        totalHeight = CGRectGetMaxY(_addressFrame) + CPRECOMMEND_POSITION_VERTITAL_MARGE;
    }
    // 工作年限
    if( nil != recommendModelCopy.WorkYear && 0 < recommendModelCopy.WorkYear.length )
    {
        CGFloat experienceX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE / 2.0 + CGRectGetMaxX(_addressFrame) + CPRecommendAddressWidthHeight;
        if ( CGRectGetMaxX(_addressFrame) == 0 )
            experienceX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE + CPRecommendAddressWidthHeight;
        CGFloat experienceY = CGRectGetMaxY(_positionFrame) + CPRECOMMEND_POSITION_VERTITAL_SPACE;
        CGSize experienceTextSize = [recommendModelCopy.WorkYear boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE] } context:nil].size;
        _experienceFrame = CGRectMake(experienceX, experienceY, experienceTextSize.width, experienceTextSize.height);
        totalHeight = CGRectGetMaxY(_experienceFrame) + CPRECOMMEND_POSITION_VERTITAL_MARGE;
    }
    // 教育水平
    if( nil != recommendModelCopy.EducationLevel && 0 < recommendModelCopy.EducationLevel.length )
    {
        CGFloat educationY = CGRectGetMaxY(_positionFrame) + CPRECOMMEND_POSITION_VERTITAL_SPACE;
        CGFloat educationX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE / 2.0 + CGRectGetMaxX(_experienceFrame) + CPRecommendAddressWidthHeight;
        if ( CGRectGetMaxX(_experienceFrame) == 0 )
            educationX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE + CPRecommendAddressWidthHeight;
        NSString *educationStr = [recommendModelCopy.EducationLevel substringToIndex:2];
        if ( [recommendModelCopy.EducationLevel rangeOfString:@"EMBA"].length > 0 )
            educationStr = [recommendModelCopy.EducationLevel substringToIndex:4];
        else if ( [recommendModelCopy.EducationLevel rangeOfString:@"MBA"].length > 0 )
            educationStr = [recommendModelCopy.EducationLevel substringToIndex:3];
        if ( ![educationStr isEqualToString:@"不限"] && recommendModelCopy.EducationLevel.length > 2 && ![educationStr isEqualToString:@"MBA"] && ![educationStr isEqualToString:@"EMBA"])
            educationStr = [NSString stringWithFormat:@"%@...", educationStr];
        CGSize educationTextSize = [educationStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE] } context:nil].size;
        _educationFrame = CGRectMake(educationX, educationY, educationTextSize.width, educationTextSize.height);
        totalHeight = CGRectGetMaxY(_educationFrame) + CPRECOMMEND_POSITION_VERTITAL_MARGE;
    }
    // 薪水
    if( nil != recommendModelCopy.Salary && 0 < recommendModelCopy.Salary.length )
    {
        CGSize saleTextSize = [recommendModelCopy.Salary boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:42 / CP_GLOBALSCALE] } context:nil].size;
        CGFloat saleX = CPScreenWidth - CPRECOMMEND_POSITION_HORIZONTAL_MARGE - saleTextSize.width;
        CGFloat saleMarge = 0;
        CGFloat saleY = 0;
        CGFloat scale = 0.5;
        if ( [[UIDevice currentDevice].systemVersion floatValue] >= 9.0 )
            scale = 0.8;
        if( 0 < _addressFrame.size.height )
        {
            saleMarge = ( saleTextSize.height - _addressFrame.size.height ) * scale;
            saleY = _addressFrame.origin.y;
        }
        else if ( 0 < _experienceFrame.size.height )
        {
            saleMarge = ( saleTextSize.height - _experienceFrame.size.height ) * scale;
            saleY = _experienceFrame.origin.y;
        }
        else if ( 0 < _educationFrame.size.height )
        {
            saleMarge = ( saleTextSize.height - _educationFrame.size.height ) * scale;
            saleY = _educationFrame.origin.y;
        }
        else
        {
            saleMarge = ( saleTextSize.height - CPRecommendAddressWidthHeight ) * scale;
        };
        saleY -= saleMarge;
        _saleFrame = CGRectMake(saleX, saleY, saleTextSize.width, saleTextSize.height);
        totalHeight = CGRectGetMaxY(_saleFrame) + CPRECOMMEND_POSITION_VERTITAL_MARGE;
    }
#pragma mark - 新添加公司简称
    // 公司简称
    if ( nil != recommendModelCopy.Shortname && 0 < recommendModelCopy.Shortname.length )
    {
        CGSize companyTextSize = [recommendModelCopy.Shortname boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE] } context:nil].size;
        CGFloat companyX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE;
        CGFloat companyW = 0;
        CGFloat companyY = 0;
        if ( ( 0 < _addressFrame.size.height ) || ( 0 < _experienceFrame.size.height ) ||
                 ( 0 < _educationFrame.size.height ) )
        {
            CGRect maxF = CGRectGetMaxY(_addressFrame) > CGRectGetMaxY(_experienceFrame) ? _addressFrame : _experienceFrame;
            maxF = CGRectGetMaxY(maxF) > CGRectGetMaxY(_educationFrame) ? maxF : _educationFrame;
            companyY = CGRectGetMaxY(maxF) + CPRECOMMEND_POSITION_VERTITAL_SPACE / 2.0;
        }
        else
        {
            companyY = CGRectGetMaxY(_positionFrame) + CPRECOMMEND_POSITION_VERTITAL_SPACE;
        }
        if( companyTextSize.width > ( CPScreenWidth - CPRECOMMEND_POSITION_HORIZONTAL_MARGE * 2 ) )
        {
            companyW = CPScreenWidth - CPRECOMMEND_POSITION_HORIZONTAL_MARGE * 2;
        }
        else
            companyW = companyTextSize.width;
        _shortNameFrame = CGRectMake(companyX, companyY, companyW, companyTextSize.height);
        totalHeight = CGRectGetMaxY(_shortNameFrame) + CPRECOMMEND_POSITION_VERTITAL_MARGE;
    }
    // 公司名称
    if( nil != recommendModelCopy.CompanyName && 0 < recommendModelCopy.CompanyName.length )
    {
        CGSize companyTextSize = [recommendModelCopy.CompanyName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:36 / CP_GLOBALSCALE] } context:nil].size;
        CGFloat companyX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE;
        CGFloat companyW = 0;
        CGFloat companyY = 0;
        if ( ( 0 < _addressFrame.size.height ) || ( 0 < _experienceFrame.size.height ) ||
                 ( 0 < _educationFrame.size.height ) )
        {
            CGRect maxF = CGRectGetMaxY(_addressFrame) > CGRectGetMaxY(_experienceFrame) ? _addressFrame : _experienceFrame;
            maxF = CGRectGetMaxY(maxF) > CGRectGetMaxY(_educationFrame) ? maxF : _educationFrame;
            companyY = CGRectGetMaxY(maxF) + CPRECOMMEND_POSITION_VERTITAL_SPACE / 2.0;
        }
        else
        {
            companyY = CGRectGetMaxY(_positionFrame) + CPRECOMMEND_POSITION_VERTITAL_SPACE;
        }
        if( companyTextSize.width > ( CPScreenWidth - CPRECOMMEND_POSITION_HORIZONTAL_MARGE * 2 ) )
        {
            companyW = CPScreenWidth - CPRECOMMEND_POSITION_HORIZONTAL_MARGE * 2;
        }
        else
            companyW = companyTextSize.width;
        _companyFrame = CGRectMake(companyX, companyY, companyW, companyTextSize.height);
        // 如果没有简称
        if ( _shortNameFrame.size.height == 0 )
            totalHeight = CGRectGetMaxY(_companyFrame) + CPRECOMMEND_POSITION_VERTITAL_MARGE;
    }
    // 职位诱惑
    if( nil != recommendModelCopy.Welfare && 0 < recommendModelCopy.Welfare.length )
    {
//        NSString *subRegexString = @"\\w+";
        NSString *subRegexString = @"\\w+(\\+)?\\w+(\\+)?\\w*";
        NSRegularExpression *subRegex = [NSRegularExpression regularExpressionWithPattern:subRegexString options:NSRegularExpressionCaseInsensitive error:NULL];
        NSArray *regexArray = [subRegex matchesInString:recommendModelCopy.Welfare options:0 range:NSMakeRange(0, [recommendModelCopy.Welfare length])];
        // 字符串数组
        NSArray *tempArray = nil;
        NSMutableArray *tempArrayM = [NSMutableArray array];
        for ( NSTextCheckingResult *result in regexArray )
        {
            if ( result.range.length > 8 )
                continue;
            NSString *str = [recommendModelCopy.Welfare substringWithRange:result.range];
            [tempArrayM addObject:str];
        }
        if ( [tempArrayM count] > 0 )
            tempArray = [tempArrayM copy];
        if( nil != tempArray )
        {
            // 存储frame值的数组
            NSMutableArray *arrayM = [NSMutableArray array];
            CGFloat temptationX = 0;
            CGFloat temptationY = 0;
            // 遍历字符串数组
            for( int index = 0; index < tempArray.count; index++ )
            {
                NSString *tempStr = tempArray[index];
#pragma mark - 限制最多只能显示8个字
                if( tempStr.length > 8 )
                    tempStr = [tempStr substringToIndex:8];
                CGSize temptationTextSize = [tempStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:32 / CP_GLOBALSCALE] } context:nil].size;
                BOOL canBreak = NO;
                // 判断是否有公司简称和全称
                CGRect companyTempFrame = CGRectZero;
                if( _shortNameFrame.size.height > 0 )
                    companyTempFrame = _shortNameFrame;
                else if ( _companyFrame.size.height > 0 )
                    companyTempFrame = _companyFrame;
                // 针对frame数组中最后一个frame值做处理
                NSValue *arrayMLastObject = [arrayM lastObject];
                if( nil != arrayMLastObject )   // frame数组有值
                {
                    CGRect tempFrame = [arrayMLastObject CGRectValue];
                    if( ( CGRectGetMaxX(tempFrame) + CPRECOMMEND_POSITION_HORIZONTAL_SPACE + temptationTextSize.width + CPRECOMMEND_COMPTATION_HORIZONTAL_SPACE * 2 + CPRECOMMEND_POSITION_HORIZONTAL_SPACE ) > CPScreenWidth )   // 应该换行
                    {
                        canBreak = YES;
                        temptationX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE;
                        temptationY = CGRectGetMaxY(tempFrame) + CPRECOMMEND_TEMPTATION_COMPANY_VERTITAL_SPACE;
                    }
                    else    // 还没有换行
                    {
                        temptationX = CGRectGetMaxX(tempFrame) + CPRECOMMEND_COMPTATION_HORIZONTAL_SPACE;
                        temptationY = tempFrame.origin.y;
                    }
                }
                else    // frame数组没有值
                {
                    temptationX = CPRECOMMEND_POSITION_HORIZONTAL_MARGE;
                    temptationY = CGRectGetMaxY(companyTempFrame) + CPRECOMMEND_TEMPTATION_COMPANY_VERTITAL_SPACE;
                }
                // 只存储一行职位诱惑
                if( canBreak )
                    break;
                // 计算frame
                CGRect comptationFrame = CGRectMake(temptationX, temptationY, temptationTextSize.width + CPRECOMMEND_COMPTATION_HORIZONTAL_SPACE, temptationTextSize.height + 10.0);
                // 追加到数组后面
                [arrayM addObject:[NSValue valueWithCGRect:comptationFrame]];
            }
            _temptationsFrames = [arrayM copy];
            _temptations = [tempArray copy];
        }
    }
    if( nil != _temptationsFrames && 0 < _temptationsFrames.count )
    {
        NSValue *rectValue = [_temptationsFrames lastObject];
        CGRect temptationFrame = [rectValue CGRectValue];
        totalHeight = CGRectGetMaxY(temptationFrame) + CPRECOMMEND_POSITION_VERTITAL_MARGE;
    }
    // 整个职位模型数据的frame
    _totalFrame = CGRectMake(0, 0, CPScreenWidth, totalHeight);
    if ( 0 < [_temptations count] )
        _totalHeight += ( 40 + 30 + 32 ) / CP_GLOBALSCALE;
    _totalHeight += 20 / CP_GLOBALSCALE;
}
#pragma mark - 返回职位模型数据recommendModelFrame
+ (instancetype)recommendModel:(id)modelObject
{
    if( nil == modelObject )
        return nil;
    
    CPRecommendModelFrame *recommendModelFrame = [[CPRecommendModelFrame alloc] init];
    recommendModelFrame.recommendModel = modelObject;
    
    return recommendModelFrame;
}

#pragma mark - 返回frame的数组
+ (NSArray *)framesWithArray:(NSArray *)array modelClass:(__unsafe_unretained Class)modelClass
{
    if( nil == array || 0 == array.count )
        return nil;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    if([modelClass isSubclassOfClass:[JobSearchModel class]])
    {
        for(int index = 0; index < array.count; index++)
        {
            JobSearchModel *recommendModel = [JobSearchModel beanFromDictionary:array[index]];
            [arrayM addObject:[self recommendModel:recommendModel]];
        }
    }
    else if([modelClass isSubclassOfClass:[DynamicExamModelDTO class]])
    {
        for(int index = 0; index < array.count; index++)
        {
            DynamicExamModelDTO *recommendModel = [DynamicExamModelDTO beanFromDictionary:array[index]];
            [arrayM addObject:[self recommendModel:recommendModel]];
        }
    }
    else if( [modelClass isSubclassOfClass:[SaveJobDTO class]] )
    {
        for(int index = 0; index < array.count; index++)
        {
            SaveJobDTO *recommendModel = [SaveJobDTO beanFromDictionary:array[index]];
            [arrayM addObject:[self recommendModel:recommendModel]];
        }
    }
    else if( [modelClass isSubclassOfClass:[SaveCompanyModel class]] )
    {
        for(int index = 0; index < array.count; index++)
        {
            SaveCompanyModel *recommendModel = [SaveCompanyModel beanFromDictionary:array[index]];
            [arrayM addObject:[self recommendModel:recommendModel]];
        }
    }
    else if( [modelClass isSubclassOfClass:[SendReumeModel class]] )
    {
        for(int index = 0; index < array.count; index++)
        {
            SendReumeModel *recommendModel = [SendReumeModel beanFromDictionary:array[index]];
            [arrayM addObject:[self recommendModel:recommendModel]];
        }
    }
    else if ( [modelClass isSubclassOfClass:[DynamicSystemModelDTO class]] )
    {
        for(int index = 0; index < array.count; index++)
        {
            DynamicSystemModelDTO *recommendModel = [DynamicSystemModelDTO beanFromDictionary:array[index]];
            [arrayM addObject:[self recommendModel:recommendModel]];
        }
    }
    else if ( [modelClass isSubclassOfClass:[KeywordModel class]] )
    {
        for(int index = 0; index < array.count; index++)
        {
            KeywordModel *recommendModel = [KeywordModel beanFromDictionary:array[index]];
            [arrayM addObject:[self recommendModel:recommendModel]];
        }
    }
    else
        return nil;
    
    return [arrayM copy];
}

@end
