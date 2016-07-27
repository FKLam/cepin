//
//  JobSearchKeyTypeTable.m
//  cepin
//
//  Created by Ricky Tang on 14-11-6.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobSearchKeyTypeTable.h"
#import "SearchKeyTypeModel.h"

@interface JobSearchKeyTypeTable()

@property(nonatomic,weak)NSArray *keyTypes;

@end

@implementation JobSearchKeyTypeTable

-(instancetype)initWithKeyTypes:(NSArray *)types
{
    if (self = [super init]) {
        self.keyTypes = types;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 70, 70) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelected) {
        self.didSelected(self.keyTypes[indexPath.row]);
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keyTypes.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    SearchKeyTypeModel *model = self.keyTypes[indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}

@end
