//
//  BaseScrollViewController.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-30.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseScrollViewController.h"

@interface BaseScrollViewController ()

@end

@implementation BaseScrollViewController
@synthesize scrollView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    
    //CGSize viewSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.view.frame));
    
    self.view.frame = CGRectMake(0, CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), screenSize.height-44-20);
    
    self.scrollView.frame = CGRectMake(CGRectGetMinX(self.scrollView.frame), CGRectGetMinY(self.scrollView.frame), CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.view.frame));
    //self.scrollView.contentSize = viewSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    /*if ([self isViewLoaded] && self.view.window == nil) {
        self.scrollView = nil;
    }*/
}

- (void)stopKeyboardAvoiding
{
    [UIView animateWithDuration:0.3f animations:^(void){
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

@end
