//
//  CPRecommendCell.m
//  cepin
//
//  Created by ceping on 15/11/19.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CPRecommendCell.h"
#import "CPRecommendModelFrame.h"
#import "JobSearchModel.h"
#import "CPCommon.h"
#import "NSString+Extension.h"
#import "NSDate-Utilities.h"

@implementation CPRecommendCell
{
    UIImageView *contentBGView;
    BOOL drawed;
    NSInteger drawColorFlag;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        contentBGView = [[UIImageView alloc] initWithFrame:CGRectZero];
        contentBGView.backgroundColor = [UIColor whiteColor];
        [self.contentView insertSubview:contentBGView atIndex:0];
    }
    return self;
}

/**
 *  recommendModelFrame的setter方法
 *
 */
- (void)setRecommendModelFrame:(CPRecommendModelFrame *)recommendModelFrame
{
    _recommendModelFrame = recommendModelFrame;
    
}

#pragma mark - 创建一个cell
+ (instancetype)recommendCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"recommendCellIdentifier";
    CPRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if( nil == recommendCell )
    {
        recommendCell = [[CPRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return recommendCell;
}

// 将主要内容绘制到图片上
 - (void)draw
{
    if( drawed )
        return;
    
    drawed = YES;
    NSInteger flag = drawColorFlag;
    
    // 异步绘制
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 取出职位模型
        JobSearchModel *recommendModel = _recommendModelFrame.recommendModel;
        
        CGRect rect = _recommendModelFrame.totalFrame;
        rect.size.height += 1.5;
        
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        
        // 获取上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // 整个内容的背景
        [[UIColor whiteColor] set];
        CGContextFillRect(context, rect);
        
        // 职位名
        if( nil != recommendModel.PositionName )
        {
            if( !_recommendModelFrame.isCheck )
            {
#pragma mark - 职位名自动换行
                [recommendModel.PositionName drawInContext:context withPosition:_recommendModelFrame.positionFrame.origin andColor:[[RTAPPUIHelper shareInstance] mainTitleColor] andFont:CPRecommendJobNameFontSize andHeight:_recommendModelFrame.positionFrame.size.height andWidth:_recommendModelFrame.positionFrame.size.width];
            }
            else
            {
                [recommendModel.PositionName drawInContext:context withPosition:_recommendModelFrame.positionFrame.origin andColor:[[RTAPPUIHelper shareInstance] subTitleColor] andFont:CPRecommendJobNameFontSize andHeight:_recommendModelFrame.positionFrame.size.height andWidth:_recommendModelFrame.positionFrame.size.width];
            }
            
            CGFloat x = CGRectGetMaxX(_recommendModelFrame.positionFrame);
            
#pragma mark - 适配校招和置顶图标
            CGFloat y = 0;
            if ( CP_IPNONE_6_DEVICE && [[UIDevice currentDevice] systemVersion].floatValue < 9.0 )
            {
                y = self.recommendModelFrame.positionFrame.origin.y + fabs( _recommendModelFrame.positionSize.height - CPRecommendTopWidthHeight ) * 7 / 4.0;
            }
            else if ( CP_IPNONE_5_DEVICE || CP_IPNONE_5_1_DEVICE || [[UIDevice currentDevice] systemVersion].floatValue >= 9.0 )
            {
                y = fabs( _recommendModelFrame.positionSize.height - CPRecommendTopWidthHeight ) / 2.0 + CPRecommendTopWidthHeight / 2.0;
            }
            else
            {   // 模拟器
                y = fabs( _recommendModelFrame.positionSize.height - CPRecommendTopWidthHeight ) / 2.0 + CPRecommendTopWidthHeight / 2.0;
            }
            
            if( _recommendModelFrame.positionFrame.size.height > _recommendModelFrame.positionSize.height )
            {
                CGFloat marge = _recommendModelFrame.positionSize.width - _recommendModelFrame.maxMarge;
//                x = marge + CPRECOMMEND_POSITION_HORIZONTAL_MARGE;
                x = marge + 10;
                
#pragma mark - 适配校招和置顶图标
                if ( CP_IPNONE_6_DEVICE && [[UIDevice currentDevice] systemVersion].floatValue < 9.0)
                {
                    y = CGRectGetMaxY(_recommendModelFrame.positionFrame) - CPRecommendTopWidthHeight / 2.0;
                }
                else if ( CP_IPNONE_5_DEVICE || CP_IPNONE_5_1_DEVICE || [[UIDevice currentDevice] systemVersion].floatValue >= 9.0 )
                {
                    y = CGRectGetMaxY(_recommendModelFrame.positionFrame) - CPRecommendTopWidthHeight / 2.0 - CPRECOMMEND_POSITION_VERTITAL_MARGE / 4.0;
                }
                else
                {
                    y = CGRectGetMaxY(_recommendModelFrame.positionFrame) - CPRecommendTopWidthHeight / 2.0 - CPRECOMMEND_POSITION_VERTITAL_MARGE / 4.0;
                }
            }
            
            CGContextSaveGState(context);
            
            if( 2 != recommendModel.PositionType.intValue ) // 校招
            {
//                x += CPRECOMMEND_POSITION_HORIZONTAL_SPACE;
                x += 10.0;
//                x += 3.0;
                
                UIGraphicsPushContext(context);
                
                NSString *schoolPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"list_ic_edutab.png"];
                UIImage *schoolImage = [UIImage imageWithContentsOfFile:schoolPath];
                [schoolImage drawInRect:CGRectMake(x, y, CPRecommendTopWidthHeight, CPRecommendTopWidthHeight) blendMode:kCGBlendModeNormal alpha:1];
                
                UIGraphicsPopContext();
                
                x += CPRecommendTopWidthHeight;
            }
            
            if( 0 != recommendModel.IsTop.intValue ) // 置顶
            {
//                x += CPRECOMMEND_POSITION_HORIZONTAL_SPACE;
                x += 10.0;
                
                UIGraphicsPushContext(context);
                NSString *topPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"list_ic__totop.png"];
                UIImage *topImage = [UIImage imageWithContentsOfFile:topPath];
                [topImage drawInRect:CGRectMake(x, y, CPRecommendTopWidthHeight, CPRecommendTopWidthHeight) blendMode:kCGBlendModeNormal alpha:1];
                UIGraphicsPopContext();
            }
            
            CGContextRestoreGState(context);
            
        }
        
        // 职位发布日期
        if( nil != recommendModel.PublishDate )
        {
            [[NSDate cepinJobYearMonthDayFromString:recommendModel.PublishDate] drawInContext:context withPosition:_recommendModelFrame.timeFrame.origin andFont:[[RTAPPUIHelper shareInstance] recommendJobPublishTimeFont] andTextColor:[[RTAPPUIHelper shareInstance] subTitleColor] andHeight:_recommendModelFrame.timeFrame.size.height andWidth:_recommendModelFrame.timeFrame.size.width];
        }
        
        // 职位工作地点
        if( nil != recommendModel.City )
        {
            [recommendModel.City drawInContext:context withPosition:CGPointMake(_recommendModelFrame.addressFrame.origin.x - 5, _recommendModelFrame.addressFrame.origin.y) andFont:CPRecommendAddressFontSize andTextColor:[[RTAPPUIHelper shareInstance] subTitleColor] andHeight:_recommendModelFrame.addressFrame.size.height andWidth:_recommendModelFrame.addressFrame.size.width];
            
            CGFloat addressX = _recommendModelFrame.addressFrame.origin.x - 15 / 2.0 * 3;
            CGFloat addressY = 0;
            
            if ( CP_IPNONE_6_DEVICE && [[UIDevice currentDevice] systemVersion].floatValue < 9.0 )
            {
                addressY = _recommendModelFrame.addressFrame.origin.y;
            }
            else if ( CP_IPNONE_5_DEVICE || CP_IPNONE_5_1_DEVICE || [[UIDevice currentDevice] systemVersion].floatValue >= 9.0 )
            {
                addressY = _recommendModelFrame.addressFrame.origin.y - 15 / 4.0;
            }
            else
            {
                addressY = _recommendModelFrame.addressFrame.origin.y - 15 / 4.0;
            }
            
            NSString *addressPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"list_ic_location_s.png"];
            UIImage *addressImage =  [UIImage imageWithContentsOfFile:addressPath];
            
            CGContextSaveGState(context);
            UIGraphicsPushContext(context);
            [addressImage drawInRect:CGRectMake(addressX, addressY, 15, 15) blendMode:kCGBlendModeNormal alpha:1.0];
            UIGraphicsPopContext();
            CGContextRestoreGState(context);
        }
        
        // 工作年限
        if( nil != recommendModel.WorkYear  && 0 < recommendModel.WorkYear.length )
        {
            [recommendModel.WorkYear drawInContext:context withPosition:CGPointMake(_recommendModelFrame.experienceFrame.origin.x - 5, _recommendModelFrame.experienceFrame.origin.y) andFont:CPRecommendAddressFontSize andTextColor:[[RTAPPUIHelper shareInstance] subTitleColor] andHeight:_recommendModelFrame.experienceFrame.size.height andWidth:_recommendModelFrame.experienceFrame.size.width];
            
            CGFloat experienceX = _recommendModelFrame.experienceFrame.origin.x - 15 / 2.0 * 3;
            CGFloat experienceY = 0;
            
            if ( CP_IPNONE_6_DEVICE && [[UIDevice currentDevice] systemVersion].floatValue < 9.0 )
            {
                experienceY = _recommendModelFrame.experienceFrame.origin.y;
            }
            else if ( CP_IPNONE_5_DEVICE || CP_IPNONE_5_1_DEVICE || [[UIDevice currentDevice] systemVersion].floatValue >= 9.0)
            {
                experienceY = _recommendModelFrame.experienceFrame.origin.y - 15 / 4.0;
            }
            else
            {
                experienceY = _recommendModelFrame.experienceFrame.origin.y - 15 / 4.0;
            }
            
            CGContextSaveGState(context);
            UIGraphicsPushContext(context);
            NSString *experiencePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"list_ic_history_s.png"];
            UIImage *experienceImage = [UIImage imageWithContentsOfFile:experiencePath];
            [experienceImage drawInRect:CGRectMake(experienceX, experienceY, 15, 15) blendMode:kCGBlendModeNormal alpha:1.0];
            UIGraphicsPopContext();
            CGContextRestoreGState(context);
        }
        
        // 教育水平
        if( nil != recommendModel.EducationLevel )
        {
            NSString *educationStr = [recommendModel.EducationLevel substringToIndex:2];
            NSRange range = [recommendModel.EducationLevel rangeOfString:@"EMBA"];
            if ( range.length > 0 )
                educationStr = [recommendModel.EducationLevel substringToIndex:4];
            else if ( [recommendModel.EducationLevel rangeOfString:@"MBA"].length > 0 )
                educationStr = [recommendModel.EducationLevel substringToIndex:3];
            
            if ( ![educationStr isEqualToString:@"不限"] && recommendModel.EducationLevel.length > 2 && ![educationStr isEqualToString:@"MBA"] && ![educationStr isEqualToString:@"EMBA"])
                educationStr = [NSString stringWithFormat:@"%@...", educationStr];
            
            [educationStr drawInContext:context withPosition:CGPointMake(_recommendModelFrame.educationFrame.origin.x - 5, _recommendModelFrame.educationFrame.origin.y) andFont:CPRecommendAddressFontSize andTextColor:[[RTAPPUIHelper shareInstance] subTitleColor] andHeight:_recommendModelFrame.educationFrame.size.height andWidth:_recommendModelFrame.educationFrame.size.width];
            
            CGFloat educationX = _recommendModelFrame.educationFrame.origin.x - 15 / 2.0 * 3;
            CGFloat educationY = 0;
            
            if ( CP_IPNONE_6_DEVICE && [[UIDevice currentDevice] systemVersion].floatValue < 9.0 )
            {
                educationY = _recommendModelFrame.educationFrame.origin.y;
            }
            else if ( CP_IPNONE_5_DEVICE || CP_IPNONE_5_1_DEVICE || [[UIDevice currentDevice] systemVersion].floatValue >= 9.0)
            {
                educationY = _recommendModelFrame.educationFrame.origin.y - 15 / 4.0;
            }
            else
            {
                educationY = _recommendModelFrame.educationFrame.origin.y - 15 / 4.0;
            }
            
            CGContextSaveGState(context);
            UIGraphicsPushContext(context);
            NSString *educationPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"list_ic_graduationhat.png"];
            UIImage *educationImaga = [UIImage imageWithContentsOfFile:educationPath];
            [educationImaga drawInRect:CGRectMake(educationX, educationY, 15, 15) blendMode:kCGBlendModeNormal alpha:1.0];
            UIGraphicsPopContext();
            CGContextRestoreGState(context);
        }
        
        // 职位薪水
        if( nil != recommendModel.Salary )
        {
            [recommendModel.Salary drawInContext:context withPosition:_recommendModelFrame.saleFrame.origin andFont:CPRecommendSaleFontSize andTextColor:CPRecommendSaleColor andHeight:_recommendModelFrame.saleFrame.size.height andWidth:_recommendModelFrame.saleFrame.size.width];
            
        }
        
#pragma mark - 修改优先显示公司简称
        // 公司简称
        if ( nil != recommendModel.Shortname )
        {
            if( !_recommendModelFrame.isCheck )
            {
                [recommendModel.Shortname drawInContext:context withPosition:_recommendModelFrame.shortNameFrame.origin andFont:CPRecommendCompanyFontSize andTextColor:[[RTAPPUIHelper shareInstance] companyColor] andHeight:_recommendModelFrame.shortNameFrame.size.height andWidth:_recommendModelFrame.shortNameFrame.size.width];
            }
            else
            {
                [recommendModel.Shortname drawInContext:context withPosition:_recommendModelFrame.shortNameFrame.origin andFont:CPRecommendCompanyFontSize andTextColor:[[RTAPPUIHelper shareInstance] subTitleColor] andHeight:_recommendModelFrame.shortNameFrame.size.height andWidth:_recommendModelFrame.shortNameFrame.size.width];
            }
        }
        // 公司名字
        else if( nil != recommendModel.CompanyName )
        {
            if( !_recommendModelFrame.isCheck )
            {
                [recommendModel.CompanyName drawInContext:context withPosition:_recommendModelFrame.companyFrame.origin andFont:CPRecommendCompanyFontSize andTextColor:[[RTAPPUIHelper shareInstance] companyColor] andHeight:_recommendModelFrame.companyFrame.size.height andWidth:_recommendModelFrame.companyFrame.size.width];
            }
            else
            {
                [recommendModel.CompanyName drawInContext:context withPosition:_recommendModelFrame.companyFrame.origin andFont:CPRecommendCompanyFontSize andTextColor:[[RTAPPUIHelper shareInstance] subTitleColor] andHeight:_recommendModelFrame.companyFrame.size.height andWidth:_recommendModelFrame.companyFrame.size.width];
            }
        }
        
        // 职位诱惑
        if( nil != recommendModel.Welfare )
        {
            CGFloat dashPattern[] = { 1, 1 };
            
            //  存储图形上下文
            CGContextSaveGState(context);
            
            for( int index = 0; index < _recommendModelFrame.temptationsFrames.count; index++ )
            {
                NSString *temptationStr = _recommendModelFrame.temptations[index];
                
#pragma mark - 限制最多显示8个字
                if ( temptationStr.length > 8 )
                    temptationStr = [temptationStr substringToIndex:8];
                
                CGRect temptationFrame = [_recommendModelFrame.temptationsFrames[index] CGRectValue];
                
                [temptationStr drawInContext:context withPosition:temptationFrame.origin andFont:CPRecommendComptationFontSize andTextColor:[[RTAPPUIHelper shareInstance] subTitleColor] andHeight:temptationFrame.size.height andWidth:temptationFrame.size.width];
                
                // 创建路径
                CGMutablePathRef path = CGPathCreateMutable();
                
                CGFloat tempMarge = temptationFrame.origin.y;
                
#pragma mark - 适配职位诱惑文字
                if ( CP_IPNONE_6_DEVICE )
                {
                    tempMarge = temptationFrame.origin.y - temptationFrame.size.height / 4.0;
                }
                else if ( CP_IPNONE_5_1_DEVICE || CP_IPNONE_5_DEVICE )
                {
                    tempMarge = temptationFrame.origin.y - temptationFrame.size.height / 3.0;
                }
                else
                {
                    tempMarge = temptationFrame.origin.y - temptationFrame.size.height / 3.0;
                }
                
                
                temptationFrame.origin.y = tempMarge;
                
//                NSLog(@"%f", temptationFrame.size.height );
//                if( CPIHONE_5 )
//                    temptationFrame.origin.y -= temptationFrame.size.height / 3.0;
//                else if ( CPIHONE_6 )
//                    temptationFrame.origin.y -= temptationFrame.size.height / 5.0;
                
                // 将矩形添加到路径中
                CGPathAddRect(path, NULL, temptationFrame);
                
                // 添加路径到上下文
                CGContextAddPath(context, path);
                
                // 矩形边框颜色
                [[UIColor blackColor] setStroke];
                
                // 边框宽度
                CGContextSetLineWidth(context, 0.25);
                
                // 设置为虚线
                CGContextSetLineDash(context, 0, dashPattern, 2);
                
                // 绘制
                CGContextDrawPath(context, kCGPathStroke);
                
                // 释放路径
                CGPathRelease(path);
            }
            
            // 还原图形上下文
            CGContextRestoreGState(context);
        }
        
        
        // 绘制分割线
        
        CGContextSaveGState(context);
        
        CGContextSetLineWidth(context, 3.0);
        [CPColor(0xf0, 0xef, 0xf5, 1.0) set];
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 0.0, rect.size.height - 1.5);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1.5);
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
        
        UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( flag != drawColorFlag )
                return;
            contentBGView.frame = rect;
            contentBGView.image = nil;
            contentBGView.image = temp;
        });
        
    });
}

- (void)clear
{
    if( !drawed )
        return;
    
    contentBGView.frame = CGRectZero;
    contentBGView.image = nil;
    
    drawColorFlag = arc4random();
    drawed = NO;
}

- (void)releaseMemory{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self clear];
    [super removeFromSuperview];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"postview dealloc %@", self);
}

@end
