//
//  RTTextView.m
//  cepin
//
//  Created by Ricky Tang on 14-11-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTTextView.h"

@implementation RTTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self _init];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}


-(void)_init
{
    [self setupNotification:YES];
    [self setPlaceHolder];
}

-(void)setupNotification:(BOOL)value
{
    if (value) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidBeginEditingNotification object:self queue:nil usingBlock:^(NSNotification *notification){
            
            if ([self.text isEqualToString:self.placeHolderString]) {
                self.textColor = self.mainTextColor;
                self.text = @"";
            }
            
        }];
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidEndEditingNotification object:self queue:nil usingBlock:^(NSNotification *notification){
            
            if (self.text.length < 1 || [self.text isEqualToString:self.placeHolderString]) {
                self.text = self.placeHolderString;
                self.textColor = self.placeHolderStringColor;
            }
            
        }];
    }
}


-(void)setPlaceHolder
{
    
    self.text = self.placeHolderString;
    self.textColor = self.placeHolderStringColor;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


@end
