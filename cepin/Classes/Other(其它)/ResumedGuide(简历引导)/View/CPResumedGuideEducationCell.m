//
//  CPResumedGuideEducationCell.m
//  cepin
//
//  Created by ceping on 16/1/19.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumedGuideEducationCell.h"

@implementation CPResumedGuideEducationCell

+ (instancetype)ensureArrowCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"guideEducationCell";
    CPResumedGuideEducationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPResumedGuideEducationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder educationData:(EducationListDateModel *)educationData
{
    [self configCellLeftString:str placeholder:placeholder];
    
}

- (void)configCellLeftString:(NSString *)str placeholder:(NSString *)placeholder contentString:(NSString *)contentString
{
    [self configCellLeftString:str placeholder:placeholder];
    
    [self.inputTextField setText:contentString];
}

@end
