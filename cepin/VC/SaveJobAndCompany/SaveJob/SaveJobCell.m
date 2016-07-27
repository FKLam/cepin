//
//  SaveJobCell.m
//  cepin
//
//  Created by dujincai on 15/6/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "SaveJobCell.h"
#import "TBTextUnit.h"
#import "NSDate-Utilities.h"
@implementation SaveJobCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.buttonDelete setBackgroundImage:[UIImage imageNamed:@"ic_radio_null"] forState:UIControlStateNormal];
        self.buttonDelete.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.buttonDelete];

        self.deleImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 30, 30)];
        self.deleImage.image = [UIImage imageNamed:@"ic_radio_null"];
        [self.contentView addSubview:self.deleImage];
        
        self.positionLabel = [[UILabel alloc] init];
        self.positionLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.positionLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        [self.contentView addSubview:self.positionLabel];
        
        self.address = [[UILabel alloc] init];
        self.address.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        self.address.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        [self.contentView addSubview:self.address];
        
        self.salaryLabel = [[UILabel alloc] init];
        self.salaryLabel.textColor = [[RTAPPUIHelper shareInstance] labelColorGreen];
        self.salaryLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        [self.contentView addSubview:self.salaryLabel];
        
        self.companyLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.companyLabel];
        self.companyLabel.font = [[RTAPPUIHelper shareInstance] profileResumeMessageFont];
        self.companyLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        
        self.time = [[UILabel alloc] init];
        self.time.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        self.time.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
        [self.contentView addSubview:self.time];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.contentView addSubview:line];
        _lineView = line;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.height.equalTo(@(1));
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat horizontal_marge = 40 / 3.0;
    CGFloat vertical_marge = 40 / 3.0;
    
    CGFloat saleY = vertical_marge;
    CGSize saleSize = [self.salaryLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeOperationFont] } context:nil].size;
    CGFloat saleX = self.viewWidth - horizontal_marge - saleSize.width;
    self.salaryLabel.frame = CGRectMake(saleX, saleY, saleSize.width, saleSize.height);
    
    self.deleImage.viewX = horizontal_marge;
    self.deleImage.viewCenterY = self.salaryLabel.viewCenterY;
    
    self.buttonDelete.frame = self.deleImage.frame;
    
    CGFloat positionX = CGRectGetMaxX(self.deleImage.frame) + 8.0;
    CGFloat positionY = self.salaryLabel.viewY;
    CGSize positionSize = [self.positionLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeOperationFont] } context:nil].size;
    CGFloat positionW = positionSize.width;
    
    CGFloat addressY = self.salaryLabel.viewY;
    CGSize addressSize = [self.address.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeOperationFont] } context:nil].size;
    
    CGFloat addressX = 0;
    
    CGFloat maxMarge = self.salaryLabel.viewX - CGRectGetMaxX(self.deleImage.frame) - 3 * 8.0;
    
    if ( (positionW + addressSize.width) > maxMarge )
        positionW = maxMarge - addressSize.width;
    
    self.positionLabel.frame = CGRectMake(positionX, positionY, positionW, positionSize.height);
    
    addressX = CGRectGetMaxX(self.positionLabel.frame);
    
    self.address.frame = CGRectMake(addressX, addressY, addressSize.width, addressSize.height);
    
    CGFloat companyX = self.positionLabel.viewX;
    CGFloat companyY = CGRectGetMaxY(self.salaryLabel.frame) + 8.0;
    CGSize companySize = [self.companyLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeMessageFont] } context:nil].size;
    CGFloat companyW = companySize.width;
    
    CGFloat timeY = CGRectGetMaxY(self.salaryLabel.frame) + 8.0;
    CGSize timeSize = [self.time.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont] } context:nil].size;
    CGFloat timeW = timeSize.width;
    
    maxMarge = self.viewWidth - CGRectGetMaxX(self.deleImage.frame) - 8 * 3;
    
    if ( timeW + companyW > maxMarge )
        companyW = maxMarge - timeW;
    
    self.companyLabel.frame = CGRectMake(companyX, companyY, companyW, companySize.height);
    
    CGFloat timeX = CGRectGetMaxX(self.companyLabel.frame);
    self.time.frame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);

}

+(int)computerWith:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]titleFont]);
    return size.width;
}


+(int)computerSalaryWith:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]bigTitleFont]);
    return size.width+5;
}
+(int)computerTextWidth:(NSString*)str
{
    CGSize size = StringFontSize(str, [[RTAPPUIHelper shareInstance]mainTitleFont]);
    return size.width;
}

-(void)setChoice:(BOOL)isChoice
{
    _isChoice = isChoice;
    if (isChoice) {
//        [self.buttonDelete setImage:[UIImage imageNamed:@"ic_radio"] forState:UIControlStateNormal];
        self.deleImage.image = [UIImage imageNamed:@"ic_radio"];
    }else{
//        [self.buttonDelete setImage:[UIImage imageNamed:@"ic_radio_null"] forState:UIControlStateNormal];
        self.deleImage.image = [UIImage imageNamed:@"ic_radio_null"];
    }
}

-(void)configWithSaveBean:(SaveJobDTO*)bean
{
    self.positionLabel.text = bean.PositionName;
    self.address.text = [NSString stringWithFormat:@" - %@",bean.City];
    self.companyLabel.text = bean.CompanyName;
    self.salaryLabel.text = bean.Salary;
    NSArray *array = [bean.PublishDate componentsSeparatedByString:@" "];
    NSString *data = array[0];
    self.time.text = [NSString stringWithFormat:@" | %@",data];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
