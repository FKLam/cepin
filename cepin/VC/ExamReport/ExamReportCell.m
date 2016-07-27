//
//  ExamReportCell.m
//  cepin
//
//  Created by dujincai on 15/6/9.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ExamReportCell.h"
#import "NSString+Extension.h"

@implementation ExamReportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        int width = kScreenWidth - 30;
        
        self.roundView = [[TKRoundedView alloc]initWithFrame:CGRectMake(20, 10, width, self.viewHeight)];
        self.roundView.backgroundColor = [UIColor whiteColor];

        self.roundView.borderColor = [UIColor whiteColor];
        self.roundView.fillColor = [UIColor whiteColor];
        [self.contentView addSubview:self.roundView];
        
        self.imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.roundView.viewWidth, IS_IPHONE_5?75:90)];
        self.imageLogo.backgroundColor = [UIColor clearColor];
        [self.roundView addSubview:self.imageLogo];
        
        self.lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageLogo.viewY + self.imageLogo.viewHeight, width-120, 30)];
        self.lableTitle.backgroundColor = [UIColor clearColor];
        self.lableTitle.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.lableTitle.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.roundView addSubview:self.lableTitle];
        
        self.ReportButton = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 110, self.lableTitle.viewY, 100, 30)];
        
        self.ReportButton.textColor = [[RTAPPUIHelper shareInstance] labelColorGreen];
        self.ReportButton.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.ReportButton.textAlignment = NSTextAlignmentRight;
        [self.roundView addSubview:self.ReportButton];
        
        self.lableTime = [[UILabel alloc]initWithFrame:CGRectMake(0, self.lableTitle.viewHeight + self.lableTitle.viewY, kScreenWidth - 25, IS_IPHONE_5?9:11)];
        self.lableTime.backgroundColor = [UIColor clearColor];
        self.lableTime.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
        self.lableTime.numberOfLines = 0;
        self.lableTime.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.lableTime.text = @"";
        [self.roundView addSubview:self.lableTime];
    }
    return self;
}
- (void)layoutSubviews
{
    int higth = self.imageLogo.image.size.height * (kScreenWidth - 20)/self.imageLogo.image.size.width;
    self.roundView.frame = CGRectMake(10, 0, kScreenWidth - 20, self.viewHeight - 2);
    self.imageLogo.frame = CGRectMake(0, 0, kScreenWidth - 20, higth);
    self.lableTitle.frame = CGRectMake(0, self.imageLogo.viewHeight + self.imageLogo.viewY + 10, kScreenWidth - 20 - 100, IS_IPHONE_5?12:15);
    self.ReportButton.frame = CGRectMake(kScreenWidth - 110, self.lableTitle.viewY, 90, 15);
    self.lableTime.frame = CGRectMake(0, self.lableTitle.viewHeight + self.lableTitle.viewY + 10, kScreenWidth - 25, IS_IPHONE_5?9:11);
}

- (void)computyWith:(DynamicExamModelDTO *)model
{
    [self.imageLogo sd_setImageWithURL:[NSURL URLWithString:model.ImgFilePath] placeholderImage:[UIImage imageNamed:@"loading_img"]];
    self.lableTime.text = model.FinishExamTime;
    self.lableTitle.text = model.Title;
}
+(int)computyHith:(UIImage *)image
{
    int height = image.size.height * kScreenWidth/image.size.width;
    
    return height;
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
