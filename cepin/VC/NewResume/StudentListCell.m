//
//  StudentListCell.m
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "StudentListCell.h"
#import "TBTextUnit.h"
#import "NSDate-Utilities.h"
@implementation StudentListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth + 70, self.viewHeight)];
        [self addSubview:self.containerView];
        self.containerView.backgroundColor = [UIColor whiteColor];
        
        self.titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.viewWidth - 40, 30)];
        self.titlelabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.titlelabel.font = [[RTAPPUIHelper shareInstance] profileResumeNameFont];
        [self.containerView addSubview:self.titlelabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.titlelabel.viewHeight, self.viewWidth - 40, 30)];
        self.timeLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.timeLabel.font = [[RTAPPUIHelper shareInstance] profileResumeStatueFont];
        [self.containerView addSubview:self.timeLabel];
        
        UIView *line = [[UIView alloc]init];
        [self.containerView addSubview:line];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.left.equalTo(self.timeLabel.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(1));
        }];
        
        self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 70, 70)];
        self.deleteButton.backgroundColor = [UIColor redColor];
        [self.containerView addSubview:self.deleteButton];
        [self.deleteButton addTarget:self action:@selector(PushDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnImage = [[UIImageView alloc]initWithFrame:CGRectMake((70-30)/2, 70*0.15, 36, 36)];
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

- (void)configureWithModel:(StudentLeadersDataModel *)model
{
    self.model = model;
    self.titlelabel.text = [TBTextUnit configWithTime:model.Name job:model.Level];
    NSString *startime =  [NSDate cepinYMDFromString:model.StartDate];
    NSString *endTime = [NSDate cepinYMDFromString:model.EndDate];
    if (!endTime || [endTime isEqualToString:@""]) {
        endTime = @"至今";
    }
    
    NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
    self.timeLabel.text = time;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
