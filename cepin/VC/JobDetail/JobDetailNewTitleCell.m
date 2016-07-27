//
//  JobDetailNewTitleCell.m
//  cepin
//
//  Created by zhu on 15/1/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobDetailNewTitleCell.h"
#import "TBTextUnit.h"
#import "NSDate-Utilities.h"
#import "JobDetailLabelCell.h"

@implementation JobDetailNewTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.backgroundColor = [[RTAPPUIHelper shareInstance]shadeColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *viewcell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 135)];
        viewcell.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:viewcell];
        
        self.positionName = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth - 20 * 2, 30)];
        self.positionName.font = [[RTAPPUIHelper shareInstance] jobInformationPositionFont];
        self.positionName.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.positionName.numberOfLines = 0;
        [self addSubview:self.positionName];
        
        self.salary = [[UILabel alloc]initWithFrame:CGRectMake(20, self.positionName.viewHeight +self.positionName.viewY, 100, 30)];
        self.salary.font = [[RTAPPUIHelper shareInstance] jobInformationSaleFont];
        self.salary.textColor = [[RTAPPUIHelper shareInstance]labelColorGreen];
        [self addSubview:self.salary];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(self.salary.viewWidth + self.salary.viewX, self.salary.viewY, 100, 30)];
        self.time.font = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        [self addSubview:self.time];
        
        self.informationLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.salary.viewY + self.salary.viewHeight, 300, 30)];
        self.informationLabel.font = [[RTAPPUIHelper shareInstance] jobInformationDetaillFont];
        self.informationLabel.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        self.informationLabel.numberOfLines = 0;
        [self addSubview:self.informationLabel];
        
        self.companyName = [[UILabel alloc]initWithFrame:CGRectMake(20, self.informationLabel.viewHeight + self.informationLabel.viewY, 300, 30)];
        self.companyName.font = [[RTAPPUIHelper shareInstance] jobInformationCompanyFont];
        self.companyName.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.companyName.numberOfLines = 0;
        [self addSubview:self.companyName];
   
    }
    return self;
}

+(int)computerTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]mainTitleFont]);
    return size.width + 10;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 职位
    self.positionName.frame = self.informationFrame.positionFrame;
    
    // 薪水
    self.salary.frame = self.informationFrame.saleFrame;
    
    // 具体详情
    self.informationLabel.frame = self.informationFrame.informatonFrame;
    
    // 公司名称
    self.companyName.frame = self.informationFrame.companyNameFrame;
}

- (void)getModelWith:(JobDetailModelDTO*)model
{
    self.positionName.text = model.PositionName;
    
    NSString *tempSaleStr = [NSString stringWithFormat:@"%@ %@", model.Salary, @"/月"];
    self.salary.text = tempSaleStr;
//    self.time.text = [NSString stringWithFormat:@"|%@",[NSDate cepinJobYearMonthDayFromString:model.PublishDate]];
    self.companyName.text = model.CompanyName;
    
#pragma mark - 修改职位详情的文字显示
    NSString *person = model.PersonNumber?[NSString stringWithFormat:@"%@人",model.PersonNumber]:@"";
    NSString *age = model.Age ? [NSString stringWithFormat:@"%@岁", model.Age] : @"";
    self.informationLabel.text = [TBTextUnit jobDetailWithAddress:model.City function:model.PositionNature educationLevel:model.EducationLevel age:age experience:model.WorkYear time:[NSDate cepinJobYearMonthDayFromString:model.PublishDate] PersonNumber:person];
}

#pragma mark - setter
- (void)setInformationFrame:(CPJobInformationFrame *)informationFrame
{
    if ( _informationFrame == informationFrame )
        return;
    
    _informationFrame = informationFrame;
}


@end
