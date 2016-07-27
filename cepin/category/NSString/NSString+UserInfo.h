//
//  NSString+UserInfo.h
//  cepin
//
//  Created by ceping on 15-1-21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//


@interface NSString (UserInfoAdditon)

-(BOOL)CheckNickName:(NSString**)error;
-(BOOL)CheckMobie:(NSString**)error;
-(BOOL)CheckEmail:(NSString**)error;
-(BOOL)CheckSignature:(NSString**)error;

@end
