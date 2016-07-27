//
//  SaveJobVC.h
//  cepin
//
//  Created by ricky.tang on 14-10-30.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"
//#import "JobDefine.h"


@protocol SaveJobVCDelegate <NSObject>

- (void)getJobSelect:(NSMutableArray*)array;

@end


@interface SaveJobVC : BaseTableViewController

@property(nonatomic,strong)id<SaveJobVCDelegate>delegate;

-(void)reloadData;

@end
