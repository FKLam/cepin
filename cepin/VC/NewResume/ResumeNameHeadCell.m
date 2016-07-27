//
//  ResumeNameHeadCell.m
//  cepin
//
//  Created by dujincai on 15/6/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeNameHeadCell.h"
#import "TBTextUnit.h"
#import "NSString+Extension.h"


@implementation ResumeNameHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.headImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headImage];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(self.headImage.viewWidth + self.headImage.viewX + 10, 10, 150, 30)];
        self.name.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.name.font = [[RTAPPUIHelper shareInstance] jobInformationDeliverButtonFont];
        [self.contentView addSubview:self.name];
        
        self.sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.name.viewWidth + self.name.viewX, self.name.viewY, 30, 30)];
        [self.contentView addSubview:self.sexImage];
        
        self.subLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.name.viewX, self.name.viewY +self.name.viewHeight, 230, 30)];
        self.subLabel.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
        self.subLabel.textColor = [[RTAPPUIHelper shareInstance ]mainTitleColor];
        [self addSubview:self.subLabel];
        
        self.phone = [[UILabel alloc]initWithFrame:CGRectMake(self.name.viewX, self.subLabel.viewY + self.subLabel.viewHeight, 200, 30)];
        self.phone.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
        self.phone.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.phone];
        
        self.email = [[UILabel alloc]initWithFrame:CGRectMake(self.name.viewX, self.phone.viewY + self.phone.viewHeight, 200, 30)];
        self.email.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
        self.email.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.email];
        self.arrawImage = [[UIImageView alloc]initWithFrame:CGRectMake(200, 10, 30, 30)];
        self.arrawImage.image = [UIImage imageNamed:@"ic_next"];
        [self.contentView addSubview:self.arrawImage];
        
    }
    return self;
}

- (void)configModel:(ResumeNameModel *)model
{
    [self.headImage setBackgroundImageWithURL:[NSURL URLWithString:model.PhotoUrlPath] forState:UIControlStateNormal placeholderImage:UIIMAGE(@"icon_32_09")];
    
    self.name.text = model.ChineseName;
  
    NSString *age = [NSString stringWithFormat:@"%@岁",model.Age];
    NSString *str = [NSString stringWithFormat:@"%@",model.Age];
    if (!str || [str isEqualToString:@""] || [str isEqualToString:@"0"] || [str isEqualToString:@"(null)"]) {
        age = @"";
    }
    self.subLabel.text = [TBTextUnit formatAddress:model.Region workyear:model.WorkYear age:age];
    self.phone.text = model.Mobile;
    self.email.text = model.Email;
  if (model.Gender.intValue == 1){
        self.sexImage.image = [UIImage imageNamed:@"ic_men"];
    }else if (model.Gender.intValue == 2){
        self.sexImage.image = [UIImage imageNamed:@"ic_female"];
    }
    
}

- (void)layoutSubviews
{
//    int width = [[self class]computerTextWidth:self.name.text]+5;
//    int hight = IS_IPHONE_5?21:25;
//    self.headImage.frame = CGRectMake(20, 10, IS_IPHONE_5?50:60, IS_IPHONE_5?50:60);
//    self.sexImage.viewCenterY = self.name.viewCenterY;
//    
// 
//    width = MIN(kScreenWidth- self.headImage.viewWidth - 40 - hight, width);
//    self.name.frame = CGRectMake(self.headImage.viewWidth+self.headImage.viewX + 10, 10, width, IS_IPHONE_5?15:18);
//    self.sexImage.frame = CGRectMake(self.name.viewX + self.name.viewWidth, 10, hight, hight);
//    self.subLabel.frame = CGRectMake(self.name.viewX, self.name.viewY + self.name.viewHeight + 5, 230, IS_IPHONE_5?12:14);
//    if (!self.subLabel.text || [self.subLabel.text isEqualToString:@""]) {
//        self.phone.frame = CGRectMake(self.name.viewX, self.name.viewY +self.name.viewHeight + 5, 230, IS_IPHONE_5?12:14);
//        self.email.frame = CGRectMake(self.phone.viewX, self.phone.viewY + self.phone.viewHeight + 5, 230, IS_IPHONE_5?13:15);
//    }else
//    {
//        self.phone.frame = CGRectMake(self.name.viewX, self.subLabel.viewY + self.subLabel.viewHeight + 5, 200, IS_IPHONE_5?12:14);
//        self.email.frame = CGRectMake(self.name.viewX, self.phone.viewY + self.phone.viewHeight + 5, 200, IS_IPHONE_5?13:15);
//    }
//    
//    self.arrawImage.frame = CGRectMake(kScreenWidth - 20 - hight, (self.viewHeight - hight)/2, hight, hight);
    
    CGFloat horizontal_marge = 40.0 / 3.0;
    CGFloat imageLogoX = horizontal_marge;
    CGFloat imageLogoY = horizontal_marge;
    CGFloat imageLogoW = self.viewHeight - horizontal_marge * 3.0;
    CGFloat imageLogoH = imageLogoW;
    self.headImage.layer.cornerRadius = imageLogoH / 2.0;
    self.headImage.frame = CGRectMake(imageLogoX, imageLogoY, imageLogoW, imageLogoH);
    
    self.arrawImage.viewCenterY = self.headImage.viewCenterY;
    self.arrawImage.viewX = self.viewWidth - self.arrawImage.viewWidth;
    
    CGFloat maxNameMarge = self.arrawImage.viewX - CGRectGetMaxX(self.headImage.frame) - 24 / 3.0 - 40 / 3.0 - self.sexImage.viewWidth - 24 / 3.0;
    
    CGSize nameSize = [NSString caculateTextSize:self.name];
    if ( nameSize.width > maxNameMarge )
        nameSize.width = maxNameMarge;
    self.name.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame) + 24.0 / 3.0, horizontal_marge, nameSize.width, nameSize.height);
    
    self.sexImage.viewX = CGRectGetMaxX(self.name.frame) + 24.0 / 3.0;
    
    CGFloat maxEmailMarge = self.arrawImage.viewX - CGRectGetMaxX(self.headImage.frame) - 24 / 3.0 * 2;
    CGSize emailSize = [NSString caculateTextSize:self.email];
    if ( emailSize.width > maxEmailMarge )
        emailSize.width = maxEmailMarge;
    CGFloat emailY = self.viewHeight - 40 / 3.0 - emailSize.height;
    CGFloat emailX = self.name.viewX;
    self.email.frame = CGRectMake(emailX, emailY, emailSize.width, emailSize.height);
    
    CGSize phoneSize = [NSString caculateTextSize:self.phone];
    if ( phoneSize.width > maxEmailMarge )
        phoneSize.width = maxEmailMarge;
    CGFloat phoneY = emailY - 5.0 - phoneSize.height;
    CGFloat phoneX = emailX;
    self.phone.frame = CGRectMake(phoneX, phoneY, phoneSize.width, phoneSize.height);
    
    CGSize subSize = [NSString caculateTextSize:self.subLabel];
    if ( subSize.width > maxEmailMarge )
        subSize.width = maxEmailMarge;
    CGFloat subY = phoneY - 5.0 - subSize.height;
    CGFloat subX = phoneX;
    self.subLabel.frame = CGRectMake(subX, subY, subSize.width, subSize.height);
    
}

+(int)computerTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]bigTitleFont]);
    return size.width;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
