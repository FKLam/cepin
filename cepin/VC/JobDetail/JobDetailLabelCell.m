//
//  JobDetailLabelCell.m
//  cepin
//
//  Created by ricky.tang on 14-10-31.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JobDetailLabelCell.h"

@implementation JobDetailLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.viewcell = [[UIView alloc]initWithFrame:CGRectMake(0, 5, self.viewWidth, self.viewHeight - 10)];
         self.viewcell.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview: self.viewcell];
        
        self.tagListView = [[AOTagList alloc]initWithFrame:CGRectMake(10, 5, 300, 30)];
        [self.viewcell addSubview:self.tagListView];
    }
    return self;
}

+ (int)companyHightWithString:(NSString *)str
{
    return StringFontSizeH(str, [[RTAPPUIHelper shareInstance]jobInformationTemptationFont], kScreenWidth - 40) + 30;
}
- (void)layoutSubviews
{
    if (self.viewHeight == 0) {
        self.viewcell.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
        self.tagListView.frame = CGRectMake(0, 0 , self.viewWidth - 30, self.viewHeight);
    }else
    {
        self.viewcell.frame = CGRectMake(0, 5, self.viewWidth, self.viewHeight - 10);
        self.tagListView.frame = CGRectMake(10, 5 , self.viewWidth - 30, self.viewHeight - 10);
    }
    
}

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
