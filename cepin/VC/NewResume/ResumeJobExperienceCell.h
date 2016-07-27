//
//  ResumeJobExperienceCell.h
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class ResumeJobExperienceCell;


@protocol ResumeJobExperienceCellDelegate <NSObject>

-(void)PushCellDelete:(ResumeJobExperienceCell*)cell model:(WorkListDateModel*)model;
-(void)GestureGo:(ResumeJobExperienceCell*)cell isReset:(BOOL)isReset;

@end

@interface ResumeJobExperienceCell : UITableViewCell

@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,strong)UILabel *companyName;
@property(nonatomic,strong)UILabel *informationLabel;
@property(nonatomic,strong)UILabel *describeLabel;

@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <ResumeJobExperienceCellDelegate>delegate;
@property(nonatomic,strong)WorkListDateModel *model;

- (void)configureWithModel:(WorkListDateModel*)model;
-(void)resetCell;
-(void)swip;
@end
