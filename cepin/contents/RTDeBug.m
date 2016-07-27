//
//  RTDeBug.m
//  RTIM
//
//  Created by 嘉宾 唐 on 11-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RTDeBug.h"

void RTDebug(const char *fileName, int lineNumber, NSString *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    
    static NSDateFormatter *debugFormatter = nil;
    if (debugFormatter == nil) {
        debugFormatter = [[NSDateFormatter alloc] init];
        [debugFormatter setDateFormat:@"yyyyMMdd.HH:mm:ss"];
    }
    
    /*if (![fmt isMemberOfClass:[NSObject class]]) {
        return;
    }*/
    
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    NSString *filePath = [[NSString alloc] initWithUTF8String:fileName];    
    NSString *timestamp = [debugFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [info objectForKey:(NSString *)kCFBundleNameKey];
    fprintf(stdout, "%s %s[%s, line : %d] %s\n",
            [timestamp UTF8String],
            [appName UTF8String],
            [[filePath lastPathComponent] UTF8String],
            lineNumber,
            [msg UTF8String]);
    
    va_end(args);
    AH_RELEASE(msg);
    AH_RELEASE(filePath);
}


