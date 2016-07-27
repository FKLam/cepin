//
//  CPWXinsanbanController.m
//  cepin
//
//  Created by ceping on 16/5/5.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPWXinsanbanController.h"

@interface CPWXinsanbanController ()
@property (nonatomic, strong) UIWebView *contentWebView;
@end

@implementation CPWXinsanbanController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"新三板"];
    NSString *urlString = @"http://ipo.cepin.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:self.contentWebView];
    [self.contentWebView loadRequest:request];
}
- (UIWebView *)contentWebView
{
    if ( !_contentWebView )
    {
        _contentWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [_contentWebView setScalesPageToFit:YES];
    }
    return _contentWebView;
}
@end
