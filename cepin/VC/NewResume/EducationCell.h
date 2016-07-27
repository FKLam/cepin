//
//  EducationCell.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class EducationCell;
@protocol EducationCellDelegate <NSObject>

-(void)PushCellDelete:(EducationCell*)cell model:(EducationListDateModel*)model;
-(void)GestureGo:(EducationCell*)cell isReset:(BOOL)isReset;

@end
@interface EducationCell : UITableViewCell
@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,strong)UILabel *schoolLabel;
@property(nonatomic,strong)UILabel *subLabel;

@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <EducationCellDelegate>delegate;
@property(nonatomic,strong)EducationListDateModel *model;

- (void)configureWithModel:(EducationListDateModel*)model;
-(void)resetCell;
-(void)swip;
@end
