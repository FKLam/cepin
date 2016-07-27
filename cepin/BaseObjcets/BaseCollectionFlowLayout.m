//
//  BaseCollectionFlowLayout.m
//  cepin
//
//  Created by Ricky Tang on 14-11-8.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseCollectionFlowLayout.h"

@implementation BaseCollectionFlowLayout
-(instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)direction
{
    if (self = [super init]) {
        self.scrollDirection = direction;
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
    }
    return self;
}
@end
