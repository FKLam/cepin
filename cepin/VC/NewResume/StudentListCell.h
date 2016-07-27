//
//  StudentListCell.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class StudentListCell;
@protocol StudentListCellDelegate <NSObject>

-(void)PushCellDelete:(StudentListCell*)cell model:(StudentLeadersDataModel*)model;
-(void)GestureGo:(StudentListCell*)cell isReset:(BOOL)isReset;

@end
@interface StudentListCell : UITableViewCell
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <StudentListCellDelegate>delegate;
@property(nonatomic,strong)StudentLeadersDataModel *model;

- (void)configureWithModel:(StudentLeadersDataModel*)model;
-(void)resetCell;
-(void)swip;
@end
