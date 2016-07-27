//
//  CompanyCell.m
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "CompanyCell.h"
@implementation CompanyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buttonDelete.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.buttonDelete];
        
        self.deleImage = [[UIImageView alloc] init];
        self.deleImage.image = [UIImage imageNamed:@"ic_radio_null"];
        [self.contentView addSubview:self.deleImage];
        
        self.imageLogo = [[UIImageView alloc] init];
        self.imageLogo.backgroundColor = [UIColor clearColor];
        self.imageLogo.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageLogo];
        
        
        self.labelTitle = [[UILabel alloc] init];
        self.labelTitle.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.labelTitle.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        [self.contentView addSubview:self.labelTitle];
        self.isChoice = NO;
        
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.contentView addSubview:line];
        _lineView = line;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset( 40 / 3.0 );
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset ( -1.0 );
            make.height.equalTo(@(1));
        }];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat deleImageX = 40 / 3.0;
    CGFloat deleImageW = 30.0;
    CGFloat deleImageH = deleImageW;
    CGFloat deleImageY = (self.viewHeight - deleImageH) / 2.0;
    self.deleImage.frame = CGRectMake(deleImageX, deleImageY, deleImageW, deleImageH);
    
    self.buttonDelete.frame = self.deleImage.frame;
    
    CGFloat imageLogoX = CGRectGetMaxX(self.deleImage.frame) + 8.0;
    CGFloat imageLogoW = 120 / 3.0;
    CGFloat imageLogoH = imageLogoW;
    CGFloat imageLogoY = ( self.viewHeight - imageLogoH ) / 2.0;
    self.imageLogo.frame = CGRectMake(imageLogoX, imageLogoY, imageLogoW, imageLogoH);
    
    CGSize companySize = [self.labelTitle.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] profileResumeNameFont] } context:nil].size;
    CGFloat companyW = companySize.width;
    CGFloat maxMarge = self.viewWidth - CGRectGetMaxX(self.imageLogo.frame) - 2 * 8.0;
    if ( companyW > maxMarge )
        companyW = maxMarge;
    
    self.labelTitle.frame = CGRectMake(CGRectGetMaxX(self.imageLogo.frame) + 8.0, 0, companyW, self.viewHeight);
}
- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setChoice:(BOOL)isChoice
{
    _isChoice = isChoice;
    if (isChoice) {
        self.deleImage.image = [UIImage imageNamed:@"ic_radio"];
    }else{
        self.deleImage.image = [UIImage imageNamed:@"ic_radio_null"];
    }
}
-(void)configWithBean:(SaveCompanyModel*)bean
{
    self.labelTitle.text = bean.CompanyName;
    [self.imageLogo sd_setImageWithURL:[NSURL URLWithString:bean.CompanyLogo] placeholderImage:[UIImage imageNamed:@"tb_default_logo"]];
}
@end
