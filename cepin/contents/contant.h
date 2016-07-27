//
//  NSObject_contant.h
//  RTPlaneMoving
//
//  Created by 嘉宾 唐 on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



#import "RTDeBug.h"
#import "Define.h"



#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height >= 568)
#define IPHONE_5_ADD_HEIGHT 88

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

#define CREATE_XIB_WITH_STRING(xibName,myOwner) [[[NSBundle mainBundle] loadNibNamed:xibName owner:myOwner options:nil] objectAtIndex:0]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define APP_DOCUMENT_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define APP_TEMP_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"temp"]
#define APP_LIBRARY_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
#define APP_LIBRARY_CACHES_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]


#define USERACCOUNTPAth @"userAccountPath"
#define IsIOS8 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8)
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define CGRECT_NO_NAV(x,y,w,h) CGRectMake((x), (y+(IsIOS7?20:0)), (w), (h))
#define CGRECT_HAVE_NAV(x,y,w,h) CGRectMake((x), (y+(IsIOS7?0:-64)), (w), (h))

#define UIIMAGE(name) [UIImage imageNamed:name]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorWithRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define UISystemFont(size) [UIFont systemFontOfSize:size]
#define StringSize(string,fontSize) [string sizeWithFont:UISystemFont(fontSize)]
//[string sizeWithFont:font]
#define StringFontSize(string,font) [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
#define StringSizeH(string,fontSize,width) ([string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil] context:nil].size.height)
//[string sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height
#define StringFontSizeH(string,font,width) ([string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil] context:nil].size.height)

#define StrMultiRowSize(string,fontSize,width) ([string sizeWithFont:UISystemFont(fontSize) constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping])

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

#define imagehight  IS_IPHONE_5?18:22

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) (x)
#define AH_RELEASE(x) (void)(x)
#define AH_COPY(x) (x);
#define AH_AUTORELEASE(x) (x)
#define AH_SUPER_DEALLOC (void)(0)
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [(x) retain]
#define AH_RELEASE(x) [(x) release]
#define AH_COPY(x) [(x) copy];
#define AH_AUTORELEASE(x) [(x) autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#endif
#endif

//  Weak reference support  __IPHONE_4_3

#ifndef AH_WEAK
#if defined __IPHONE_OS_VERSION_MIN_REQUIRED
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_7_0
#define __AH_WEAK __weak
#define AH_WEAK weak
#else
#define __AH_WEAK __unsafe_unretained
#define AH_WEAK unsafe_unretained
#endif
#elif defined __MAC_OS_X_VERSION_MIN_REQUIRED
#if __MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_6
#define __AH_WEAK __weak
#define AH_WEAK weak
#else
#define __AH_WEAK __unsafe_unretained
#define AH_WEAK unsafe_unretained
#endif
#endif
#endif

//  ARC Helper ends

