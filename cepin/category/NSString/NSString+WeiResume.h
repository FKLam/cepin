//
//  NSString+WeiResume.h
//  cepin
//
//  Created by ceping on 15-1-9.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WeiResumeAddtion)
// 验证身份证号合法性
- (BOOL)checkIdentityCard:(NSString **)error;
-(BOOL)CheckResumeName:(NSString**)error;
-(BOOL)CheckResumeChineseName:(NSString**)error;
-(BOOL)CheckResumeSchoolName:(NSString**)error;
-(BOOL)CheckResumeMajorName:(NSString**)error;
-(BOOL)CheckResumeUserRemarkName:(NSString**)error;
-(BOOL)CheckResumeSchoolId:(NSString**)error;
-(BOOL)CheckResumeMajorKey:(NSString**)error;
-(BOOL)CheckResumeDegreeKey:(NSString**)error;
-(BOOL)CheckResumePhone:(NSString**)error;
-(BOOL)CheckResumeEmail:(NSString**)error;
-(BOOL)CheckResumeCity:(NSString**)error;
-(BOOL)CheckResumeGredute:(NSString**)error;
-(BOOL)CheckUserName:(NSString**)error;
-(BOOL)CheckRealName:(NSString**)error;
-(BOOL)CheckResumeWorkYear:(NSString**)error;
-(BOOL)CheckResumeRegin:(NSString**)error;
-(BOOL)CheckResumeValid;
- (BOOL)checkResumeQQ:(NSString **)error;
- (BOOL)checkResumeCode:(NSString **)error;
- (BOOL)checkResumeContact:(NSString **)error;
@end
