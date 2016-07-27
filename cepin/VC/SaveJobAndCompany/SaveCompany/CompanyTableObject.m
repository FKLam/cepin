//
//  CompanyTableObject.m
//  cepin
//
//  Created by ceping on 14-11-27.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CompanyTableObject.h"
#import "CompanyCell.h"
#import "SaveCompanyModel.h"

@implementation CompanyTableObject

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyCell *cell = [CompanyCell cellForTableView:tableView fromNib:[CompanyCell nib] andOwner:self];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //cell.delegate = self;
    [cell setChoice:NO];
    SaveCompanyModel *bean = [SaveCompanyModel beanFromDictionary:[self.datas objectAtIndex:indexPath.row]];
    [cell configWithBean:bean];
    
    return cell;
}

@end
