//
//  DynamicNewCell.m
//  cepin
//
//  Created by zhu on 14/12/13.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "DynamicNewCell.h"
#import "NSDate-Utilities.h"

#define kDynamicCellBackHeight 74

@implementation DynamicNewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        

        //白色背景
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth + 76*2 - 10, kDynamicCellBackHeight)];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        
        self.maskView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-20, 0, 10, kDynamicCellBackHeight)];
        self.maskView.backgroundColor = [[RTAPPUIHelper shareInstance]backgroundColor];
        [self.whiteView addSubview:self.maskView];
        
        self.toTopButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-10, 0, 76, kDynamicCellBackHeight)];
        [self.toTopButton setBackgroundImage:UIIMAGE(@"tb_top_icon_click") forState:UIControlStateNormal];
        [self.whiteView addSubview:self.toTopButton];
        [self.toTopButton addTarget:self action:@selector(PushToTop:) forControlEvents:UIControlEventTouchUpInside];
        
        self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth+76-10, 0, 76, kDynamicCellBackHeight)];
        [self.deleteButton setBackgroundImage:UIIMAGE(@"tb_del_click") forState:UIControlStateNormal];
        [self.deleteButton setBackgroundImage:UIIMAGE(@"tb_del") forState:UIControlStateHighlighted];
        [self.whiteView addSubview:self.deleteButton];
        [self.deleteButton addTarget:self action:@selector(PushDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        self.imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake(8, 14, 40, 40)];
        self.imageLogo.layer.cornerRadius = 20;
        self.imageLogo.layer.masksToBounds = YES;
        self.imageLogo.backgroundColor = [UIColor clearColor];
        self.imageLogo.viewCenterY = kDynamicCellBackHeight/2;
        [self.whiteView addSubview:self.imageLogo];

        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(56, 12, kScreenWidth - 8 - 56 - 5 - 8 - 42 - 15, 21)];
        self.labelTitle.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.labelTitle.font = [UIFont boldSystemFontOfSize:16];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.whiteView addSubview:self.labelTitle];
        
        self.maskTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(56, 12, kScreenWidth - 8 - 56 - 5 - 8 - 42, 20)];
        self.maskTitleLable.textColor = [[RTAPPUIHelper shareInstance] mainTitleColor];
        self.maskTitleLable.font = [UIFont boldSystemFontOfSize:16];
        self.maskTitleLable.backgroundColor = [UIColor clearColor];
        [self.whiteView addSubview:self.maskTitleLable];
        self.maskTitleLable.viewCenterY = kDynamicCellBackHeight/2;
        self.maskTitleLable.hidden = YES;

        self.labelTime = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 20 - 56-10, 14, 56, 21)];
        self.labelTime.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        self.labelTime.font = [UIFont systemFontOfSize:12];
        self.labelTime.backgroundColor = [UIColor clearColor];
        self.labelTime.textAlignment = NSTextAlignmentRight;
        [self.whiteView addSubview:self.labelTime];
        
        self.labelNumber = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 8 - 42, self.labelTitle.frame.origin.y + self.labelTitle.frame.size.height + 6, 22, 22)];
        self.labelNumber.textColor = [[RTAPPUIHelper shareInstance] whiteColor];
        self.labelNumber.font = UISystemFont(14);
        self.labelNumber.textAlignment = NSTextAlignmentCenter;
        self.labelNumber.layer.cornerRadius = 11;
        self.labelNumber.layer.masksToBounds = YES;
        self.labelNumber.backgroundColor = UIColorFromRGB(0xfb6e52);
        [self.whiteView addSubview:self.labelNumber];
        
        self.labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(56, self.labelTitle.frame.origin.y + self.labelTitle.frame.size.height, kScreenWidth - 8 - 56 - 5 - 8 - 42, 37)];
        self.labelDetail.numberOfLines = 2;
        self.labelDetail.textAlignment = NSTextAlignmentLeft;
        self.labelDetail.textColor = [[RTAPPUIHelper shareInstance] subTitleColor];
        self.labelDetail.font = [[RTAPPUIHelper shareInstance] subTitleFont];
        self.labelDetail.backgroundColor = [UIColor clearColor];
        [self.whiteView addSubview:self.labelDetail];

        [self.contentView addSubview:self.whiteView];
        
        self.swipGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureGo:)];
        self.swipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.contentView addGestureRecognizer:self.swipGesture];
    }
    return self;
}

-(void)gestureGo:(UISwipeGestureRecognizer *)sender
{
    if (!self.canSwip) {
        return;
    }
    if (self.swipGesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        self.whiteView.frame = CGRectMake(10 - 76*2, 10, kScreenWidth + 76*2 - 10, kDynamicCellBackHeight);
        self.toTopButton.frame = CGRectMake(kScreenWidth-20, 0, 76, kDynamicCellBackHeight);
        self.deleteButton.frame = CGRectMake(kScreenWidth+76-20, 0, 76, kDynamicCellBackHeight);
        self.swipGesture.direction = UISwipeGestureRecognizerDirectionRight;
        if ([self.delegate respondsToSelector:@selector(GestureGo:isReset:)])
        {
            [self.delegate GestureGo:self isReset:YES];
        }
    }
    else
    {
        self.whiteView.frame = CGRectMake(10, 10, kScreenWidth - 10 + 76*2, kDynamicCellBackHeight);
        self.toTopButton.frame = CGRectMake(kScreenWidth-10, 0, 76, kDynamicCellBackHeight);
        self.deleteButton.frame = CGRectMake(kScreenWidth+76-10, 0, 76, kDynamicCellBackHeight);
        self.swipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        if ([self.delegate respondsToSelector:@selector(GestureGo:isReset:)])
        {
            [self.delegate GestureGo:self isReset:NO];
        }
    }
}

-(void)resetCell
{
    self.whiteView.frame = CGRectMake(10, 10, kScreenWidth - 10 + 76*2, kDynamicCellBackHeight);
    self.toTopButton.frame = CGRectMake(kScreenWidth-10, 0, 76, kDynamicCellBackHeight);
    self.deleteButton.frame = CGRectMake(kScreenWidth+76-10, 0, 76, kDynamicCellBackHeight);
    self.swipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
}

-(void)PushToTop:(UIButton*)sender
{
    self.whiteView.frame = CGRectMake(10, 10, kScreenWidth - 10 + 76*2, kDynamicCellBackHeight);
    self.toTopButton.frame = CGRectMake(kScreenWidth-10, 0, 76, kDynamicCellBackHeight);
    self.deleteButton.frame = CGRectMake(kScreenWidth+76-10, 0, 76, kDynamicCellBackHeight);
    self.swipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    if ([self.delegate respondsToSelector:@selector(PushCellToTop:)])
    {
        [self.delegate PushCellToTop:self];
    }
}

-(void)PushDelete:(UIButton*)sender
{
    self.whiteView.frame = CGRectMake(10, 10, kScreenWidth - 10 + 76*2, kDynamicCellBackHeight);
    self.swipGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    if ([self.delegate respondsToSelector:@selector(PushCellDelete:)])
    {
        [self.delegate PushCellDelete:self];
    }
}

-(void)configureWithModel:(DynamicNewModel*)model
{
    switch (model.type.intValue)
    {
        case DynamicModelJobType:
        case DynamicModelFairType:
        case DynamicModelFairSystemType:
        case DynamicModelExamType:
        {
            self.imageLogo.image = [UIImage imageNamed:model.image];
            self.canSwip = NO;
        }
            break;
        case DynamicModelCompanyChatType:
        {
            [self.imageLogo setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:UIIMAGE(@"tb_default_logo")];
            self.canSwip = YES;
        }
            break;
        case DynamicModelChatType:
        {
            [self.imageLogo setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:UIIMAGE(@"tb_default_avatar")];
            self.canSwip = YES;
        }
            break;
            
        default:
            break;
    }
    self.labelTitle.text = model.name?model.name:@"";
    self.maskTitleLable.text = model.name?model.name:@"";
    self.labelDetail.text = model.message?model.message:@"";
    if (!model.message || model.message.length <= 0 || [model.message isEqualToString:@""])
    {
        self.maskTitleLable.hidden = NO;
        self.labelTitle.hidden = YES;
    }
    else
    {
        self.maskTitleLable.hidden = YES;
        self.labelTitle.hidden = NO;
    }
    
    int value = model.UnReadCount.intValue;
    if (value > 0)
    {
        self.labelNumber.text = [NSString stringWithFormat:@"%d",value];
        self.labelNumber.hidden = NO;
    }
    else
    {
        self.labelNumber.hidden = YES;
    }
    
    if ([model.message isEqualToString:@"马上设置工作订阅,为您推送职位动态"] || [model.message isEqualToString:@"设置宣讲会订阅,接收最新消息"])
    {
        self.labelTime.text = @"";
    }
    else
    {
        self.labelTime.text = model.CreateTime?[model.CreateTime cepinDateString]:@"";
    }
}


@end
