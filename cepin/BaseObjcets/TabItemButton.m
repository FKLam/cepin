//
//  TabItemButton.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-6.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "TabItemButton.h"
#import "BaseTabViewController.h"



@interface TabItemButton ()

-(void)tabItemButtonNotification:(NSNotification *)notification;

@end


@implementation TabItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}



-(void)setupTabItemButtonNotification:(BOOL)isAdd
{
    if (isAdd) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabItemButtonNotification:) name:TabButtonSwitchNotification object:nil];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TabButtonSwitchNotification object:nil];
}

-(void)tabItemButtonNotification:(NSNotification *)notification
{
    //RTLog(@"notification action by button");
    if(self == notification.object){
        self.selected = YES;
    }
    else{
        self.selected = NO;
    }
}

-(void)dealloc
{
    [self setupTabItemButtonNotification:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
