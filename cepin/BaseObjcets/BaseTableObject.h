//
//  BaseTableObject.h
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-25.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableViewCell+Create.h"
#import "BaseRVMViewModel.h"

@interface BaseTableObject : NSObject<UITableViewDataSource>

@property(nonatomic,weak)NSMutableArray *datas;
@property(nonatomic,weak)UIViewController *viewController;

-(id)initWithDatas:(NSArray *)values;

-(id)initWithDatas:(NSMutableArray *)values viewController:(UIViewController *)vc;

-(void)addDatas:(NSSet *)objects;

@end
