//
//  ResumeProjectCell.m
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "ResumeProjectCell.h"
#import "TBTextUnit.h"
#import "NSDate-Utilities.h"
#import "NSString+Extension.h"

@interface ResumeProjectCell()

@property (nonatomic, weak) UILabel *label;

@end

@implementation ResumeProjectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth + 70, self.viewHeight)];
        [self addSubview:self.containerView];
        self.containerView.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, self.viewWidth - 40, 15)];
        self.titleLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.titleLabel.font = [[RTAPPUIHelper shareInstance] companyInformationNameFont];
        [self.containerView addSubview:self.titleLabel];
        
        self.subLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,self.titleLabel.viewY + self.titleLabel.viewHeight + 8, self.viewWidth - 40, 15)];
        self.subLabel.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        self.subLabel.font = [[RTAPPUIHelper shareInstance] jobInformationTemptationFont];
        [self.containerView addSubview:self.subLabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, self.subLabel.viewY + self.subLabel.viewHeight + 15, IS_IPHONE_5?50:75, 15)];
        label.text = @"工作描述:";
        label.textColor = [[RTAPPUIHelper shareInstance]mainTitleColor];
        label.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
        label.viewWidth = [NSString caculateTextSize:label].width;
        label.viewHeight = [NSString caculateTextSize:label].height;
        [self.containerView addSubview: label];
        _label = label;
        
        self.describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.viewWidth + label.viewX, self.subLabel.viewY + self.subLabel.viewHeight + 15, self.viewWidth - label.viewWidth - 40, 15)];
        self.describeLabel.textColor = [[RTAPPUIHelper shareInstance]subTitleColor];
        self.describeLabel.font = [[RTAPPUIHelper shareInstance] searchResultTipsHeadFont];
        [self.containerView addSubview:self.describeLabel];
        UIView *line = [[UIView alloc]init];
        [self.containerView addSubview:line];
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(1));
        }];
        
        
        self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 70, 100)];
        self.deleteButton.backgroundColor = [UIColor redColor];
        [self.containerView addSubview:self.deleteButton];
        [self.deleteButton addTarget:self action:@selector(PushDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnImage = [[UIImageView alloc]initWithFrame:CGRectMake((70-36)/2, 100*0.15, 36, 36)];
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
//    self.containerView.frame = CGRectMake(0, 0, self.viewWidth + 70, self.viewHeight);
//    self.deleteButton.frame = CGRectMake(kScreenWidth, 0, 70, self.viewHeight);

    [super layoutSubviews];
    
    CGFloat horizontal_marge = 40 / 3.0;
    CGFloat vertical_marge = 40 / 3.0;
    
    CGSize titleSize = [NSString caculateTextSize:self.titleLabel];
    CGFloat maxTitle = self.viewWidth - horizontal_marge * 2.0;
    if ( titleSize.width > maxTitle )
        titleSize.width = maxTitle;
    if ( titleSize.height > self.titleLabel.font.pointSize )
        titleSize.height = self.titleLabel.font.pointSize;
    self.titleLabel.frame = CGRectMake(horizontal_marge, vertical_marge, titleSize.width, titleSize.height);
    
    self.label.viewX = horizontal_marge;
    self.label.viewY = self.viewHeight - vertical_marge - self.label.viewHeight;
    
    self.describeLabel.viewX = CGRectGetMaxX(self.label.frame) + 2.0;
    self.describeLabel.viewY = self.label.viewY;
    self.describeLabel.viewWidth = self.viewWidth - self.describeLabel.viewX - horizontal_marge;
    self.describeLabel.viewHeight = self.label.viewHeight;
    
    CGSize subSize = [NSString caculateTextSize:self.subLabel];
    CGFloat maxSub = self.viewWidth - 2 * horizontal_marge;
    self.subLabel.viewX = horizontal_marge;
    if ( subSize.height > self.subLabel.font.pointSize )
        subSize.height = self.subLabel.font.pointSize;
    if ( subSize.width > maxSub )
        subSize.width = maxSub;
    self.subLabel.viewY = self.label.viewY - vertical_marge - subSize.height;
    self.subLabel.viewSize = subSize;
    
    self.containerView.viewHeight = self.viewHeight;
    self.deleteButton.viewHeight = self.viewHeight;
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

- (void)configureWithModel:(ProjectListDataModel *)model
{
    self.model = model;
    
    NSString *startime =  [NSDate cepinYMDFromString:model.StartDate];
    NSString *endTime = [NSDate cepinYMDFromString:model.EndDate];
    if (!endTime || [endTime isEqualToString:@""]) {
        endTime = @"至今";
    }
    
    NSString *time = [NSString stringWithFormat:@"%@-%@",startime ,endTime];
    
    self.titleLabel.text = model.Name;
    self.subLabel.text = [TBTextUnit configWithTime:time job:model.Duty];
    
    if (!model.Content || [model.Content isEqualToString:@""]) {
        self.describeLabel.text = @"";
    }else{
        self.describeLabel.text = model.Content;
    }
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\n+" options:0 error:nil];
    
    self.describeLabel.text = [regularExpression stringByReplacingMatchesInString:self.describeLabel.text options:0 range:NSMakeRange(0, model.Content.length) withTemplate:@" "];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
