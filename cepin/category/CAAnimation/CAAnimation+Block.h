//
//  CAAnimation+Block.h
//  yanyu
//
//  Created by rickytang on 13-11-17.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (Block)

-(void)animationDidStartBlock:(void(^)(CAAnimation *animation))startBlock stopBlock:(void(^)(CAAnimation *animation , BOOL finished))stopBlock;

@end
