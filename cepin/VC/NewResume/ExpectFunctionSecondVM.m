//
//  ExpectFunctionSecondVM.m
//  cepin
//
//  Created by dujincai on 15/6/16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExpectFunctionSecondVM.h"
#import "BaseCodeDTO.h"
@implementation ExpectFunctionSecondVM
-(instancetype)initWithData:(NSMutableArray *)data seletedData:(NSMutableArray *)seletedData
{
    if (self = [super init]) {
        self.datas = data;
        self.selectedObject = [NSMutableArray new];
        self.selectedObject = seletedData;
    }
    return self;
}


-(BOOL)selectedCityWithIndex:(NSInteger)index
{
    
    BaseCode *item = self.datas[index];
    
    if (self.selectedObject.count < 1) {
        [self.selectedObject addObject:item];
        return YES;
    }
    
    
    BaseCode *tempItem = nil;
    
    for (BaseCode *i in self.selectedObject) {
        if ([i.CodeName isEqualToString:item.CodeName]) {
            tempItem = i;
            break;
        }
    }
    
    if (tempItem) {
        [self.selectedObject removeObject:tempItem];
        return NO;
    }else{
        [self.selectedObject addObject:item];
        if (self.selectedObject.count > 3) {
            [self.selectedObject removeLastObject];
            return NO;
        }
        return YES;
    }
    
    return NO;
}
@end
