//
//  BaseWebVC.h
//  cepin
//
//  Created by ceping on 15-1-16.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseWebVC : BaseTableViewController

-(instancetype)initWithTitleAndlUrl:(NSString*)title url:(NSString*)urlString;

@end
