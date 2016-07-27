//
//  DynamicExamCell.m
//  cepin
//
//  Created by ceping on 14-12-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicExamCell.h"

@implementation DynamicExamCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        int width = kScreenWidth - 20;
        
        self.roundView = [[TKRoundedView alloc]initWithFrame:CGRectMake(0, 0, width, IS_IPHONE_5?160:180)];
        self.roundView.backgroundColor = [UIColor whiteColor];
        self.roundView.borderColor = [UIColor whiteColor];
        self.roundView.fillColor = [UIColor whiteColor];
        [self.contentView addSubview:self.roundView];
        
        self.lableTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.roundView.viewWidth, IS_IPHONE_5?13:16)];
        self.lableTime.backgroundColor = [UIColor clearColor];
        self.lableTime.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        self.lableTime.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.lableTime.textAlignment = NSTextAlignmentCenter;
        [self.roundView addSubview:self.lableTime];

        
        self.imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.lableTime.viewY+self.lableTime.viewHeight, self.roundView.viewWidth, IS_IPHONE_5?75:90)];
        self.imageLogo.backgroundColor = [UIColor clearColor];
        [self.roundView addSubview:self.imageLogo];
        
        self.lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageLogo.viewHeight + self.imageLogo.viewY + 10, width, IS_IPHONE_5?12:15)];
        self.lableTitle.backgroundColor = [UIColor clearColor];
        self.lableTitle.font = [[RTAPPUIHelper shareInstance]titleFont];
        self.lableTitle.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.roundView addSubview:self.lableTitle];
        
        self.buttonShare = [[UIButton alloc]initWithFrame:CGRectMake(self.roundView.viewWidth - (IS_IPHONE_5?30:35), self.lableTitle.viewY, IS_IPHONE_5?30:35, IS_IPHONE_5?30:35)];
        [self.buttonShare setImage:UIIMAGE(@"ic_share") forState:UIControlStateNormal];
        self.buttonShare.backgroundColor = [UIColor clearColor];
        [self.roundView addSubview:self.buttonShare];
        
        self.lableDetail = [[UILabel alloc]initWithFrame:CGRectMake(0, self.lableTitle.viewHeight + self.lableTitle.viewY + 10, width, 40)];
        self.lableDetail.backgroundColor = [UIColor clearColor];
        self.lableDetail.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.lableDetail.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        self.lableDetail.numberOfLines = 2;
        [self.roundView addSubview:self.lableDetail];
        
        
        self.line = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 1)];
        self.line.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        [self.roundView addSubview:self.line];
   
    }
    return self;
}

- (void)layoutSubviews
{
    int hight = self.imageLogo.image.size.height * kScreenWidth/self.imageLogo.image.size.width;
    
    
    self.roundView.frame = CGRectMake(0, 0, kScreenWidth, self.viewHeight- 2);
    self.lableTime.frame = CGRectMake(0, 0, self.roundView.viewWidth, IS_IPHONE_5?13:16);
    self.imageLogo.frame = CGRectMake(10, self.lableTime.viewY+self.lableTime.viewHeight+10, kScreenWidth - 20, hight);
    
    self.lableTitle.frame = CGRectMake(10, self.imageLogo.viewHeight + self.imageLogo.viewY + 20, kScreenWidth - 20, IS_IPHONE_5?12:15);
    self.buttonShare.frame = CGRectMake(self.roundView.viewWidth - (IS_IPHONE_5?30:35) - 10, self.lableTitle.viewY-10, IS_IPHONE_5?30:35, IS_IPHONE_5?30:35);
    self.lableDetail.frame = CGRectMake(10, self.buttonShare.viewHeight + self.buttonShare.viewY,  kScreenWidth - 20, 40);
    self.line.frame = CGRectMake(0, self.roundView.viewHeight - 10, kScreenWidth, 1);
 
}

- (void)computyWith:(DynamicExamModelDTO *)model
{

    self.lableTime.text = model.CreateDate;
    [self.imageLogo sd_setImageWithURL:[NSURL URLWithString:model.ImgFilePath] placeholderImage:[UIImage imageNamed:@"loading_img"]];
    self.lableTitle.text = model.Title;
    self.lableDetail.text = model.Introduction;
}
+(int)computyHith:(UIImage *)image
{
    
    int height = image.size.height * kScreenWidth/image.size.width;
    
    return height;
}
@end
