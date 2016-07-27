//
//  DynamicCompanyTalkCell.m
//  cepin
//
//  Created by ceping on 14-12-12.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicCompanyTalkCell.h"
#import "NSDate-Utilities.h"

@implementation DynamicCompanyTalkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lableTime = [[UILabel alloc]initWithFrame:CGRectMake(0, CompanyTalkTopOffsetY, kScreenWidth, CompnayTalkTimeHeight)];
        self.lableTime.backgroundColor = [UIColor clearColor];
        self.lableTime.font = [UIFont systemFontOfSize:CompanyTalkContentFont];
        self.lableTime.textAlignment = NSTextAlignmentCenter;
        self.lableTime.textColor = [UIColor grayColor];
        self.lableTime.text = @"";
        [self.contentView addSubview:self.lableTime];
        
        self.imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake(CompanyTalkLogoOffsetX, CompanyTalkLogoOffsetY, CompanyTalkLogoSize, CompanyTalkLogoSize)];
        self.imageLogo.layer.cornerRadius = CompanyTalkLogoSize/2;
        self.imageLogo.backgroundColor = [UIColor clearColor];
        self.imageLogo.layer.masksToBounds = YES;
        self.imageLogo.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.imageLogo];
        
        
        self.imageBackground = [[UIImageView alloc]initWithFrame:CGRectMake(CompanyTalkContentOffsetX, CompanyTalkContentOffsetY, CompanyTalkMaxLength + 20, CompanyTalkLogoSize + 20)];
        self.backgroundColor = [UIColor clearColor];
        UIImage *img = UIIMAGE(@"green_talk_bg");
        self.imageBackground.image = [img stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        [self.contentView addSubview:self.imageBackground];
        
        self.lableContent = [[UILabel alloc]initWithFrame:CGRectMake(CompanyTalkContentOffsetX + 10, CompanyTalkContentOffsetY + 10, CompanyTalkMaxLength, CompanyTalkLogoSize)];
        self.lableContent.backgroundColor = [UIColor clearColor];
        self.lableContent.font = [UIFont systemFontOfSize:CompanyTalkContentFont];
        self.lableContent.textAlignment = NSTextAlignmentLeft;
        self.lableContent.numberOfLines = 0;
        self.lableContent.textColor = UIColorFromRGB(0x454545);
        [self.contentView addSubview:self.lableContent];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int height = [[self class]computerTalkContentHeight:self.lableContent.text];
    self.lableContent.frame = CGRectMake(CompanyTalkContentOffsetX + 20, CompanyTalkContentOffsetY + 10, CompanyTalkMaxLength-10, height);
    self.imageBackground.frame = CGRectMake(CompanyTalkContentOffsetX, CompanyTalkContentOffsetY, CompanyTalkMaxLength + 20, height + 20);
}

-(void)configureText:(NSString*)str
{
    self.lableContent.text = str;
}

+(int)computerTalkContentHeight:(NSString*)str
{
    int computerHeight = StringSizeH(str, CompanyTalkContentFont, CompanyTalkMaxLength-10) + 10;
    return MAX(computerHeight, CompanyTalkLogoSize);
}

+(int)computerTalkCellHeight:(NSString*)str
{
    int height = [[self class]computerTalkContentHeight:str];
    int riseHegiht = height - CompanyTalkLogoSize;
    return CompanyTalkContentOffsetY + CompanyTalkLogoSize + 20 + riseHegiht;
}

-(void)configureWithModel:(DynamicCompanyChatModel*)model
{
    [self.imageLogo setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"tb_default_logo"]];
    self.lableTime.text = [model.CreateTime cepinDateString];
    self.lableContent.text = model.message;
}

@end
