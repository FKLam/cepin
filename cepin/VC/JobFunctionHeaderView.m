//
//  JobFunctionHeaderView.m
//  cepin
//
//  Created by dujincai on 15/6/2.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "JobFunctionHeaderView.h"
#import "CPCommon.h"
@interface JobFunctionHeaderView()
@end
@implementation JobFunctionHeaderView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       

        self.backgroundColor = [[RTAPPUIHelper shareInstance] whiteColor];
        self.jobName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-20 - 10 - 20, self.viewHeight)];
        self.jobName.textColor = [UIColor colorWithHexString:@"404040"];
        [self.jobName setFont:[UIFont systemFontOfSize:42 / CP_GLOBALSCALE]];
        self.jobName.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.jobName];
        
        self.arrowImage = [[UIImageView alloc]init];
        self.arrowImage.image = [UIImage imageNamed:@"ic_next"];
        [self addSubview:self.arrowImage];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(imagehight));
            make.width.equalTo(@(imagehight));
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
        [self.clickButton addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:self.clickButton];
        [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [[RTAPPUIHelper shareInstance] lineColor];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(40/CP_GLOBALSCALE);
            make.right.equalTo(self.mas_right).offset(-40/CP_GLOBALSCALE);
            make.bottom.equalTo(self.mas_bottom).offset( 0 );
            make.height.equalTo( @(2/CP_GLOBALSCALE ) );
        }];
    }
    return self;
}

-(void)resetLine{

    if (self.open) {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(40/CP_GLOBALSCALE);
            make.right.equalTo(self.mas_right).offset(-40/CP_GLOBALSCALE);
            make.bottom.equalTo(self.mas_bottom).offset( 0 );
            make.height.equalTo( @(2/CP_GLOBALSCALE ) );
        }];
    }else{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo( @(2/CP_GLOBALSCALE ) );
        }];
    }
}

-(void)doSelected{
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
        [_delegate selectedWith:self];
    }
}

- (void)configJobName:(NSString *)jobName
{
    self.jobName.text = jobName;
}

-(void)configureLableSubText:(NSString*)text
{
    if (text)
    {
        self.labelSub.text = text;
    }
    else
    {
        self.labelSub.text = @"";
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.jobName.viewHeight = self.viewHeight;
}

@end
