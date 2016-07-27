//
//  RTSelectedCell.m
//  cepin
//
//  Created by ricky.tang on 14-10-22.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "RTSelectedCell.h"
#import "UIView+Draw.h"

@implementation RTSelectedCell

- (void)awakeFromNib
{
    self.labelTitle.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
    self.labelTitle.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
    
    self.labelSub.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
    self.labelSub.font = [[RTAPPUIHelper shareInstance] searchResultTipsEndFont];
    self.line.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        [self.buttonSelected setImage:[UIImage imageNamed:@"ic_tick"] forState:UIControlStateNormal];

    }else{
        [self.buttonSelected setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}


@end
