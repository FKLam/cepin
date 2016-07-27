//
//  FullExpectJobCell.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullExpectJobCell.h"
#import "TBTextUnit.h"
#import "RegionDTO.h"
#import "BaseCodeDTO.h"
@implementation FullExpectJobCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
//         int hight = IS_IPHONE_5?12:15;
        self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 102 / 3.0)];
        self.baseView.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.contentView addSubview:self.baseView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 40 / 3.0, self.baseView.viewY, self.viewWidth - 40 / 3.0 * 2, self.baseView.viewHeight)];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] profileResumeOperationFont];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance] labelColorGreen];
        self.titleLabel.backgroundColor = RGBCOLOR(236, 235, 243);
        [self.contentView addSubview:self.titleLabel];
        
        self.expect = [[UITextView alloc]init];
        self.expect.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        self.expect.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.expect.userInteractionEnabled = NO;
//        self.expect.contentInset = UIEdgeInsetsMake(-10.0, -5.0, 0, 0);
        self.expect.textContainerInset = UIEdgeInsetsMake(-1.0, -5.0, 0, 0);
        [self.contentView addSubview:self.expect];
        [self.expect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset( 40 / 3.0 );
            make.bottom.equalTo(self.mas_bottom).offset( -40 / 3.0 );
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.mas_right).offset( 0 );
        }];
        
        self.des = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.viewX, self.titleLabel.viewY + self.titleLabel.viewHeight, self.viewWidth - 40 / 3.0 * 2, 120 / 3.0)];
        self.des.font = [[RTAPPUIHelper shareInstance] searchResultSubFont];
        self.des.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.des.hidden = YES;
        self.des.text = @"无";
        [self.contentView addSubview:self.des];
        
    }
    return self;
}

-(void)layoutSubviews
{

}
- (void)desWithOut:(BOOL)none
{
    self.des.hidden = none;
}


- (void)createCellWithModel:(ResumeNameModel *)model
{

    NSMutableArray *addressArray = [Region searchAddressWithAddressPathCodeString:model.ExpectCity];
    
    NSString *type = nil;
    if ([model.ExpectEmployType isEqualToString:@"1"]) {
        type = @"全职";
    }
    else if ( !model.ExpectEmployType )
    {
        type = @"不限工作性质";
    }
    else
    {
        type = @"实习";
    }
    
    NSMutableArray *arrarCode = [BaseCode baseCodeWithCodeKeys:model.ExpectJobFunction];
//    NSString *str = [TBTextUnit ResumeDetail:[TBTextUnit allRegionCitiesWithRegions:addressArray] nature:type job:[TBTextUnit baseCodeNameWithBaseCodes:arrarCode] salary:model.ExpectSalary];
    
    NSString *addressStr = [TBTextUnit allRegionCitiesWithRegions:addressArray];
    if ( !addressStr || addressStr.length == 0 )
        addressStr = @"不限城市";
    
    NSString *jobStatue = [TBTextUnit baseCodeNameWithBaseCodes:arrarCode];
    if ( !jobStatue || jobStatue.length == 0 )
        jobStatue = @"职能不限";
    
    NSString *saleStr = model.ExpectSalary;
    if ( !saleStr || saleStr.length == 0 )
        saleStr = @"薪酬不限";
    
    NSString *str = [NSString stringWithFormat:@"%@ / %@ / %@ / %@", type, addressStr, jobStatue, saleStr];
    
    
    NSMutableString *strM = [NSMutableString stringWithString:str];
    
    if(model.ResumeType.intValue == 2){
        if(model.AvailableType && model.AvailableType.length > 0)
        {
            [strM appendFormat:@" / %@到岗", model.AvailableType];
        }
        else
        {
            [strM appendFormat:@" / %@到岗时间", @"不限"];
        }
        
#pragma mark - 修复正确显示是否服从分配
        // 1不服从，0服从
        if ( model.IsAllowDistribution && model.IsAllowDistribution > 0)
        {
            NSString *distribution = model.IsAllowDistribution.intValue ? @"，服从分配" : @"，不服从分配";
            
            [strM appendString:distribution];
        }
    }
    self.expect.text = [strM copy];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
