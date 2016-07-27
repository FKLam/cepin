//
//  JingLiCell.h
//  cepin
//
//  Created by dujincai on 15/6/23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class JingLiCell;
@protocol JingLiCellDelegate <NSObject>

-(void)PushCellDelete:(JingLiCell*)cell model:(PracticeListDataModel*)model;
-(void)GestureGo:(JingLiCell*)cell isReset:(BOOL)isReset;

@end
@interface JingLiCell : UITableViewCell
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *desLabel;

@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <JingLiCellDelegate>delegate;
@property(nonatomic,strong)PracticeListDataModel *model;

- (void)configureWithModel:(PracticeListDataModel*)model;
-(void)resetCell;
-(void)swip;
@end
