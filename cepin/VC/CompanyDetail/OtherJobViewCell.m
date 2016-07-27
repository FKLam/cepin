//
//  OtherJobViewCell.m
//  cepin
//
//  Created by dujincai on 15/5/28.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "OtherJobViewCell.h"
#import "NSDate-Utilities.h"
#import "CPCommon.h"

@implementation OtherJobViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.jobName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 30)];
        self.jobName.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        
        self.jobName.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self addSubview:self.jobName];
        
        self.address = [[UILabel alloc]initWithFrame:CGRectMake(self.jobName.viewX + self.jobName.viewWidth, self.jobName.viewY, 50, 30)];
        self.address.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        self.address.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        [self addSubview:self.address];
        
        
        self.salary = [[UILabel alloc]initWithFrame:CGRectMake(250, 20, 50, 30)];
        self.salary.textAlignment = NSTextAlignmentRight;
        self.salary.font = [[RTAPPUIHelper shareInstance]bigTitleFont];
        self.salary.textColor = CPRecommendSaleColor;
        
        [self addSubview:self.salary];
  
        
        self.companyName = [[UILabel alloc]initWithFrame:CGRectMake(10, self.jobName.viewHeight + self.jobName.viewY + 10, 200, 30)];
        [self addSubview:self.companyName];
        
        self.companyName.font = [[RTAPPUIHelper shareInstance]titleFont];
        self.companyName.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(self.companyName.viewX + self.viewWidth, self.companyName.viewY, 50, 30)];
        self.time.font = [[RTAPPUIHelper shareInstance]subTitleFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        [self addSubview:self.time];
        self.time.textAlignment = NSTextAlignmentLeft;
        
        UIView *line = [[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [line  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.height.equalTo(@(1));
        }];
    }
    return self;
}


- (void)layoutSubviews
{
    int width = [[self class]computerWidth:self.salary.text];
    int positionWith =  MIN([[self class]computerTextWidth:self.jobName.text], IS_IPHONE_5?(self.viewWidth - width - 45 - 40):(self.viewWidth - width - 50 - 40));
    int companyWith = MIN([[self class]computerTitleTextWidth:self.companyName.text], IS_IPHONE_5?(self.viewWidth - width - 60 - 40):(self.viewWidth - width - 70 - 40));
    
    self.jobName.frame =CGRectMake(20, IS_IPHONE_5?15:18, positionWith, IS_IPHONE_5?12:14.4);
    self.salary.frame = CGRectMake(kScreenWidth- width-40, self.jobName.viewY, width + 10, 15);

    self.address.frame = CGRectMake(self.jobName.viewX + self.jobName.viewWidth, self.jobName.viewY, IS_IPHONE_5?45:50, IS_IPHONE_5?12 :14.4);
    
    self.companyName.frame = CGRectMake(self.jobName.viewX, self.jobName.viewY + self.jobName.viewHeight + 8, companyWith, IS_IPHONE_5?11:12.6);
    self.time.frame = CGRectMake(self.companyName.viewX + self.companyName.viewWidth, self.companyName.viewY, IS_IPHONE_5?60:70, IS_IPHONE_5?11:12.6);
}

+(int)computerTitleTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]titleFont]);
    return size.width + 5;
}

+(int)computerWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]bigTitleFont]);
    return size.width;
}
+(int)computerTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]mainTitleFont]);
    return size.width+5;
}

- (void)createOtherJobCellWith:(CompanyPositionModel *)model
{
    
    self.jobName.text = model.PositionName;
    self.address.text = [NSString stringWithFormat:@"-%@",model.Address];
    self.companyName.text = model.CompanyName;
    
    NSString *str =[NSDate cepinJobYearMonthDayFromString:model.PublishDate];
    if (!str ||[str isEqualToString:@""]) {
        self.time.text = @"";
    }else{
        self.time.text = [NSString stringWithFormat:@"|%@",str];
    }
    self.salary.text = model.Salary;
}


- (void)setIsChecked:(BOOL)isChecked
{
    if (isChecked) {
        self.jobName.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.companyName.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
    }else
    {
        self.jobName.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.companyName.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
