//
//  RTDeBug.h
//  RTIM
//
/*
    请在app的Target－> Build Setting -> Apple LLVM complier 3.0 Language -> other C Flags -> Debug中添加 -DRTDEBUG
 */
//  Created by 嘉宾 唐 on 11-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#ifdef DEBUG
#define RTLog(format...) RTDebug(__FILE__, __LINE__, format)
#else
#define RTLog(format...)
#endif

#define CMD_STR NSStringFromSelector(_cmd))
#define CLS_STR  NSStringFromClass([self class])

#import <Foundation/Foundation.h>



void RTDebug(const char *fileName, int lineNumber, NSString *fmt, ...);
