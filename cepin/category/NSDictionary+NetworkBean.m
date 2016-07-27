//
//  NSDictionary+NetworkBean.m
//  letsgo
//
//  Created by Ricky Tang on 14-8-1.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "NSDictionary+NetworkBean.h"
#import "JsonModel.h"
#import "AutoLoginVM.h"
@interface NSDictionary ()
@property (nonatomic, strong) AutoLoginVM *viewModel;
@end
@implementation NSDictionary (NetworkBean)
- (id)resultMessage
{
    return[self objectForKey:@"Message"];
}
-(BOOL)resultSucess
{
    return [[self objectForKey:@"Status"] boolValue];
}

-(id)resultObject
{
    return [self objectForKey:@"Data"];
}

-(id)resultErrorMessage
{
    return[self objectForKey:@"ErrorMessage"];
}

-(id)resultErrorCode
{
    return [self objectForKey:@"ErrorCode"];
}

-(BOOL)isMustAutoLogin
{
    NSNumber *number = [self objectForKey:@"ErrorCode"];
    if (number.intValue == 1000)
    {
//        if ( self.viewModel )
//            self.viewModel = nil;
//        AutoLoginVM *viewModel = [AutoLoginVM new];
//        [viewModel autoLogin];
//        self.viewModel = viewModel;
        return YES;
    }
    return NO;
}

-(id)resultObjectToBeanWithClass:(Class)class
{
    RTLog(@"result dic %@",self);
    
    NSError *error = nil;
    id result = nil;
    
    if ([self resultSucess]) {
        id temp = [self resultObject];
        
        if ([temp isKindOfClass:[NSDictionary class]]) {
            
            result = [[class alloc] initWithDictionary:temp error:&error];
            
            if (!error) {
                return result;
            }
            
        }else if ([temp isKindOfClass:[NSArray class]]){
            result = [class arrayOfModelsFromDictionaries:temp error:&error];
            
            if (!error) {
                return result;
            }
        }else{
            return nil;
        }
    }
    return error;
}
@end
