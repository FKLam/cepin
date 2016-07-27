//
//  RTAPPUIHelper.h
//  Daishu
//
//  Created by Ricky Tang on 14-3-17.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
#define CP_EDUCATION_HEIGHT 70.0
#define CP_LEARN_HEIGHT 70.0
#define CP_RECOMMEND_SCALE ([UIScreen mainScreen].scale * 0.8)
@class FUILineButton;
typedef enum {
    kRightButtonTypeModify,
    kRightButtonTypeTarget,
}kRightButtonType;

@interface RTAPPUIHelper : NSObject

+(id)shareInstance;

+(void)appearence;

@property(nonatomic,readonly,strong)UIColor *backgroundColor;  //大背景的颜色

@property(nonatomic,readonly,strong)UIColor *whiteColor;   //白色
@property(nonatomic,readonly,strong)UIColor *transparentWhiteColor;  //半透明白色
@property(nonatomic,readonly,assign)CGFloat lineWidth;    //定义线条的宽度
@property(nonatomic,readonly,strong)UIColor *lineColor;   //定义线条的颜色
@property(nonatomic,readonly,assign)CGFloat cornerRadius;  //定义圆角的值

@property(nonatomic,strong,readonly)UIColor *shadeColor;//阴影颜色
@property(nonatomic,readonly,strong)UIColor *grapColor;
@property(nonatomic,readonly,strong)UIColor *darkGrayColor;
@property(nonatomic,readonly,strong)UIColor *greenColor;
@property(nonatomic,readonly,strong)UIColor *blueColor;   //蓝色用于section的颜色，例如职位详情的栏目的背景色
@property(nonatomic,readonly,strong)UIColor *lightBlueColor;    //用户cell主题的背景颜色,例如职位详情中的灰色block背景色
@property(nonatomic,readonly,strong)UIColor *redColor;
@property(nonatomic,readonly,strong)UIColor *darkRedColor;

@property(nonatomic,readonly,strong)UIColor *orangeColor;

@property(nonatomic,readonly,strong)UIFont *bigTitleFont; //主要字体颜色，黑色15
/** 推荐页公司名称字体的大小 */
@property (nonatomic, readonly, strong) UIFont *recommendCompanyNameFont;
/** 推荐页职位名称字体的大小 */
@property (nonatomic, strong, readonly) UIFont *recommendJobNameFont;
/** 推荐页职位诱惑字体的大小 */
@property (nonatomic, strong, readonly) UIFont *recommendWelfareFont;
/** 推荐页工作地址字体的大小 */
@property (nonatomic, strong, readonly) UIFont *recommendWorkAddressFont;
/** 推荐页位置发布的时间字体的大小 */
@property (nonatomic, strong, readonly) UIFont *recommendJobPublishTimeFont;
/** 推荐页每一块标题字体的大小 */
@property (nonatomic, strong, readonly) UIFont *recommendBlockTitleFont;
/** 详情页职位详情标题字体大小 */
@property (nonatomic, strong, readonly) UIFont *jobInformationTitleFont;
/** 详情页职位详情职位名称字体大小 */
@property (nonatomic, strong, readonly) UIFont *jobInformationPositionFont;
/** 详情页职位详情薪水字体大小 */
@property (nonatomic, strong, readonly) UIFont *jobInformationSaleFont;
/** 详情页职位详情detaill字体大小 */
@property (nonatomic, strong, readonly) UIFont *jobInformationDetaillFont;
/** 详情页职位详情公司名字体大小 */
@property (nonatomic, strong, readonly) UIFont *jobInformationCompanyFont;
/** 详情页职位详情职位描述标题字体大小 */
@property (nonatomic, strong, readonly) UIFont *jobInformationPositionDetailFont;
/** 详情页职位详情职位描述字体大小 */
@property (nonatomic, strong, readonly) UIFont *jobInformationPositionDetailContentFont;
/** 详情页职位详情投递按钮字体大小 */
@property (nonatomic, strong, readonly) UIFont *jobInformationDeliverButtonFont;
/** 详情页职位详情诱惑字体大小 */
@property (nonatomic, strong, readonly) UIFont *jobInformationTemptationFont;
/** 详情页企业详情企业名字字体大小 */
@property (nonatomic, strong, readonly) UIFont *companyInformationNameFont;
/** 详情页企业详情企业文化字体大小 */
@property (nonatomic, strong, readonly) UIFont *companyInformationIndustryFont;
/** 详情页企业详情企业规模字体大小 */
@property (nonatomic, strong, readonly) UIFont *companyInformationNatureFont;
/** 详情页企业详情公司简介标题字体大小 */
@property (nonatomic, strong, readonly) UIFont *companyInformationIntroduceTitleFont;
/** 详情页企业详情公司简介字体大小 */
@property (nonatomic, strong, readonly) UIFont *companyInformationIntroduceFont;

/** 搜索页搜索结果头部提示字体大小 */
@property (nonatomic, strong, readonly) UIFont *searchResultTipsHeadFont;
/** 搜索页搜索结果尾部提示字体大小 */
@property (nonatomic, strong, readonly) UIFont *searchResultTipsEndFont;

/** 搜索页高级筛选cell字体大小 */
@property (nonatomic, strong, readonly) UIFont *searchResultSubFont;
/** 搜索页高级筛选cell字体颜色 */
@property (nonatomic, strong, readonly) UIColor *searchResultSubColor;

/** 我页我的简历－简历名称字体大小 */
@property (nonatomic, strong, readonly) UIFont *profileResumeNameFont;
/** 我页我的简历－简历名称字体颜色 */
@property (nonatomic, strong, readonly) UIColor *profileResumeNameColor;

/** 我页我的简历－简历状态字体大小 */
@property (nonatomic, strong, readonly) UIFont *profileResumeStatueFont;
/** 我页我的简历－简历状态字体颜色 */
@property (nonatomic, strong, readonly) UIColor *profileResumeStatueColor;

/** 我页我的简历－简历消息字体大小 */
@property (nonatomic, strong, readonly) UIFont *profileResumeMessageFont;
/** 我页我的简历－简历消息字体颜色 */
@property (nonatomic, strong, readonly) UIColor *profileResumeMessageColor;

/** 我页我的简历－更多下的文字字体大小 */
@property (nonatomic, strong, readonly) UIFont *profileResumeOperationFont;

/** 我页－基本信息左边静态文本字体大小 */
@property (nonatomic, strong, readonly) UIFont *profileBaseInformatonFont;
/** 我页－基本信息左边静态文本字体颜色 */
@property (nonatomic, strong, readonly) UIColor *profileBaseInformatonColor;

/** 我页－基本信息右边输入文本的字体大小 */
@property (nonatomic, strong, readonly) UIFont *profileBaseInformationRFont;
/** 我页－基本信息右边输入文本的字体颜色 */
@property (nonatomic, strong, readonly) UIColor *profileBaseInformationRColor;



/** 我页姓名文字字体大小 */
@property (nonatomic, strong, readonly) UIFont *profileNameFont;
/** 我页姓名文字字体颜色 */
@property (nonatomic, strong, readonly) UIColor *profileNameColor;

@property(nonatomic,readonly,strong)UIColor *mainTitleColor; //主要字体颜色，黑色
@property(nonatomic,readonly,strong)UIFont *mainTitleFont;  //主要字体大小12
@property(nonatomic,readonly,strong)UIColor *subTitleColor; //次要字体颜色
@property(nonatomic,readonly,strong)UIFont *subTitleFont;   //次要字体大小9
@property(nonatomic,readonly,strong)UIFont *titleFont;   //字体的大小11
@property(nonatomic,readonly,strong)UIColor *orangeWordColor;  //字体的颜色
@property(nonatomic,readonly,strong)UIColor *blueWordColor;
@property(nonatomic,readonly,strong)UIFont *blueWordFont;
@property (nonatomic, readonly, strong) UIColor *companyColor;  // 公司名称字体颜色

@property(nonatomic,readonly,strong)UIFont *lessWordsFont;

@property(nonatomic,readonly,strong)UIColor *linkedWordsColor;
@property(nonatomic,readonly,strong)UIFont *linkedWordsFont;

@property(nonatomic,readonly,strong)UIFont *buttonFont;
@property(nonatomic,readonly,strong)UIColor *buttonColor;
@property(nonatomic,readonly,strong)UIColor *buttonHightedColor;
@property(nonatomic,readonly,strong)UIColor *buttonEnableColor;

@property(nonatomic,readonly,strong)UIColor *buttonGrayColor;
@property(nonatomic,readonly,strong)UIColor *buttonHightedGrayColor;

@property(nonatomic,readonly,strong)UIColor *buttonGreenColor;
@property(nonatomic,readonly,strong)UIColor *buttonHightedGreenColor;


@property(nonatomic,readonly,strong)UIColor *labelColorBlue;
@property(nonatomic,readonly,strong)UIColor *labelColorGreen;
@property(nonatomic,readonly,strong)UIColor *labelColorOrange;
@property(nonatomic,readonly,strong)UIColor *labelColorRed;
@property(nonatomic,readonly,strong)UIColor *labelColorPurple;

+(NSArray *)labelColors;

+(FUILineButton *)loginMainButtonWithButton:(FUILineButton *)btn;


+(UIBarButtonItem *)rightBarButtonWithTitle:(NSString *)title;

+(UIBarButtonItem *)rightBarButtonWithType:(kRightButtonType)type;

+(UIBarButtonItem *)backBarButtonWith:(id)target selector:(SEL)selector;

+(UIBarButtonItem *)backBarButtonWithBlock:(void(^)(id sender))block;

+(UIBarButtonItem *)backBarButton;

+(UIView *)initTitleWith:(id)target selector:(SEL)selector parentView:(UIView*)view title:(NSString*)title;
@end
