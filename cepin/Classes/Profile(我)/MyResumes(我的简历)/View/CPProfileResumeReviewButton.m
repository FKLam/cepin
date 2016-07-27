//
//  CPProfileResumeReviewButton.m
//  cepin
//
//  Created by ceping on 16/1/7.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPProfileResumeReviewButton.h"

@implementation CPProfileResumeReviewButton

- (void)setHighlighted:(BOOL)highlighted
{
    if ( highlighted && self.imageView )
    {
        self.backgroundColor = [UIColor colorWithHexString:@"247ec9"];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithHexString:@"288add"];
    }
}

@end
