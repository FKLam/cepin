//
//  EducationCell.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "EducationCell.h"
#import "TBTextUnit.h"
#import "NSDate-Utilities.h"
#import "NSString+Extension.h"

@implementation EducationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.viewWidth + 70, self.viewHeight)];
        [self addSubview:self.containerView];
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.viewWidth - 40, 16.0)];
        self.schoolLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.schoolLabel.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        [self.containerView addSubview:self.schoolLabel];
        
        self.subLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.schoolLabel.viewHeight +self.schoolLabel.viewY + 15, self.viewWidth - 40, 14.0)];
        self.subLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.subLabel.font = [[RTAPPUIHelper shareInstance] profileResumeStatueFont];
        [self.containerView addSubview:self.subLabel];
        
        UIView *line = [[UIView alloc]init];
        [self.containerView addSubview:line];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.left.equalTo(self.schoolLabel.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(1));
        }];
        
        
        self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 70, 70)];
        self.deleteButton.backgroundColor = [UIColor redColor];
        [self.containerView addSubview:self.deleteButton];
        [self.deleteButton addTarget:self action:@selector(PushDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnImage = [[UIImageView alloc]initWithFrame:CGRectMake((70-36)/2, 70*0.15, 36, 36)];
        [self.deleteButton addSubview:self.btnImage];
        self.btnImage.image = UIIMAGE(@"ic_jl_rolldel");
        
        
        self.btnTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.btnImage.viewHeight + self.btnImage.viewY, self.deleteButton.viewWidth, 20)];
        self.btnTitle.font = [UIFont systemFontOfSize:14];
        self.btnTitle.textColor = [UIColor whiteColor];
        self.btnTitle.text = @"删除";
        self.btnTitle.textAlignment = NSTextAlignmentCenter;
        [self.deleteButton addSubview:self.btnTitle];
        
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.containerView.backgroundColor = [UIColor clearColor];
        
        self.swipGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureGo:)];
        self.swipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:self.swipGesture];
    }
    return self;
}
- (void)layoutSubviews
{
    self.containerView.frame = CGRectMake(0, 0, self.viewWidth + 70, self.viewHeight);
    self.deleteButton.frame = CGRectMake(kScreenWidth, 0, 70, self.viewHeight);
    
}
-(void)gestureGo:(UISwipeGestureRecognizer *)sender
{
    if (self.swipGesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        self.containerView.viewX = -70;
        self.swipGesture.direction = UISwipeGestureRecognizerDirectionRight;
        if ([self.delegate respondsToSelector:@selector(GestureGo:isReset:)])
        {
            [self.delegate GestureGo:self isReset:YES];
        }
    }
    else
    {
        self.containerView.viewX = 0;
        [self resetCell];
        self.swipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    }
}

-(void)resetCell
{
    self.containerView.viewX = 0;
    self.swipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
}

-(void)swip
{
    self.containerView.viewX = -70;
    self.swipGesture.direction = UISwipeGestureRecognizerDirectionRight;
}

-(void)PushDelete:(UIButton*)sender
{
    [self resetCell];
    if ([self.delegate respondsToSelector:@selector(PushCellDelete:model:)])
    {
        [self.delegate PushCellDelete:self model:self.model];
        
    }
}

- (void)configureWithModel:(EducationListDateModel *)model
{
    self.model = model;
    
    NSString *startime =  [NSDate cepinYMDFromString:model.StartDate];
    NSString *endTime = [NSDate cepinYMDFromString:model.EndDate];
    if (!endTime || [endTime isEqualToString:@""]) {
        endTime = @"至今";
    }
    
    NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
    
    self.schoolLabel.text = model.School;
    self.subLabel.text = [TBTextUnit configWithTime:time job:model.Major];
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
