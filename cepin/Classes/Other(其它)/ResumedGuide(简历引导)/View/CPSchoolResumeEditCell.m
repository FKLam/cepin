//
//  CPSchoolResumeEditCell.m
//  cepin
//
//  Created by ceping on 16/1/19.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSchoolResumeEditCell.h"

@implementation CPSchoolResumeEditCell

+ (instancetype)ensureEditCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"schoolResumeEditCell";
    CPSchoolResumeEditCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPSchoolResumeEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder contentString:(NSString *)contentString
{
    [self configCellLeftString:str placeholder:placeholder];
    
    [self.inputTextField setText:contentString];
}
@end
