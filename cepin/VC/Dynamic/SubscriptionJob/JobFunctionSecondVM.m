//
//  JobFunctionSecondVM.m
//  cepin
//
//  Created by dujincai on 15/6/30.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobFunctionSecondVM.h"
#import "BaseCodeDTO.h"
@implementation JobFunctionSecondVM
- (instancetype)initWithData:(NSMutableArray *)data seletedData:(NSMutableArray *)seletedData jobFunctionsKey:(NSMutableArray *)jobFunctionskey
{
    self = [super init];
    if (self) {
        self.datas = data;
        self.selectedObject = [NSMutableArray new];
        self.jobFunctionsKey = [NSMutableArray new];
        self.selectedObject = seletedData;
        self.jobFunctionsKey = jobFunctionskey;
    }
    return self;
}

-(BOOL)selectedCityWithIndex:(NSInteger)index
{
    BaseCode *item = self.datas[index];
    
    if (self.selectedObject.count < 1) {
        [self.selectedObject addObject:item.CodeName];
        [self.jobFunctionsKey addObject:item.CodeKey];
        return YES;
    }
    
    
    NSString *tempItem = nil;
    
    for (NSString *i in self.selectedObject) {
        if ([i isEqualToString:item.CodeName]) {
            tempItem = i;
            break;
        }
    }
    
    if (tempItem) {
        [self.selectedObject removeObject:tempItem];
        return NO;
    }else{
        [self.selectedObject addObject:item.CodeName];
        if (self.selectedObject.count > 3) {
            [self.selectedObject removeLastObject];
            return NO;
        }
        return YES;
    }
    
    
    NSString* keytemp = nil;
    for (NSString *i in self.jobFunctionsKey) {
        if ([i isEqualToString:[NSString stringWithFormat:@"%@",item.CodeKey]]) {
            keytemp = i;
            break;
        }
    }
    if (keytemp) {
        [self.jobFunctionsKey removeObject:keytemp];
        return NO;
    }else{
        [self.jobFunctionsKey addObject:[NSString stringWithFormat:@"%@",item.CodeKey]];
        if (self.jobFunctionsKey.count > 3) {
            [self.jobFunctionsKey removeLastObject];
            return NO;
        }
        return YES;
    }
    return NO;
}

@end
