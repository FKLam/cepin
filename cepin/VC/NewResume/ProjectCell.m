//
//  ProjectCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ProjectCell.h"
#import "ResumeNameModel.h"
#import "NSString+Extension.h"
#import "CPCommon.h"

@implementation ProjectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        int imageHight = 21.0;
        int hight = IS_IPHONE_5?11:12.6;
        UIImageView *imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake( 40 / 3.0, 40 / 3.0 - (imageHight - [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont].pointSize) / 2.0, imageHight, imageHight)];
        imageLogo.image = [UIImage imageNamed:@"ic_jl"];
        [self.contentView addSubview:imageLogo];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(imageLogo.viewWidth + imageLogo.viewX + 10, 0, self.viewWidth - 40 / 3.0 * 2, hight)];
        self.time.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont];
        self.time.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        [self.contentView addSubview:self.time];
        
        self.projecrName = [[UILabel alloc]initWithFrame:CGRectMake(self.time.viewX, self.time.viewHeight + 10, self.viewWidth - imageHight - 40, hight)];
        self.projecrName.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont];
        self.projecrName.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.projecrName];
        
        self.position = [[UILabel alloc]initWithFrame:CGRectMake(self.projecrName.viewX, self.projecrName.viewY + self.projecrName.viewHeight + 10, self.viewWidth - imageHight - 40, hight)];
        self.position.font = [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont];
        self.position.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        [self.contentView addSubview:self.position];
        
        self.projectDescribe = [[UILabel alloc] init];
        self.projectDescribe.numberOfLines = 0;
        self.projectDescribe.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
        self.projectDescribe.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        [self.contentView addSubview:self.projectDescribe];
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = CPColor(0xed, 0xe3, 0xe6, 0.8);
        [self.contentView addSubview:separatorView];
        _separatorView = separatorView;
    }
    return self;
}

- (void)getModel:(id)model
{
    ProjectListDataModel *proModel = model;
    NSString *star = [self managestrTime:proModel.StartDate];
    NSString *end = [self managestrTime:proModel.EndDate];
    NSString *time = [NSString stringWithFormat:@"%@-%@",star,end];
    self.time.text = time;
    self.projecrName.text = proModel.Name;
    self.position.text = proModel.Duty;
    self.projectDescribe.text = proModel.Content;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat tempH = [[RTAPPUIHelper shareInstance] companyInformationIntroduceFont].pointSize;
    
    CGFloat maxMarge = self.viewWidth - 40 / 3.0 - 40;
    
    CGSize timeSize = [NSString caculateTextSize:self.time.font text:self.time.text andWith:maxMarge];
    self.time.frame = CGRectMake( 40, 40 / 3.0, timeSize.width, tempH);
    
    CGSize nameSize = [NSString caculateTextSize:self.projecrName.font text:self.projecrName.text andWith:maxMarge];
    self.projecrName.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.time.frame) + 5.0, nameSize.width, tempH);
    
    CGSize positionSize = [NSString caculateTextSize:self.position.font text:self.position.text andWith:maxMarge];
    self.position.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.projecrName.frame) + 5.0, positionSize.width, tempH);
    
    CGFloat maxDetail = kScreenWidth - 40.0 - 40 / 3.0;
    CGSize detailSize = [NSString caculateTextSize:self.projectDescribe.font text:self.projectDescribe.text andWith:maxDetail];
    self.projectDescribe.frame = CGRectMake(self.time.viewX, CGRectGetMaxY(self.position.frame) + 5.0 , detailSize.width, detailSize.height);
    
    self.separatorView.frame = CGRectMake(self.time.viewX, self.viewHeight - 1.0, kScreenWidth - self.time.viewX, 1 / 2.0);
}

@end
