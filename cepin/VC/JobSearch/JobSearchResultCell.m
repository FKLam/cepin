//
//  JobSearchResultCell.m
//  cepin
//
//  Created by dujincai on 15/5/21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobSearchResultCell.h"
#import "NSDate-Utilities.h"
@implementation JobSearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.position = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 30)];
        self.position.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        
        self.position.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self addSubview:self.position];
        
        self.address = [[UILabel alloc]initWithFrame:CGRectMake(self.position.viewX + self.position.viewWidth, self.position.viewY, 50, 30)];
        self.address.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        self.address.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        [self addSubview:self.address];
        self.salary = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 200, 30)];
        self.salary.textAlignment = NSTextAlignmentRight;
        self.salary.font = [[RTAPPUIHelper shareInstance]bigTitleFont];
        self.salary.textColor = [[RTAPPUIHelper shareInstance]labelColorBlue];
        
        [self addSubview:self.salary];
    
        
        self.company = [[UILabel alloc]initWithFrame:CGRectMake(10, self.position.viewHeight + self.position.viewY + 10, 200, 30)];
        [self addSubview:self.company];
        
        self.company.font = [[RTAPPUIHelper shareInstance]titleFont];
        self.company.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(self.company.viewX + self.viewWidth, self.company.viewY, 50, 30)];
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
            make.height.equalTo(@(0.5));
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    int width = [[self class]computerWidth:self.salary.text];
    int positionWith =  MIN([[self class]computerTextWidth:self.position.text], IS_IPHONE_5?(self.viewWidth - width - 45 - 30):(self.viewWidth - width - 50 - 20));
    int companyWith = MIN([[self class]computerTitleTextWidth:self.company.text], IS_IPHONE_5?(self.viewWidth - width - 60 - 15):(self.viewWidth - width - 70 - 15));
    
    self.position.frame =CGRectMake(20, IS_IPHONE_5?15:18, positionWith, IS_IPHONE_5?13:15);
    self.salary.frame = CGRectMake(kScreenWidth- width-30, self.position.viewY, width + 10, 20);

    self.address.frame = CGRectMake(self.position.viewX + self.position.viewWidth, self.position.viewY, IS_IPHONE_5?45:50, IS_IPHONE_5?12 :14.4);
    
    self.company.frame = CGRectMake(self.position.viewX, self.position.viewY + self.position.viewHeight + 8, companyWith, IS_IPHONE_5?11:12.6);
    self.time.frame = CGRectMake(self.company.viewX + self.company.viewWidth, self.company.viewY, IS_IPHONE_5?60:70, IS_IPHONE_5?11:12.6);
}

+(int)computerTitleTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]titleFont]);
    return size.width +5;
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

- (void)configureModel:(JobSearchModel *)model
{
    self.position.text = model.PositionName;
    self.address.text = [NSString stringWithFormat:@"-%@",model.City];
    self.company.text = model.CompanyName;
    self.salary.text = model.Salary;
    self.time.text = [NSString stringWithFormat:@"|%@",[NSDate cepinJobYearMonthDayFromString:model.PublishDate]];
}

- (void)setIsChecked:(BOOL)isChecked
{
    if (isChecked) {
        self.position.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.company.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
    }else
    {
        self.position.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.company.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
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
