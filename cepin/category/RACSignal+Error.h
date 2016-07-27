//
//  RACSignal+Error.h
//  cepin
//
//  Created by Ricky Tang on 14-11-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RACSignal.h"

@interface RACSignal (Error)

+(RACSignal *)mobileSignalWithMobile:(NSString *)mobile;

+(RACSignal *)emailSignalWithEmail:(NSString *)email;

+(RACSignal *)passwordSignalWithPassword:(NSString *)password;

+(RACSignal *)loginCheckWithEmail:(NSString *)email password:(NSString *)password netSignal:(RACSignal *)signal;
@end
