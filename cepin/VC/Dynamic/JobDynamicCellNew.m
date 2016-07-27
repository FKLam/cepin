//
//  JobDynamicCellNew.m
//  cepin
//
//  Created by zhu on 15/1/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobDynamicCellNew.h"

@implementation JobDynamicCellNew

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.viewBlockBackground = [[TKRoundedView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 44)];
        self.viewBlockBackground.drawnBordersSides = TKDrawnBorderSidesNone;
        self.viewBlockBackground.roundedCorners = TKRoundedCornerNone;
        self.viewBlockBackground.borderWidth = 0.5;
        self.viewBlockBackground.borderColor = [[RTAPPUIHelper shareInstance]lineColor];
        self.viewBlockBackground.fillColor = [UIColor whiteColor];
        self.viewBlockBackground.cornerRadius = 8.f;
        [self.contentView addSubview:self.viewBlockBackground];
        
        int xOffset = kScreenWidth - 10 - 20 - 10;
        self.imageArrow = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset, 12, 20, 20)];
        self.imageArrow.image = UIIMAGE(@"indicate_right_grey");
        [self.viewBlockBackground addSubview:self.imageArrow];
        
        xOffset = kScreenWidth - xOffset - 10 - 60;
        self.labelSarly = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 12, 60, 20)];
        self.labelSarly.font = [UIFont boldSystemFontOfSize:12];
        self.labelSarly.textColor = UIColorFromRGB(0xfb6e52);
        self.labelSarly.textAlignment = NSTextAlignmentRight;
        [self.viewBlockBackground addSubview:self.labelSarly];
        
        xOffset = kScreenWidth - xOffset - 10 - 60;
        self.labelAddress = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 12, 60, 20)];
        self.labelAddress.font = [UIFont boldSystemFontOfSize:12];
        self.labelAddress.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.labelAddress.textAlignment = NSTextAlignmentRight;
        [self.viewBlockBackground addSubview:self.labelAddress];
        
        xOffset = kScreenWidth - xOffset - 10;
        self.labelName = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, kScreenWidth, 20)];
        self.labelName.font = [UIFont boldSystemFontOfSize:12];
        self.labelName.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.viewBlockBackground addSubview:self.labelName];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews
{
    int width = kScreenWidth-20;
    self.viewBlockBackground.frame = CGRectMake(10, 0, width, 44);
    
    int xOffset = width - 10 - 20;
    self.imageArrow.frame = CGRectMake(xOffset, 12, 20, 20);
    
    CGSize size = StringFontSize(self.labelSarly.text, [UIFont boldSystemFontOfSize:12]);
    xOffset = xOffset - 10 - size.width - 4;
    self.labelSarly.frame = CGRectMake(xOffset, 12, size.width + 4, 20);
    
    size = StringFontSize(self.labelAddress.text, [UIFont boldSystemFontOfSize:12]);
    xOffset = xOffset - 10 - size.width - 4;
    self.labelAddress.frame = CGRectMake(xOffset, 12, size.width + 4, 20);
    
    int remainLength = xOffset - 20;
    self.labelName.frame = CGRectMake(10, 12, remainLength,20);
}

@end
