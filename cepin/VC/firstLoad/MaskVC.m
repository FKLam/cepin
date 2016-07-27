//
//  MaskVC.m
//  cepin
//
//  Created by ceping on 15-2-11.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "MaskVC.h"

@interface MaskVC ()
@property (nonatomic, strong) TBLoading *loading;
@end

@implementation MaskVC

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [[RTAPPUIHelper shareInstance] shadeColor];
}

- (TBLoading *)loading
{
    if ( !_loading )
    {
        _loading = [[TBLoading alloc] init];
        _loading.tag = 10086;
    }
    return _loading;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.loading start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.loading stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.loading stop];
}

@end
