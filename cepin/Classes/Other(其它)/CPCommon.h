//
//  CPCommon.h
//  cepin
//
//  Created by ceping on 15-11-13.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#ifndef cepin_CPCommon_h
#define cepin_CPCommon_h

#define CPRECOMMEND_POSITION_HORIZONTAL_MARGE ( 30 / CP_GLOBALSCALE )
#define CPRECOMMEND_POSITION_VERTITAL_MARGE ( 30 / CP_GLOBALSCALE )
#define CPRECOMMEND_POSITION_HORIZONTAL_SPACE ( 48.0 / CP_GLOBALSCALE )
#define CPRECOMMEND_POSITION_VERTITAL_SPACE ( 42.0 / CP_GLOBALSCALE )
#define CPRECOMMEND_COMPTATION_HORIZONTAL_SPACE ( 60 / CP_GLOBALSCALE )
#define CPRECOMMEND_COMPTATION_VERTITAL_SPACE ( 12 / CP_GLOBALSCALE )
#define CPRECOMMEND_TEMPTATION_COMPANY_VERTITAL_SPACE ( 48 / CP_GLOBALSCALE )

#define CP_IPHONE_5_STR @"iPhone5"
#define CP_IPHONE_5_1_STR @"iPhone6"
#define CP_IPHONE_6_STR @"iPhone7,1"

#define CP_IPNONE_5_DEVICE ([[NSString deviceStr] rangeOfString:( CP_IPHONE_5_STR )].length > 0)
#define CP_IPNONE_5_1_DEVICE ([[NSString deviceStr] rangeOfString:( CP_IPHONE_5_1_STR )].length > 0)
#define CP_IPNONE_6_DEVICE ([[NSString deviceStr] rangeOfString:( CP_IPHONE_6_STR )].length > 0)

#define CP_DPI_SCALE (CP_IPNONE_5_DEVICE ? ( 326 / 406.0 ) : 1.0 )

/** 屏幕的宽 */
#define CPScreenWidth [UIScreen mainScreen].bounds.size.width

/** 屏幕的高 */
#define CPScreenHeight [UIScreen mainScreen].bounds.size.height

#define CP_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define CP_SCREEN_MAX_LENGHT (MAX(CPScreenWidth, CPScreenHeight))
#define CP_IS_IPHONE_4_OR_LESS (CP_IS_IPHONE && CP_SCREEN_MAX_LENGHT < 568.0)
#define CP_IS_IPHONE_5 (CP_IS_IPHONE && CP_SCREEN_MAX_LENGHT == 568.0)
#define CP_IS_IPHONE_6 (CP_IS_IPHONE && CP_SCREEN_MAX_LENGHT == 667.0)
#define CP_IS_IPHONE_6P (CP_IS_IPHONE && CP_SCREEN_MAX_LENGHT == 736.0)

#define CP_TEMP_SCALE_6 (((2.0 * 96.0) / 72.0) * (CPScreenHeight / 667.0) )
#define CP_TEMP_SCALE_5 (((2.0 * 96.0) / 72.0) * (CPScreenHeight / 480.0) )
#define CP_GLOBALSCALE (CP_IS_IPHONE_6P ? ( (2.0 * 96.0) / 72.0 ) : (CP_IS_IPHONE_6 ? CP_TEMP_SCALE_6 : (CP_TEMP_SCALE_5)))

/** 状态栏的高度 */
#define CPStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

/** 导航栏的高度 */
#define CPNavigationBarHeight self.navigationController.navigationBar.frame.size.height

// 获得RGB颜色
#define CPColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 推荐页面薪水文字颜色
#define CPRecommendSaleColor CPColor(0xef, 0x6c, 0x00, 1.0)

// 字体的大小
#define CPFont(fontSize) [UIFont systemFontOfSize:(fontSize)]

// 推荐页发布职位时间字体大小
#define CPRecommendTimeFontSize CPFont(12.0)

// 推荐页职位名字体大小
#define CPRecommendPositionFontSize CPFont(16.0)

// 推荐页工作地址文字字体大小
#define CPRecommendAddressFontSize [[RTAPPUIHelper shareInstance] recommendWorkAddressFont]

#define CPRecommendJobNameFontSize [[RTAPPUIHelper shareInstance] recommendJobNameFont]

// 推荐页薪水文字字体大小
#define CPRecommendSaleFontSize [[RTAPPUIHelper shareInstance] bigTitleFont]

// 推荐页公司名字字体大小
#define CPRecommendCompanyFontSize [[RTAPPUIHelper shareInstance] recommendCompanyNameFont]

// 推荐页职位诱惑文字字体大小
#define CPRecommendComptationFontSize [[RTAPPUIHelper shareInstance] recommendWelfareFont]

// 推荐页简历的类型图片大小
#define CPRecommendResumeTypeWidthHeight 20.0

// 推荐页简历置顶图片大小
#define CPRecommendTopWidthHeight 22.0

// 推荐页职位地点图片大小
#define CPRecommendAddressWidthHeight ( 72 / CP_GLOBALSCALE )

// 推荐页工作年限图片大小
#define CPRecommendExperienceWidthHeight 24.0

// 推荐页职位教育水平图片大小
#define CPRecommendEducationWidthHeight 24.0

// 推荐页面薪水文字颜色
#define CPRecommendSaleColor CPColor(0xef, 0x6c, 0x00, 1.0)

// 清除缓存的通知key
#define CP_PROFILE_CLEARCACHE @"CP_PROFILE_CLEAR_CACHE"
#define CP_PROFILE_CLEARCACHE_COMFIRT @"CP_PROFILE_CLEARCACHE_COMFIRT"

// 保存期望工作的通知key
#define CP_EXPECTED_WORK @"CP_EXPECTED_WORK"
#define CP_EXPECTED_WORK_SAVE @"CP_EXPECTED_WORK_SAVE"

// 切换默认简历的通知key
#define CP_DEFAULT_RESUME @"CP_DEFAULT_RESUME"
#define CP_DEFAULT_RESUME_CHANGE @"CP_DEFAULT_RESUME_CHANGE"

// 切换用户的通知key
#define CP_ACCOUNT_CHANGE @"CP_ACCOUNT_CHANGE"
#define CP_ACCOUNT_CHANGE_VALUE @"CP_ACCOUNT_CHANGE_VALUE"

#define CP_ACCOUNT_LONGIN @"CP_ACCOUNT_LONGIN"
#define CP_ACCOUNT_LONGIN_VALUE @"CP_ACCOUNT_LONGIN_VALUE"
#endif
