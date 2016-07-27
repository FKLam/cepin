//
//  CPSchoolResumeArrowCell.m
//  cepin
//
//  Created by ceping on 16/1/19.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPSchoolResumeArrowCell.h"

@implementation CPSchoolResumeArrowCell

+ (instancetype)ensureArrowCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"schoolResumeArrowCell";
    CPSchoolResumeArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPSchoolResumeArrowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder contentString:(NSString *)contentString
{
    [self configCellLeftString:str placeholder:placeholder];
    
    [self.inputTextField setText:contentString];
}
@end
