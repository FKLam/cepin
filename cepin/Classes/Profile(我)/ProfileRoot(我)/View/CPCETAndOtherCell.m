//
//  CPCETAndOtherCell.m
//  cepin
//
//  Created by ceping on 15/12/11.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "CPCETAndOtherCell.h"

@implementation CPCETAndOtherCell


- (void)addCETName:(NSString *)name score:(NSNumber *)score
{
    NSString *time = nil;
    NSRange range = [score.stringValue rangeOfString:@"."];
    if ( range.length > 0 )
        time = [NSString stringWithFormat:@"%@（%.1lf分）", name, score.floatValue];
    else
        time = [NSString stringWithFormat:@"%@（%ld分）", name, score.integerValue];
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  英语等级";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    self.name.attributedText = [timeAttStr copy];
}

@end
