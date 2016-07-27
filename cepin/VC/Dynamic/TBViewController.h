//
//  TBViewController.h
//  cepin
//
//  Created by dujincai on 15/4/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DynamicSystemModelDTO.h"
@interface TBViewController : BaseTableViewController
-(instancetype)initWithBean:(DynamicSystemModelDTO*)bean;
@end
