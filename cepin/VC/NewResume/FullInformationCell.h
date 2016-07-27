//
//  FullInformationCell.h
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFullCell.h"
#import "ResumeNameModel.h"
@interface FullInformationCell : BaseFullCell
@property(nonatomic,strong)UILabel *basicLabel;
@property(nonatomic,strong)UIImageView *person;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *sexAndOther;//性别和其他
@property(nonatomic,strong)UILabel *email;
@property(nonatomic,strong)UILabel *phone;
@property(nonatomic,strong)UILabel *marriage;//婚姻
@property(nonatomic,strong)UILabel *region;//现居住地
@property(nonatomic,strong)UILabel *FamilyRegister;//户籍
@property(nonatomic,strong)UILabel *politicsStatus;//政治面貌
@property(nonatomic,strong)UILabel *address;//地址
@property(nonatomic,strong)UILabel *sex;
@property(nonatomic,strong)UILabel *age;
@property(nonatomic,strong)UILabel *experience;
@property (nonatomic, strong) UILabel *nativePlace;                 // 籍贯
@property (nonatomic, strong) UILabel *nation;                      // 民族
@property (nonatomic, strong) UILabel *qqNumber;                    // qq号码
@property (nonatomic, strong) UILabel *graduationTime;              // 毕业时间
@property (nonatomic, strong) UILabel *contentHeight;               // 身高(cm)
@property (nonatomic, strong) UILabel *weight;                      // 体重(kg)
@property (nonatomic, strong) UILabel *health;                      // 健康情况
@property (nonatomic, strong) UILabel *identityCard;                // 身份证号
@property (nonatomic, strong) UILabel *postalCode;                  // 邮政编码
@property (nonatomic, strong) UILabel *emergencyContact;            // 紧急联系人
@property (nonatomic, strong) UILabel *emergencyContactInf;         // 紧急联系方式

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
