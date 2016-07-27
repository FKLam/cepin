//
//  CompanyDetaileOtherJobCell.m
//  cepin
//
//  Created by dujincai on 15/5/27.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CompanyDetaileOtherJobCell.h"
@implementation CompanyDetaileOtherJobCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
       self.viewCell = [[UIView alloc]init];
        self.viewCell.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.viewCell];
        [self.viewCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}
- (void)createOtherJobCellWith:(CompanyDetailModelDTO *)model positionIds:(NSMutableArray *)positionIds
{
    if ( !self.companyOtherJobView && model && [positionIds count] > 0 )
    {
        self.companyOtherJobView = [[CompanyDetaileOtherJobView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, model.AppPositionInfoList.count * 130) model:model positionIds:positionIds];
        
        [self.viewCell addSubview:self.companyOtherJobView];
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
