//
//  CircleView.m
//  cepin
//
//  Created by ceping on 15-2-11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView


-(void)setType:(CircleViewType)type
{
    _type = type;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    switch (_type)
    {
        case CircleTypeDefualt:
        {
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.backgroundColor = [UIColor clearColor];
        }
            break;
        case CircleTypeChecked:
        {
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.backgroundColor = [UIColor whiteColor];
        }
            break;
            
        default:
            break;
    }
    [self setNeedsDisplay];
}

@end
