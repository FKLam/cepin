//
//  PoliticsVM.m
//  cepin
//
//  Created by dujincai on 15/6/11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "PoliticsVM.h"

@implementation PoliticsVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datas = [BaseCode politics];
    }
    return self;
}
@end
