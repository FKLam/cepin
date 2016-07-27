//
//  DynamicSystemDetailVC.h
//  cepin
//
//  Created by ceping on 14-12-10.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DynamicSystemModelDTO.h"

@interface DynamicSystemDetailVC : BaseTableViewController

-(instancetype)initWithBean:(DynamicSystemModelDTO*)bean;

@end
