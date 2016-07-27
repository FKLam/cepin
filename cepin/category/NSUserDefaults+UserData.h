//
//  NSUserDefaults+UserData.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-24.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (UserData)

@property(assign,setter = setLoginRemanber:,getter = loginRemanber)BOOL RT_LoginNotRemanber;

@property(weak,setter = setLoginUserName:,getter = loginUserName)NSString *RT_LoginUserName;

@property(assign,setter = setLoginUserID:,getter = loginUserID)NSString *RT_LoginUserID;

@property(weak,setter = setLoginPhoneNumber:,getter = loginPhoneNumber)NSString *RT_LoginPhoneNumber;

@property(weak,setter = setLoginPassword:,getter = loginPassword)NSString *RT_LoginPassword;

@property(assign,setter = setUseTime: ,getter = useTimes)int64_t RT_UseTimes;

@property(weak,setter = setLoginToken:,getter = loginToken)NSString *RT_LoginToken;

@property(weak,setter = setAppVision:,getter = appVision)NSString *RT_AppVision;
@property(assign,setter = setAppComment:,getter = appComment)BOOL RT_AppComment;


@end
