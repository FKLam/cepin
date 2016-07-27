//
//  FullInformationCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullInformationCell.h"
#import "TBTextUnit.h"
#import "BaseCodeDTO.h"
#import "NSString+Extension.h"
#import "CPCommon.h"

/** 水平边距 */
#define SCHOOL_HORIZONTAL_MARGE ( 40.0 / 3.0 )
/** 水平间距 */
#define SCHOOL_HORIZONTAL_SPACE ( 40.0 / 3.0 )
/** 垂直间距 */
#define SCHOOL_VERTICAL_SPACE 10.0
/** 标题颜色 */
#define SCHOOL_SUBTITLE_COLOR [[RTAPPUIHelper shareInstance]  profileBaseInformatonColor]
/** 内容颜色 */
#define SCHOOL_CONTENT_COLOR [[RTAPPUIHelper shareInstance]  profileBaseInformationRColor]
/** 标题字体 */
#define SCHOOL_SUBTITLE_FONT [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont]
/** 内容字体 */
#define SCHOOL_CONTENT_FONT [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont]


@interface FullInformationCell ()

@property (nonatomic, weak) UILabel *nativePlaceLabel;
@property (nonatomic, weak) UILabel *nationLabel;
@property (nonatomic, weak) UILabel *qqNumberLabel;
@property (nonatomic, weak) UILabel *graduationTimeLabel;
@property (nonatomic, weak) UILabel *contentHeightLabel;
@property (nonatomic, weak) UILabel *weightLabel;
@property (nonatomic, weak) UILabel *healthLabel;
@property (nonatomic, weak) UILabel *identityCardLabel;
@property (nonatomic, weak) UILabel *postalCodeLabel;
@property (nonatomic, weak) UILabel *emergencyContactLabel;
@property (nonatomic, weak) UILabel *emergencyContactInfLabel;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UILabel *politicsLabel;


@end

@implementation FullInformationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int hight = IS_IPHONE_5?14:15;
        int width = IS_IPHONE_5?56:60;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 102 / 3.0)];
        baseView.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.contentView addSubview:baseView];
        self.basicLabel = [[UILabel alloc]initWithFrame:CGRectMake( SCHOOL_HORIZONTAL_MARGE, baseView.viewY, self.viewWidth - 40, baseView.viewHeight)];
        self.basicLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.basicLabel.text = @"基本信息";
        self.basicLabel.textColor = [[RTAPPUIHelper shareInstance] labelColorGreen];
        self.basicLabel.backgroundColor = CPColor(0xf0, 0xef, 0xf5, 1.0);
        [self.contentView  addSubview:self.basicLabel];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake( SCHOOL_HORIZONTAL_MARGE, self.basicLabel.viewHeight +self.basicLabel.viewY+ 7, self.viewWidth - 45 - 60, hight)];
        self.name.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.name.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        [self.contentView addSubview:self.name];
        
        self.person = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 60 - 20, self.name.viewY, 60, 60)];
        self.person.image = [UIImage imageNamed:@"ic_user"];
        self.person.layer.masksToBounds = YES;
        self.person.layer.cornerRadius = 30;
        [self.contentView addSubview:self.person];
        
        self.sexAndOther = [[UILabel alloc]initWithFrame:CGRectMake( SCHOOL_HORIZONTAL_MARGE, self.name.viewY + self.name.viewHeight + 10, self.viewWidth - self.person.viewWidth - 45, hight)];
        self.sexAndOther.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.sexAndOther.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        [self.contentView addSubview:self.sexAndOther];
        
        UILabel *emailLabel = [[UILabel alloc] init];
        emailLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        emailLabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        emailLabel.text = @"常用邮箱:";
        emailLabel.frame = CGRectMake( SCHOOL_HORIZONTAL_MARGE, self.sexAndOther.viewY + self.sexAndOther.viewHeight + SCHOOL_HORIZONTAL_SPACE, [self widthWithUIControl:emailLabel], hight);
        [self.contentView addSubview:emailLabel];
        self.email = [[UILabel alloc] initWithFrame:CGRectMake( SCHOOL_HORIZONTAL_MARGE + CGRectGetMaxX(emailLabel.frame), emailLabel.viewY, self.viewWidth - emailLabel.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE, hight + 1.0)];
        self.email.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.email.alpha = 0.87;
        self.email.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        [self.contentView addSubview:self.email];
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        phoneLabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        phoneLabel.text = @"联系电话:";
        phoneLabel.frame = CGRectMake(SCHOOL_HORIZONTAL_MARGE, CGRectGetMaxY(self.email.frame) + 10, [self widthWithUIControl:phoneLabel], hight);
        [self.contentView addSubview:phoneLabel];
        self.phone = [[UILabel alloc]initWithFrame:CGRectMake(SCHOOL_HORIZONTAL_MARGE + CGRectGetMaxX(phoneLabel.frame), phoneLabel.viewY, self.viewWidth - phoneLabel.viewWidth - SCHOOL_HORIZONTAL_MARGE * 3, hight)];
        self.phone.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.phone.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        [self.contentView addSubview:self.phone];
        
        UILabel *marriageLabel = [[UILabel alloc] init];
        marriageLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        marriageLabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        marriageLabel.text = @"婚姻状况:";
        marriageLabel.frame = CGRectMake(SCHOOL_HORIZONTAL_MARGE, CGRectGetMaxY(self.phone.frame) + 10.0, [self widthWithUIControl:marriageLabel], hight);
        [self.contentView addSubview:marriageLabel];
        self.marriage = [[UILabel alloc] initWithFrame:CGRectMake(SCHOOL_HORIZONTAL_MARGE + CGRectGetMaxX(marriageLabel.frame), marriageLabel.viewY, self.viewWidth - marriageLabel.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE, hight)];
        self.marriage.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.marriage.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        [self.contentView addSubview:self.marriage];
        
        UILabel *raginLabel = [[UILabel alloc] init];
        raginLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        raginLabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        raginLabel.text = @"现居住地:";
        raginLabel.frame = CGRectMake(SCHOOL_HORIZONTAL_MARGE, CGRectGetMaxY(self.marriage.frame) + 10.0, [self widthWithUIControl:raginLabel], hight);
        [self.contentView addSubview:raginLabel];
        self.region = [[UILabel alloc]initWithFrame:CGRectMake(SCHOOL_HORIZONTAL_MARGE + CGRectGetMaxX(raginLabel.frame), raginLabel.viewY, self.viewWidth - raginLabel.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE, hight)];
        self.region.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.region.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        [self.contentView addSubview:self.region];

        
        UILabel *familyLabel = [[UILabel alloc] init];
        familyLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        familyLabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        familyLabel.text = @"所在户籍:";
        familyLabel.frame = CGRectMake(SCHOOL_HORIZONTAL_MARGE, CGRectGetMaxY(self.region.frame) + 10.0, [self widthWithUIControl:familyLabel], hight);
        [self.contentView addSubview:familyLabel];
        self.FamilyRegister = [[UILabel alloc]initWithFrame:CGRectMake(SCHOOL_HORIZONTAL_MARGE + CGRectGetMaxX(familyLabel.frame), familyLabel.viewY, self.viewWidth - familyLabel.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE, hight)];
        self.FamilyRegister.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        self.FamilyRegister.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        [self.contentView addSubview:self.FamilyRegister];
        
        // 籍贯
        UILabel *nativePlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.FamilyRegister.viewY + self.FamilyRegister.viewHeight + 10, width, hight)];
        nativePlaceLabel.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformatonColor];
        nativePlaceLabel.font = [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont];
        nativePlaceLabel.text = @"籍 贯 :";
        nativePlaceLabel.frame = CGRectMake(SCHOOL_HORIZONTAL_MARGE, 10.0 + CGRectGetMaxY(self.FamilyRegister.frame), [self widthWithUIControl:nativePlaceLabel], hight);
        [self.contentView addSubview:nativePlaceLabel];
        _nativePlaceLabel = nativePlaceLabel;
        self.nativePlace = [[UILabel alloc] initWithFrame:CGRectMake(SCHOOL_HORIZONTAL_MARGE + CGRectGetMaxX(nativePlaceLabel.frame), nativePlaceLabel.viewY, self.viewWidth - nativePlaceLabel.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE, hight)];
        self.nativePlace.textColor = [[RTAPPUIHelper shareInstance]  profileBaseInformationRColor];
        self.nativePlace.font = [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont];
        [self.contentView addSubview:self.nativePlace];
        
        // 民族
        UILabel *nationLabel = [[UILabel alloc] init];
        nationLabel.textColor = [[RTAPPUIHelper shareInstance]  profileBaseInformatonColor];
        nationLabel.font = [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont];
        nationLabel.text = @"民 族 :";
        nationLabel.frame = CGRectMake(SCHOOL_HORIZONTAL_MARGE, 10.0 + CGRectGetMaxY(self.nativePlace.frame), [self widthWithUIControl:nationLabel], hight);
        [self.contentView addSubview:nationLabel];
        _nationLabel = nationLabel;
        
#pragma mark - 修改文字显示的长度
        self.nation = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nationLabel.frame) + SCHOOL_HORIZONTAL_MARGE, nationLabel.viewY, self.viewWidth - SCHOOL_HORIZONTAL_MARGE * 3, hight)];
        self.nation.textColor = [[RTAPPUIHelper shareInstance]  profileBaseInformationRColor];
        self.nation.font = [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont];
        [self.contentView addSubview:self.nation];
        
        // QQ号码
        UILabel *qqNumberLabel = [[UILabel alloc] init];
        qqNumberLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        qqNumberLabel.viewY = CGRectGetMaxY(self.nation.frame) + SCHOOL_VERTICAL_SPACE;
        qqNumberLabel.viewWidth = width;
        qqNumberLabel.viewHeight = hight;
        qqNumberLabel.textColor = [[RTAPPUIHelper shareInstance]  profileBaseInformatonColor];
        qqNumberLabel.font = [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont];
        qqNumberLabel.text = @"qq号码:";
        qqNumberLabel.frame = CGRectMake(SCHOOL_HORIZONTAL_MARGE, 10.0 + CGRectGetMaxY(self.nation.frame), [self widthWithUIControl:qqNumberLabel], hight);
        [self.contentView addSubview:qqNumberLabel];
        _qqNumberLabel = qqNumberLabel;
        self.qqNumber = [[UILabel alloc] init];
        self.qqNumber.viewX = CGRectGetMaxX(qqNumberLabel.frame) + SCHOOL_HORIZONTAL_MARGE;
        self.qqNumber.viewY = qqNumberLabel.viewY;
        self.qqNumber.viewWidth = self.viewWidth - qqNumberLabel.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE;
        self.qqNumber.viewHeight = hight;
        self.qqNumber.textColor = [[RTAPPUIHelper shareInstance]  profileBaseInformationRColor];
        self.qqNumber.font = [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont];
        [self.contentView addSubview:self.qqNumber];
        
        // 政治面貌
        UILabel *politicsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.qqNumber.viewY + self.qqNumber.viewHeight + 10, width, hight)];
        politicsLabel.textColor = [[RTAPPUIHelper shareInstance]  profileBaseInformatonColor];
        politicsLabel.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        politicsLabel.text = @"政治面貌:";
        politicsLabel.frame = CGRectMake(SCHOOL_HORIZONTAL_MARGE, 10.0 + CGRectGetMaxY(self.qqNumber.frame), [self widthWithUIControl:politicsLabel], hight);
        [self.contentView addSubview:politicsLabel];
        _politicsLabel = politicsLabel;
        UILabel *politicsStatus = [[UILabel alloc]initWithFrame:CGRectMake(SCHOOL_HORIZONTAL_MARGE + CGRectGetMaxX(politicsLabel.frame), politicsLabel.viewY, self.viewWidth - politicsLabel.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE, hight)];
        politicsStatus.textColor = [[RTAPPUIHelper shareInstance] profileBaseInformationRColor];
        politicsStatus.font = [[RTAPPUIHelper shareInstance] profileBaseInformationRFont];
        [self.contentView addSubview:politicsStatus];
        _politicsStatus = politicsStatus;
        
        // 毕业时间
        UILabel *graduationTimeLabel = [[UILabel alloc] init];
        graduationTimeLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        graduationTimeLabel.viewY = CGRectGetMaxY(self.politicsStatus.frame) + SCHOOL_VERTICAL_SPACE;
        graduationTimeLabel.viewHeight = hight;
        graduationTimeLabel.textColor = SCHOOL_SUBTITLE_COLOR;
        graduationTimeLabel.font = SCHOOL_SUBTITLE_FONT;
        graduationTimeLabel.text = @"毕业时间:";
        graduationTimeLabel.viewWidth = [self widthWithUIControl:graduationTimeLabel];
        [self.contentView addSubview:graduationTimeLabel];
        _graduationTimeLabel = graduationTimeLabel;
        UILabel *graduationTime = [[UILabel alloc] init];
        graduationTime.viewX = CGRectGetMaxX(graduationTimeLabel.frame) + SCHOOL_HORIZONTAL_MARGE;
        graduationTime.viewY = graduationTimeLabel.viewY;
        graduationTime.viewHeight = hight;
        graduationTime.viewWidth = self.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE - graduationTimeLabel.viewWidth;
        graduationTime.textColor = SCHOOL_CONTENT_COLOR;
        graduationTime.font = SCHOOL_CONTENT_FONT;
        [self.contentView addSubview:graduationTime];
        _graduationTime = graduationTime;
        
        // 身高(cm)
        UILabel *heightLabel = [[UILabel alloc] init];
        heightLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        heightLabel.viewY = CGRectGetMaxY(self.graduationTime.frame) + SCHOOL_VERTICAL_SPACE;
        heightLabel.viewHeight = hight;
        heightLabel.textColor = SCHOOL_SUBTITLE_COLOR;
        heightLabel.font = SCHOOL_SUBTITLE_FONT;
        heightLabel.text = @"身高(cm):";
        heightLabel.viewWidth = [self widthWithUIControl:heightLabel];
        [self.contentView addSubview:heightLabel];
        _contentHeightLabel = heightLabel;
        self.contentHeight = [[UILabel alloc] init];
        self.contentHeight.viewX = CGRectGetMaxX(heightLabel.frame) + SCHOOL_HORIZONTAL_MARGE;
        self.contentHeight.viewY = heightLabel.viewY;
        self.contentHeight.viewHeight = hight;
        self.contentHeight.viewWidth = self.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE - heightLabel.viewWidth;
        self.contentHeight.textColor = SCHOOL_CONTENT_COLOR;
        self.contentHeight.font = SCHOOL_CONTENT_FONT;
        [self.contentView addSubview:self.contentHeight];
        
        // 体重(kg)
        UILabel *weightLabel = [[UILabel alloc] init];
        weightLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        weightLabel.viewY = CGRectGetMaxY(self.contentHeight.frame) + SCHOOL_VERTICAL_SPACE;
        weightLabel.viewHeight = hight;
        weightLabel.textColor = SCHOOL_SUBTITLE_COLOR;
        weightLabel.font = SCHOOL_SUBTITLE_FONT;
        weightLabel.text = @"体重(kg):";
        weightLabel.viewWidth = [self widthWithUIControl:weightLabel];
        [self.contentView addSubview:weightLabel];
        _weightLabel = weightLabel;
        self.weight = [[UILabel alloc] init];
        self.weight.viewX = CGRectGetMaxX(weightLabel.frame) + SCHOOL_HORIZONTAL_MARGE;
        self.weight.viewY = weightLabel.viewY;
        self.weight.viewHeight = hight;
        self.weight.viewWidth = self.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE - weightLabel.viewWidth;
        self.weight.textColor = SCHOOL_CONTENT_COLOR;
        self.weight.font = SCHOOL_CONTENT_FONT;
        [self.contentView addSubview:self.weight];
        
        // 健康情况
        UILabel *healthLabel = [[UILabel alloc] init];
        healthLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        healthLabel.viewY = CGRectGetMaxY(self.weight.frame) + SCHOOL_VERTICAL_SPACE;
        healthLabel.viewHeight = hight;
        healthLabel.textColor = SCHOOL_SUBTITLE_COLOR;
        healthLabel.font = SCHOOL_SUBTITLE_FONT;
        healthLabel.text = @"健康情况:";
        healthLabel.viewWidth = [self widthWithUIControl:healthLabel];
        [self.contentView addSubview:healthLabel];
        _healthLabel = healthLabel;
        self.health = [[UILabel alloc] init];
        self.health.viewX = CGRectGetMaxX(healthLabel.frame) + SCHOOL_HORIZONTAL_MARGE;
        self.health.viewY = healthLabel.viewY;
        self.health.viewWidth = self.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE - healthLabel.viewWidth;
        self.health.viewHeight = hight;
        self.health.textColor = SCHOOL_CONTENT_COLOR;
        self.health.font = SCHOOL_CONTENT_FONT;
        [self.contentView addSubview:self.health];
        
        // 身份证号
        UILabel *identityCardLabel = [[UILabel alloc] init];
        identityCardLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        identityCardLabel.viewY = CGRectGetMaxY(self.health.frame) + SCHOOL_VERTICAL_SPACE;
        identityCardLabel.viewHeight = hight;
        identityCardLabel.textColor = SCHOOL_SUBTITLE_COLOR;
        identityCardLabel.font = SCHOOL_SUBTITLE_FONT;
        identityCardLabel.text = @"身份证号:";
        identityCardLabel.viewWidth = [self widthWithUIControl:identityCardLabel];
        [self.contentView addSubview:identityCardLabel];
        _identityCardLabel = identityCardLabel;
        self.identityCard = [[UILabel alloc] init];
        self.identityCard.viewX = CGRectGetMaxX(identityCardLabel.frame) + SCHOOL_HORIZONTAL_MARGE;
        self.identityCard.viewY = identityCardLabel.viewY;
        self.identityCard.viewWidth = self.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE - identityCardLabel.viewWidth;
        self.identityCard.viewHeight = hight;
        self.identityCard.textColor = SCHOOL_CONTENT_COLOR;
        self.identityCard.font = SCHOOL_CONTENT_FONT;
        [self.contentView addSubview:self.identityCard];
        
        // 邮政编码
        UILabel *postalCodeLabel = [[UILabel alloc] init];
        postalCodeLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        postalCodeLabel.viewY = CGRectGetMaxY(self.identityCard.frame) + SCHOOL_VERTICAL_SPACE;
        postalCodeLabel.viewHeight = hight;
        postalCodeLabel.textColor = SCHOOL_SUBTITLE_COLOR;
        postalCodeLabel.font = SCHOOL_SUBTITLE_FONT;
        postalCodeLabel.text = @"邮政编码:";
        postalCodeLabel.viewWidth = [self widthWithUIControl:postalCodeLabel];
        [self.contentView addSubview:postalCodeLabel];
        _postalCodeLabel = postalCodeLabel;
        self.postalCode = [[UILabel alloc] init];
        self.postalCode.viewX = CGRectGetMaxX(postalCodeLabel.frame) + SCHOOL_HORIZONTAL_MARGE;
        self.postalCode.viewY = postalCodeLabel.viewY;
        self.postalCode.viewWidth = self.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE - postalCodeLabel.viewWidth;
        self.postalCode.viewHeight = hight;
        self.postalCode.textColor = SCHOOL_CONTENT_COLOR;
        self.postalCode.font = SCHOOL_CONTENT_FONT;
        [self.contentView addSubview:self.postalCode];
        
        // 紧急联系人
        UILabel *emergencyContactLabel = [[UILabel alloc] init];
        emergencyContactLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        emergencyContactLabel.viewY = CGRectGetMaxY(self.postalCode.frame) + SCHOOL_VERTICAL_SPACE;
        emergencyContactLabel.viewHeight = hight;
        emergencyContactLabel.textColor = SCHOOL_SUBTITLE_COLOR;
        emergencyContactLabel.font = SCHOOL_SUBTITLE_FONT;
        emergencyContactLabel.text = @"紧急联系人:";
        emergencyContactLabel.viewWidth = [self widthWithUIControl:emergencyContactLabel] + 10.0;
        [self.contentView addSubview:emergencyContactLabel];
        _emergencyContactLabel = emergencyContactLabel;
        self.emergencyContact = [[UILabel alloc] init];
        self.emergencyContact.viewX = CGRectGetMaxX(emergencyContactLabel.frame);
        self.emergencyContact.viewY = emergencyContactLabel.viewY;
        self.emergencyContact.viewWidth = self.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE - emergencyContactLabel.viewWidth;
        self.emergencyContact.viewHeight = hight;
        self.emergencyContact.textColor = SCHOOL_CONTENT_COLOR;
        self.emergencyContact.font = SCHOOL_CONTENT_FONT;
        [self.contentView addSubview:self.emergencyContact];
        
        // 紧急联系方式
        UILabel *emergencyContactInfLabel = [[UILabel alloc] init];
        emergencyContactInfLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        emergencyContactInfLabel.viewY = CGRectGetMaxY(self.emergencyContact.frame) + SCHOOL_VERTICAL_SPACE;
        emergencyContactInfLabel.viewHeight = hight;
        emergencyContactInfLabel.textColor = SCHOOL_SUBTITLE_COLOR;
        emergencyContactInfLabel.font = SCHOOL_SUBTITLE_FONT;
        emergencyContactInfLabel.text = @"紧急联系方式:";
        emergencyContactInfLabel.viewWidth = [self widthWithUIControl:emergencyContactInfLabel] + 10.0;
        [self.contentView addSubview:emergencyContactInfLabel];
        _emergencyContactInfLabel = emergencyContactInfLabel;
        self.emergencyContactInf = [[UILabel alloc] init];
        self.emergencyContactInf.viewX = CGRectGetMaxX(emergencyContactInfLabel.frame);
        self.emergencyContactInf.viewY = emergencyContactInfLabel.viewY;
        self.emergencyContactInf.viewWidth = self.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE - emergencyContactInfLabel.viewWidth;
        self.emergencyContactInf.viewHeight = hight;
        self.emergencyContactInf.textColor = SCHOOL_CONTENT_COLOR;
        self.emergencyContactInf.font = SCHOOL_CONTENT_FONT;
        [self.contentView addSubview:self.emergencyContactInf];
        
        // 联系地址
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.viewX = SCHOOL_HORIZONTAL_MARGE;
        addressLabel.viewY = CGRectGetMaxY(self.emergencyContactInf.frame) + SCHOOL_VERTICAL_SPACE;
        addressLabel.viewHeight = hight;
        addressLabel.textColor = [[RTAPPUIHelper shareInstance]  profileBaseInformatonColor];
        addressLabel.font = [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont];
        addressLabel.text = @"联系地址:";
        addressLabel.viewWidth = [self widthWithUIControl:addressLabel];
        [self.contentView addSubview:addressLabel];
        _addressLabel = addressLabel;
        UILabel *address = [[UILabel alloc] init];
        address.viewX = CGRectGetMaxX(addressLabel.frame) + SCHOOL_HORIZONTAL_MARGE;
        address.viewY = addressLabel.viewY;
        address.viewWidth = self.viewWidth - 3 * SCHOOL_HORIZONTAL_MARGE - addressLabel.viewWidth;
        address.viewHeight = hight;
        
#pragma mark - 显示三行
        address.numberOfLines = 1;
        address.textColor = [[RTAPPUIHelper shareInstance]  profileBaseInformationRColor];
        address.font = [[RTAPPUIHelper shareInstance]  profileBaseInformationRFont];
//        [address setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:address];
        _address = address;
    }
    return self;
}

- (void)createCellWithModel:(ResumeNameModel *)model
{
    [self.person sd_setImageWithURL:[NSURL URLWithString:model.PhotoUrlPath] placeholderImage:UIIMAGE(@"icon_32_08")];
    self.name.text = model.ChineseName;
    NSString *genderStr = [NSString stringWithFormat:@"%@",model.Gender];
    NSString *ageStr = [NSString stringWithFormat:@"%@岁",model.Age];
    
    NSMutableArray *array = [BaseCode baseWithCodeKey:model.JobStatus];
    BaseCode *item = array[0];
    NSString *str = [TBTextUnit fullResumeDetail:genderStr age:ageStr workYear:model.WorkYear jobStatus:item.CodeName];

    self.sexAndOther.text = str;
    self.email.text = model.Email;
    self.phone.text = model.Mobile;
    NSString *marriageStr = [NSString stringWithFormat:@"%@",model.Marital];
    if ([marriageStr isEqualToString:@"1"]) {
        self.marriage.text = @"未婚";
    }else{
        self.marriage.text = @"已婚";
    }
    self.FamilyRegister.text = model.Hukou;
    self.politicsStatus.text = model.Politics;
    self.address.text = model.Address;
    self.region.text = model.Region;
    // 校招特有的信息
    if([model.ResumeType intValue] == 2)
    {
        self.nativePlaceLabel.hidden = NO;
        self.nationLabel.hidden = NO;
        self.qqNumberLabel.hidden = NO;
        self.graduationTimeLabel.hidden = NO;
        self.contentHeightLabel.hidden = NO;
        self.weightLabel.hidden = NO;
        self.healthLabel.hidden = NO;
        self.identityCardLabel.hidden = NO;
        self.postalCodeLabel.hidden = NO;
        self.emergencyContactLabel.hidden = NO;
        self.emergencyContactInfLabel.hidden = NO;
        
        self.nativePlace.text = model.NativeCity;
        self.nation.text = model.Nation;
        self.qqNumber.text = model.QQ;
        self.graduationTime.text = model.GraduateDate;
        self.contentHeight.text = [model.Height stringValue];
        self.weight.text = [model.Weight stringValue];
        if ( model.HealthType.intValue ==1 )
        {
            self.health.text = @"健康";
        }
        else if( model.HealthType.intValue == 2 )
        {
            self.health.text = @"良好";
        }
        else if( model.HealthType.intValue == 3 )
        {
            self.health.text = @"有病史";
        }
        self.identityCard.text = model.IdCardNumber;
        self.postalCode.text = model.ZipCode;
        self.emergencyContact.text = model.EmergencyContact;
        self.emergencyContactInf.text = model.EmergencyContactPhone;
        self.politicsLabel.viewY = CGRectGetMaxY(self.qqNumberLabel.frame) + SCHOOL_VERTICAL_SPACE;
        self.addressLabel.viewY = CGRectGetMaxY(self.emergencyContactInf.frame) + SCHOOL_VERTICAL_SPACE;
    }
    else
    {
        self.nativePlaceLabel.hidden = YES;
        self.nationLabel.hidden = YES;
        self.qqNumberLabel.hidden = YES;
        self.graduationTimeLabel.hidden = YES;    
        self.contentHeightLabel.hidden = YES;
        self.weightLabel.hidden = YES;
        self.healthLabel.hidden = YES;
        self.identityCardLabel.hidden = YES;
        self.postalCodeLabel.hidden = YES;
        self.emergencyContactLabel.hidden = YES;
        self.emergencyContactInfLabel.hidden = YES;
        self.politicsLabel.viewY = CGRectGetMaxY(self.FamilyRegister.frame) + SCHOOL_VERTICAL_SPACE;
        self.addressLabel.viewY = CGRectGetMaxY(self.politicsLabel.frame) + SCHOOL_VERTICAL_SPACE;
    }
    self.politicsStatus.viewY = self.politicsLabel.viewY;
    self.address.viewY = self.addressLabel.viewY;
}
/** 计算控件本身的宽 
 *
 *  @param  control 需要计算内容宽度的控件
 *  @return 返回控件内容的宽度
 */
- (CGFloat)widthWithUIControl:(UIView *)control
{
    if(![control isKindOfClass:[UILabel class]])
        return 0;
    
    int hight = IS_IPHONE_5?12:15;
    
    UILabel *label = (UILabel *)control;
    
    CGSize controlSize = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, hight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : label.font} context:0].size;
    
    return controlSize.width;
}

@end
