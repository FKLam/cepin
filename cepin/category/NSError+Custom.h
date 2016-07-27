//
//  NSError+Custom.h
//  letsgo
//
//  Created by Ricky Tang on 14-8-6.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const ErrorKey;

typedef enum {
    
    ErrorTypeMobile = 3000,
    ErrorTypeEmail,
    ErrorTypeMobileNotSiginUp,
    ErrorTypeMobileSiginUp,
    ErrorTypeCheckCode,
    ErrorTypePassword,
    ErrorTypeLost,
    ErrorTypeAuthCode,
    ErrorTypeNoNet,
    ErrorTypeLocationLost
    
}ErrorType;

@interface NSError (Custom)
+(NSError *)errorWithErrorType:(ErrorType)type;

+(NSError *)errorWithErrorMessage:(NSString *)message;
@end
