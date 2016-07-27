//
//  ResumeJobExperienceCell.m
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeJobExperienceCell.h"
#import "TBTextUnit.h"
#import "NSDate-Utilities.h"
#import "NSString+Extension.h"

@interface ResumeJobExperienceCell()

@property (nonatomic, weak) UILabel *label;

@end

@implementation ResumeJobExperienceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //白色背景
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth + 80, self.viewHeight)];
        [self.contentView addSubview:self.containerView];
        self.containerView.backgroundColor = [UIColor whiteColor];
        
        self.companyName = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.viewWidth - 40, 15)];
        self.companyName.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.companyName.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
        [self.containerView addSubview:self.companyName];
        
        self.informationLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.companyName.viewHeight + self.companyName.viewY + 8, self.viewWidth - 40, 15)];
        self.informationLabel.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.informationLabel.font = [[RTAPPUIHelper shareInstance] jobInformationTemptationFont];
        [self.containerView addSubview: self.informationLabel];

        UILabel *label = [[UILabel alloc] init];
        label.text = @"工作描述:";
        label.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        label.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
        label.viewSize = [NSString caculateTextSize:label];
        label.viewX = 40 / 3.0;
        [self.containerView addSubview: label];
        _label = label;
        
        self.describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.viewWidth + label.viewX, label.viewY, self.viewWidth - label.viewWidth - 40, 15)];
        self.describeLabel.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
      
        self.describeLabel.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
        [self.containerView addSubview:self.describeLabel];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self.containerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(1));
        }];
        
    

        self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 80, 119)];
        self.deleteButton.backgroundColor = [UIColor redColor];
        [self.deleteButton addTarget:self action:@selector(PushDelete:) forControlEvents:UIControlEventTouchUpInside];

        [self.containerView addSubview:self.deleteButton];
        
        self.btnImage = [[UIImageView alloc]initWithFrame:CGRectMake((80-36)/2, 119*0.25, 36, 36)];
//        [self.deleteButton addSubview:self.btnImage];
        [self.deleteButton insertSubview:self.btnImage atIndex:0];
        self.btnImage.image = UIIMAGE(@"ic_jl_rolldel");
        self.btnImage.userInteractionEnabled = NO;
        
  
        self.btnTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.btnImage.viewHeight + self.btnImage.viewY, self.deleteButton.viewWidth, 20)];
        self.btnTitle.font = [UIFont systemFontOfSize:14];
        self.btnTitle.textColor = [UIColor whiteColor];
        self.btnTitle.text = @"删除";
        self.btnTitle.textAlignment = NSTextAlignmentCenter;
//        [self.deleteButton addSubview:self.btnTitle];
        [self.deleteButton insertSubview:self.btnTitle atIndex:1];
        self.btnTitle.userInteractionEnabled = NO;
        
        
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
//    self.containerView.frame = CGRectMake(0, 0, self.viewWidth + 80, self.viewHeight);
//    self.deleteButton.frame = CGRectMake(kScreenWidth, 0, 80, self.viewHeight);
    
    [super layoutSubviews];
    
    CGFloat horizontal_marge = 40 / 3.0;
    CGFloat vertical_marge = 40 / 3.0;
    
    self.containerView.viewHeight = self.viewHeight;
    
    CGSize companySize = [NSString caculateTextSize:self.companyName];
    CGFloat maxCompany = self.viewWidth - horizontal_marge * 2;
    if ( companySize.width > maxCompany )
        companySize.width = maxCompany;
    if ( companySize.height > self.companyName.font.pointSize)
        companySize.height = self.companyName.font.pointSize;
    self.companyName.frame = CGRectMake(horizontal_marge, vertical_marge, companySize.width, companySize.height);
    
    self.label.viewY = self.viewHeight - vertical_marge - self.label.viewHeight;
    
    CGSize descriSize = [NSString caculateTextSize:self.describeLabel];
    CGFloat maxDescri = self.viewWidth - CGRectGetMaxX(self.label.frame) - horizontal_marge - 2.0;
    CGFloat descriX = CGRectGetMaxX(self.label.frame) + 2.0;
    if ( descriSize.width > maxDescri )
        descriSize.width = maxDescri;
    self.describeLabel.frame = CGRectMake(descriX, self.label.viewY, descriSize.width, self.label.viewHeight);
    
    CGSize inforSize = [NSString caculateTextSize:self.informationLabel];
    CGFloat inforX = horizontal_marge;
    CGFloat inforY = self.label.viewY - vertical_marge - inforSize.height;
    if ( inforSize.width > maxCompany )
        inforSize.width = maxCompany;
    inforSize.height = inforSize.height > self.informationLabel.font.pointSize ? self.informationLabel.font.pointSize : inforSize.height;
    self.informationLabel.frame = CGRectMake(inforX, inforY, inforSize.width, inforSize.height);
    self.deleteButton.frame= CGRectMake(kScreenWidth, 0, self.viewHeight, self.viewHeight);
    
}

-(void)gestureGo:(UISwipeGestureRecognizer *)sender
{
    if (self.swipGesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        self.containerView.viewX = -80;
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
    self.containerView.viewX = -80;
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

- (void)configureWithModel:(WorkListDateModel *)model
{
    self.model = model;
    self.companyName.text = model.Company;
    
   
    NSString *startime =  [NSDate cepinYMDFromString:model.StartDate];
    NSString *endTime = [NSDate cepinYMDFromString:model.EndDate];
    if (!endTime || [endTime isEqualToString:@""]) {
        endTime = @"至今";
    }
    
    NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
    self.informationLabel.text =[TBTextUnit configWithTime:time job:model.JobFunction];
    self.describeLabel.text = model.Content;
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n+" options:0 error:nil];
    if(model.Content){
        self.describeLabel.text = [regularExpression stringByReplacingMatchesInString:self.describeLabel.text options:0 range:NSMakeRange(0, model.Content.length) withTemplate:@" "];
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
