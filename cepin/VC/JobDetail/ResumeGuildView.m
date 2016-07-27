//
//  ResumeGuildView.m
//  cepin
//
//  Created by ceping on 15-3-27.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeGuildView.h"
#import "TBAppDelegate.h"

@implementation ResumeGuildView

-(instancetype)init
{
    if (self = [super initWithFrame:[[UIScreen mainScreen]bounds]])
    {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, self.viewWidth, self.viewHeight-20)];
        image.image = UIIMAGE(@"guide");
        [self addSubview:image];
        
        self.maskButton = [[UIButton alloc]initWithFrame:self.bounds];
        [self addSubview:self.maskButton];
        self.maskButton.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)disPlayView
{
    TBAppDelegate *delegate = (TBAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
}

@end
