//
//  BaseTableObject.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-25.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseTableObject.h"

@implementation BaseTableObject

@synthesize datas,viewController;

-(id)initWithDatas:(NSArray *)values
{
    if (self = [super init]) {
        self.datas = (NSMutableArray *)values;
    }
    return self;
}

-(id)initWithDatas:(NSMutableArray *)values viewController:(UIViewController *)vc
{
    if (self = [super init]) {
        self.datas = values;
        self.viewController = vc;
    }
    return self;
}



-(void)addDatas:(NSSet *)objects
{
    [self.datas addObjectsFromArray:[objects allObjects]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
