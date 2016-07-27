//
//  CAAnimation+Block.m
//  yanyu
//
//  Created by rickytang on 13-11-17.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "CAAnimation+Block.h"

static char BlockStart;
static char BlockStop;

@implementation CAAnimation (Block)

-(void)animationDidStartBlock:(void(^)(CAAnimation *animation))startBlock stopBlock:(void(^)(CAAnimation *animation , BOOL finished))stopBlock
{
    self.delegate = self;
    
    if (startBlock) {
        objc_setAssociatedObject(self, &BlockStart, startBlock, OBJC_ASSOCIATION_RETAIN);
    }
    
    if (stopBlock) {
        objc_setAssociatedObject(self, &BlockStop, stopBlock, OBJC_ASSOCIATION_RETAIN);
    }
}



-(void)animationDidStart:(CAAnimation *)anim
{
    void(^block)(CAAnimation *animtion) = objc_getAssociatedObject(self, &BlockStart);
    block(anim);
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^block)(CAAnimation *animation , BOOL finished) = objc_getAssociatedObject(self, &BlockStop);
    block(anim,flag);
}
@end
