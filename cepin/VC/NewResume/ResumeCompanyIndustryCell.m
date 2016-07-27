//
//  ResumeCompanyIndustryCell.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeCompanyIndustryCell.h"

@implementation ResumeCompanyIndustryCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.open = NO;
        self.backgroundColor = [UIColor whiteColor];
        int hight = IS_IPHONE_5?21:25;
        self.jobName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-10-22-5-70 + 20, 43)];
        self.jobName.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.jobName.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        self.jobName.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.jobName];
        
        self.arrowImage = [[UIImageView alloc]init];
        self.arrowImage.image = [UIImage imageNamed:@"ic_next"];
        [self addSubview:self.arrowImage];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.mas_top).offset(5);
            make.height.equalTo(@(hight));
            make.width.equalTo(@(hight));
        }];
        
        self.labelSub = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-10-22-5-70, 0, 70, 43)];
        self.labelSub.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        self.labelSub.font = [[RTAPPUIHelper shareInstance] subTitleFont];
        self.labelSub.textAlignment = NSTextAlignmentRight;
        self.labelSub.numberOfLines = 2;
        self.labelSub.backgroundColor = [UIColor clearColor];
        [self addSubview:self.labelSub];
        
        
        self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clickButton.frame = self.bounds;
        [self addSubview:self.clickButton];
        [self.clickButton addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)doSelected{
   
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
        [_delegate selectedWith:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.jobName.viewHeight = self.viewHeight;
}

@end
