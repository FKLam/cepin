//
//  NSString+Addition.h
//  yanyu
//
//  Created by rickytang on 13-10-5.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)
-(BOOL)checkTextBlank;

-(BOOL)checkEmailText;

-(BOOL)checkMobileText;

-(BOOL)checkPasswordText;

-(BOOL)isIncludeSpecialCharact;
@end
