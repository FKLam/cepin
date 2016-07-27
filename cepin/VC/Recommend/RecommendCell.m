//
//  RecommendCell.m
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "RecommendCell.h"
#import "NSDate-Utilities.h"
#import "CompanyDetailModelDTO.h"
#import "CPCommon.h"

@implementation RecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //职位
        self.position = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
        self.position.font = [[RTAPPUIHelper shareInstance]mainTitleFont];
        self.position.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self addSubview:self.position];
    
        self.resumeTypeImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.position.viewWidth + self.position.viewX, self.position.viewY, 30, 30)];
        self.resumeTypeImage.image = [UIImage imageNamed:@"list_ic_edutab"];
        self.resumeTypeImage.hidden = NO;
        [self addSubview:self.resumeTypeImage];
        
        
        self.topImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.resumeTypeImage.viewWidth + self.resumeTypeImage.viewX, self.resumeTypeImage.viewY, 30, 30)];
        self.topImage.image = [UIImage imageNamed:@"ic_totop"];
        self.topImage.hidden = NO;
        [self addSubview:self.topImage];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-80, 10, 40, 30)];
        self.time.font = [[RTAPPUIHelper shareInstance]subTitleFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.time.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.time];
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.equalTo(@(40));
//            make.height.equalTo(self.position.mas_height);
            make.top.equalTo(self.mas_top).offset(IS_IPHONE_5?15:18);
        }];

       //地点
        self.locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.position.viewX,  self.position.viewY + self.position.viewHeight, 20, 20)];
        self.locationImage.image = [UIImage imageNamed:@"list_ic_location_s"];
        self.locationImage.hidden = NO;
        [self addSubview:self.locationImage];

        self.address = [[UILabel alloc]initWithFrame:CGRectMake(self.locationImage.viewX+self.locationImage.viewWidth+2, self.locationImage.viewY, 50, 30)];
        self.address.font = [[RTAPPUIHelper shareInstance]subTitleFont];
        self.address.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.address];
        
        //经验
        self.experienceImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.address.viewX+self.address.viewWidth+8,  self.address.viewY, 20, 20)];
        self.experienceImage.image = [UIImage imageNamed:@"list_ic_history_s"];
        self.experienceImage.hidden = YES;
        [self addSubview:self.experienceImage];
        
        self.experience = [[UILabel alloc]initWithFrame:CGRectMake(self.experienceImage.viewX+self.experienceImage.viewWidth+2,  self.address.viewY, 50, 30)];
        self.experience.font = [[RTAPPUIHelper shareInstance]subTitleFont];
        self.experience.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.experience.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.experience];
        
        //学历
        self.xueliImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.experience.viewX+self.experience.viewWidth+8,  self.experienceImage.viewY, 20, 20)];
        self.xueliImage.image = [UIImage imageNamed:@"list_ic_graduationhat"];
        self.xueliImage.hidden = YES;
        [self addSubview:self.xueliImage];
        
        self.xueli = [[UILabel alloc]initWithFrame:CGRectMake(self.xueliImage.viewX+self.xueliImage.viewWidth+2,  self.xueliImage.viewY, 50, 30)];
        self.xueli.font = [[RTAPPUIHelper shareInstance]subTitleFont];
        self.xueli.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.xueli.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.xueli];

        
        self.salary = [[UILabel alloc]initWithFrame:CGRectZero];
        self.salary.textAlignment = NSTextAlignmentRight;
        self.salary.font = [[RTAPPUIHelper shareInstance] bigTitleFont];
        self.salary.textColor = CPRecommendSaleColor;
        [self addSubview:self.salary];
        [self.salary mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.equalTo(@(70));
            make.height.equalTo(@(15));
            make.top.equalTo(self.time.mas_bottom).offset(10);
        }];
        
    
        self.company = [[UILabel alloc]initWithFrame:CGRectMake(self.position.viewX, self.locationImage.viewY + self.locationImage.viewHeight, 200, 30)];
        [self addSubview:self.company];
        self.company.font = [[RTAPPUIHelper shareInstance]titleFont];
        self.company.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];

        //职位诱惑区域
        self.WelfareView = [[UIView alloc]initWithFrame:CGRectMake(self.position.viewX, self.company.viewY+self.company.viewHeight+5, self.viewWidth, 20)];
        [self addSubview:self.WelfareView];
        
        
        
        UIView *line = [[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [line  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.height.equalTo(@(0.5));
        }];
    }
    return self;
}

- (void)layoutSubviews
{

    int width = [[self class]computerWidth:self.time.text];
    int awidth = [[self class]computerWidth:self.address.text];
    int positionWith =  MIN([[self class]computerTextWidth:self.position.text], IS_IPHONE_5?(self.viewWidth - width  - 21 - 31):(self.viewWidth - width - 25 - 35));
    if (self.isTop && self.isSchool) {
        self.position.frame =CGRectMake(10,  IS_IPHONE_5?13:16, positionWith, IS_IPHONE_5?12:14.4);
        self.resumeTypeImage.frame = CGRectMake(self.position.viewX + self.position.viewWidth, self.position.viewY-5, IS_IPHONE_5?21:25, IS_IPHONE_5?21:25);
        self.topImage.frame = CGRectMake(0, 0, 0, 0);
    }else if(self.isTop && !self.isSchool)
    {
        self.position.frame =CGRectMake(10, IS_IPHONE_5?13:16, positionWith, IS_IPHONE_5?12:14.4);
        self.topImage.frame = CGRectMake(0, 0, 0, 0);
        self.resumeTypeImage.frame = CGRectMake(0, 0, 0, 0);
    }else if(self.isSchool && !self.isTop ){
        self.position.frame =CGRectMake(10,  IS_IPHONE_5?13:16, positionWith, IS_IPHONE_5?12:14.4);
        self.resumeTypeImage.frame = CGRectMake(self.position.viewX + self.position.viewWidth, self.position.viewY-5, IS_IPHONE_5?21:25, IS_IPHONE_5?21:25);
        self.topImage.frame = CGRectMake(self.resumeTypeImage.viewX + self.resumeTypeImage.viewWidth, self.position.viewY-5, IS_IPHONE_5?21:25, IS_IPHONE_5?21:25);
    }else{
        self.position.frame =CGRectMake(10, IS_IPHONE_5?13:16, positionWith, IS_IPHONE_5?12:14.4);
        self.topImage.frame = CGRectMake(self.position.viewX + self.position.viewWidth, self.position.viewY-5, IS_IPHONE_5?21:25, IS_IPHONE_5?21:25);
        self.resumeTypeImage.frame = CGRectMake(0, 0, 0, 0);
    }
    self.locationImage.frame = CGRectMake(self.position.viewX,  self.position.viewY + self.position.viewHeight+10, 15, 15);
    self.address.frame = CGRectMake(self.locationImage.viewX+self.locationImage.viewWidth+3, self.locationImage.viewY+2, awidth, IS_IPHONE_5?10:12.4);
    
    //判断是否显示学历跟经验
    if (self.hasXueli && self.hasExperience) {
        int xueliwidth = [[self class]computerWidth:self.xueli.text];
        int experiencewidth = [[self class]computerWidth:self.experience.text];
        self.experienceImage.frame  = CGRectMake(self.address.viewX+self.address.viewWidth+8,  self.locationImage.viewY, 15, 15);
        self.experience.frame  = CGRectMake(self.experienceImage.viewX+self.experienceImage.viewWidth+3,  self.address.viewY, experiencewidth, IS_IPHONE_5?10:12.4);
        
        self.xueliImage.frame = CGRectMake(self.experience.viewX+self.experience.viewWidth+8,  self.locationImage.viewY, 15, 15);
        self.xueli.frame = CGRectMake(self.xueliImage.viewX+self.xueliImage.viewWidth+3,  self.address.viewY, xueliwidth, IS_IPHONE_5?10:12.4);
        
    }else if(self.hasXueli && !self.hasExperience){
        int xueliwidth = [[self class]computerWidth:self.xueli.text];
        self.xueliImage.frame  = CGRectMake(self.address.viewX+self.address.viewWidth+8,  self.locationImage.viewY, 15, 15);
        self.xueli.frame  = CGRectMake(self.xueliImage.viewX+self.xueliImage.viewWidth+3,  self.address.viewY, xueliwidth, IS_IPHONE_5?10:12.4);
        self.experienceImage.frame  = CGRectZero;
        self.experience.frame  = CGRectZero;
    }else if(self.hasExperience && !self.hasXueli){
        int experiencewidth = [[self class]computerWidth:self.experience.text];
        self.experienceImage.frame  = CGRectMake(self.address.viewX+self.address.viewWidth+8,  self.locationImage.viewY, 15, 15);
        self.experience.frame  = CGRectMake(self.experienceImage.viewX+self.experienceImage.viewWidth+3,  self.address.viewY, experiencewidth, IS_IPHONE_5?10:12.4);
        self.xueliImage.frame  = CGRectZero;
        self.xueli.frame  = CGRectZero;
    }else{
        self.experienceImage.frame  = CGRectZero;
        self.experience.frame  = CGRectZero;
        self.xueliImage.frame  = CGRectZero;
        self.xueli.frame  = CGRectZero;
    }
    
    self.company.frame= CGRectMake(self.position.viewX, self.locationImage.viewY+ self.locationImage.viewHeight+2, 200, 20);
    if(nil == self.tagArray || self.tagArray.count==0){
        self.WelfareView.frame  = CGRectZero;
        [self.WelfareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }else{
    self.WelfareView.frame = CGRectMake(self.position.viewX, self.company.viewY+self.company.viewHeight+5, self.viewWidth, IS_IPHONE_5?18:25);
    [self.WelfareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int sum = 0;
    for (int i = 0; i<self.tagArray.count; i++) {
        NSString *tag = self.tagArray[i];
        int tagWidth = [[self class]computerWidth:tag];
        if(i==0){
           sum +=tagWidth;
        }else{
            sum +=tagWidth+10;
        }
        if(sum>=self.viewWidth){
            break;
        }
        if(i==0){
            UIButton *tagView = [UIButton buttonWithType:UIButtonTypeCustom];
            tagView.frame =CGRectMake(0,0,tagWidth, self.WelfareView.viewHeight);
            tagView.titleLabel.font = [[RTAPPUIHelper shareInstance]subTitleFont];
            tagView.tintColor = [[RTAPPUIHelper shareInstance]subTitleColor];
            tagView.layer.masksToBounds = YES;
            [tagView.layer setBorderWidth:0.5]; //边框宽度
            CGColorRef cgColor = [[RTAPPUIHelper shareInstance]subTitleColor].CGColor;
            [tagView.layer setBorderColor:cgColor];//边框颜色
            tagView.backgroundColor = [UIColor whiteColor];
            [tagView setTitleColor:[[RTAPPUIHelper shareInstance]subTitleColor] forState:UIControlStateNormal];
            tagView.titleLabel.textAlignment = NSTextAlignmentCenter;
            [tagView setTitle:tag forState:UIControlStateNormal];
            [self.WelfareView addSubview:tagView];
            
        }else{
            UIButton *tagView = [UIButton buttonWithType:UIButtonTypeCustom];
            tagView.frame =CGRectMake(sum-tagWidth,0,tagWidth, self.WelfareView.viewHeight);
            tagView.titleLabel.font = [[RTAPPUIHelper shareInstance]subTitleFont];
            [tagView setTitleColor:[[RTAPPUIHelper shareInstance]subTitleColor] forState:UIControlStateNormal];
            tagView.layer.masksToBounds = YES;
            [tagView.layer setBorderWidth:0.5]; //边框宽度
            CGColorRef cgColor = [[RTAPPUIHelper shareInstance]subTitleColor].CGColor;
            [tagView.layer setBorderColor:cgColor];//边框颜色
            tagView.backgroundColor =  [UIColor whiteColor];
            tagView.titleLabel.textAlignment = NSTextAlignmentCenter;
            [tagView setTitle:tag forState:UIControlStateNormal];//button title
            [self.WelfareView addSubview:tagView];
            
        }
    }
    }
    
}

+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth {     UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image; }

+(int)computerTitleTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]titleFont]);
    return size.width;
}

+(int)computerWidth:(NSString*)str
{
//    [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,nsfo,nil]]
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]bigTitleFont]);
    return size.width;
}
+(int)computerTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]mainTitleFont]);
    return size.width + 5;
}

+(int)computerWelfareWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]mainTitleFont]);
    return size.width + 5;
}


- (void)configureCompanyPositionModel:(CompanyPositionModel *)model
{
//    NSString *str = 
    if (model.IsTop.intValue == 0) {
        self.isTop = YES;
        self.topImage.hidden = YES;
    }
    else{
        self.isTop = NO;
        self.topImage.hidden = NO;
    }

    if(nil == model.WorkYear||[@"" isEqualToString:model.WorkYear] || [@"null" isEqualToString:model.WorkYear]){
        self.experienceImage.hidden = YES;
        self.experience.hidden = YES;
        self.hasExperience = NO;
    }else{
        self.experienceImage.hidden = NO;
        self.experience.hidden = NO;
        self.hasExperience = YES;
    }
    
    if(nil == model.EducationLevel||[@"" isEqualToString:model.EducationLevel] || [@"null" isEqualToString:model.EducationLevel]){
        self.xueli.hidden = YES;
        self.xueliImage.hidden = YES;
        self.hasXueli = NO;
    }else{
        self.xueliImage.hidden = NO;
        self.xueli.hidden = NO;
        self.hasXueli = YES;
    }
    
    //判断是否社招（校招）
    if(model.PositionType.intValue == 2){
        self.isSchool = NO;
        self.resumeTypeImage.hidden = YES;
    }else{
        self.isSchool = YES;
        self.resumeTypeImage.hidden = NO;
    }

    self.tagArray = [model.Welfare componentsSeparatedByString:@","];
    if(nil == self.tagArray || self.tagArray.count==0){
        self.tagArray = [model.Welfare componentsSeparatedByString:@" "];
    }
    if(nil == self.tagArray || self.tagArray.count==0){
        self.WelfareView.hidden = YES;
    }
    
    self.xueli.text = model.EducationLevel;
    self.experience.text = model.WorkYear;
    self.position.text = model.PositionName;
    self.address.text = model.City;
    self.company.text = model.CompanyName;
    self.salary.text = model.Salary;
    
    self.time.text = [NSDate cepinJobYearMonthDayFromString:model.PublishDate];
    
    
}


- (void)configureModel:(JobSearchModel *)model
{
    //    NSString *str =
    if (model.IsTop.intValue == 0) {
        self.isTop = YES;
        self.topImage.hidden = YES;
    }
    else{
        self.isTop = NO;
        self.topImage.hidden = NO;
    }
    
    if(nil == model.WorkYear||[@"" isEqualToString:model.WorkYear] || [@"null" isEqualToString:model.WorkYear]){
        self.experienceImage.hidden = YES;
        self.experience.hidden = YES;
        self.hasExperience = NO;
    }else{
        self.experienceImage.hidden = NO;
        self.experience.hidden = NO;
        self.hasExperience = YES;
    }
    
    if(nil == model.EducationLevel||[@"" isEqualToString:model.EducationLevel] || [@"null" isEqualToString:model.EducationLevel]){
        self.xueli.hidden = YES;
        self.xueliImage.hidden = YES;
        self.hasXueli = NO;
    }else{
        self.xueliImage.hidden = NO;
        self.xueli.hidden = NO;
        self.hasXueli = YES;
    }
    
    //判断是否社招（校招）
    if(model.PositionType.intValue == 2){
        self.isSchool = NO;
        self.resumeTypeImage.hidden = YES;
    }else{
        self.isSchool = YES;
        self.resumeTypeImage.hidden = NO;
    }
    
    self.tagArray = [model.Welfare componentsSeparatedByString:@","];
    if(nil == self.tagArray || self.tagArray.count==0){
        self.tagArray = [model.Welfare componentsSeparatedByString:@" "];
    }
    if(nil == self.tagArray || self.tagArray.count==0){
        self.WelfareView.hidden = YES;
    }
    
    self.xueli.text = model.EducationLevel;
    self.experience.text = model.WorkYear;
    self.position.text = model.PositionName;
    self.address.text = model.City;
    self.company.text = model.CompanyName;
    self.salary.text = model.Salary;
    
    self.time.text = [NSDate cepinJobYearMonthDayFromString:model.PublishDate];
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

#pragma mark - 根据tableView创建recommendCell
+ (instancetype)recommendCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseidentifier = @"recommendcellIdentifier";
    RecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:reuseidentifier];
    if( !recommendCell )
    {
        recommendCell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseidentifier];
    }
    return recommendCell;
}

@end
