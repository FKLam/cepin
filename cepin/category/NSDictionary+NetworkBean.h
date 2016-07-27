//
//  NSDictionary+NetworkBean.h
//  letsgo
//
//  Created by Ricky Tang on 14-8-1.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NetworkBean)

-(BOOL)resultSucess;

-(id)resultObject;

-(BOOL)isMustAutoLogin;

-(id)resultErrorMessage;

-(id)resultErrorCode;

-(id)resultObjectToBeanWithClass:(Class)class;

- (id)resultMessage;
@end
