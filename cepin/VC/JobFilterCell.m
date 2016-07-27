//
//  JobFilterCell.m
//  cepin
//
//  Created by zhu on 14/12/14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobFilterCell.h"

@implementation JobFilterCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 43)];
        self.labelTitle.textColor = UIColorFromRGB(0x2492f4);
        self.labelTitle.font = [[RTAPPUIHelper shareInstance] mainTitleFont];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        
        self.labelSub = [[UILabel alloc]initWithFrame:CGRectMake(80+5, 0, kScreenWidth-10-22-80-5-5, 43)];
        self.labelSub.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        self.labelSub.font = [[RTAPPUIHelper shareInstance] subTitleFont];
        self.labelSub.textAlignment = NSTextAlignmentRight;
        self.labelSub.numberOfLines = 2;
        self.labelSub.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelSub];
        
        self.imageViewArrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-10-22, (43-22)/2, 22, 22)];
        self.imageViewArrow.backgroundColor = [UIColor clearColor];
        self.imageViewArrow.image = UIIMAGE(@"indicate_right_grey");
        [self.contentView addSubview:self.imageViewArrow];
    }
    return self;
}

-(void)configureLableTitleText:(NSString*)text
{
    self.labelTitle.text = text;
}
-(void)configureLableSubText:(NSString*)text
{
    if (text && ![text isEqualToString:@""])
    {
        self.labelSub.text = text;
    }
    else
    {
        self.labelSub.text = @"";
    }
}

@end
