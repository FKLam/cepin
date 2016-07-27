//
//  NSString+Addition.m
//  yanyu
//
//  Created by rickytang on 13-10-5.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)
-(BOOL)checkTextBlank
{
    if (self.length < 1 || [self rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
        
        return NO;
    }
    return YES;
}

-(BOOL)checkEmailText
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$"
                                  options:NSRegularExpressionAnchorsMatchLines
                                  error:&error];
    
    NSUInteger numberOfMatches = [regex
                                  numberOfMatchesInString:self
                                  options:NSMatchingAnchored
                                  range:NSMakeRange(0, [self length])];
    
    // If there is not a single match
    // then return an error and NO
    if (numberOfMatches == 0)
    {
        //NSAssert(error != nil, [NSString stringWithFormat:@"error %@",error]);
        if (error) {
            NSLog(@"error %@",error);
        }
        return NO;
    }
    
    return YES;
}


-(BOOL)checkMobileText
{
//    if (self.length != 11) {
//        return NO;
//    }
//    ^[0-9]*$
//    ^(1(([35][0-9])|(47)|[8][0126789]))\\d{8}$
    //^[A-Za-z0-9\u4E00-\u9FA5_-]+$
    //^[0-9]*$
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^[0-9]*$"
                                  options:NSRegularExpressionAnchorsMatchLines
                                  error:&error];
    
    NSUInteger numberOfMatches = [regex
                                  numberOfMatchesInString:self
                                  options:NSMatchingAnchored
                                  range:NSMakeRange(0, [self length])];
    
    // If there is not a single match
    // then return an error and NO
    if (numberOfMatches == 0)
    {
        //NSAssert(error != nil, [NSString stringWithFormat:@"error %@",error]);
        if (error) {
            NSLog(@"error %@",error);
        }
        return NO;
    }
    
    return YES;
}
-(BOOL)checkPasswordText
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^[A-Za-z0-9]+$"
                                  options:NSRegularExpressionAnchorsMatchLines
                                  error:&error];
    NSUInteger numberOfMatches = [regex
                                  numberOfMatchesInString:self
                                  options:NSMatchingAnchored
                                  range:NSMakeRange(0, [self length])];
    
    if (numberOfMatches == 0)
    {
        if (error) {
            NSLog(@"error %@",error);
        }
        return NO;
    }
    return YES;
}
-(BOOL)isIncludeSpecialCharact
{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€.,!?"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
@end
