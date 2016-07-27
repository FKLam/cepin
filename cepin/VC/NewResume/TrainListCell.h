//
//  TrainListCell.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class TrainListCell;
@protocol TrainListCellDelegate <NSObject>

-(void)PushCellDelete:(TrainListCell*)cell model:(TrainingDataModel*)model;
-(void)GestureGo:(TrainListCell*)cell isReset:(BOOL)isReset;

@end
@interface TrainListCell : UITableViewCell
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *desLabel;

@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <TrainListCellDelegate>delegate;
@property(nonatomic,strong)TrainingDataModel *model;

- (void)configureWithModel:(TrainingDataModel*)model;
-(void)resetCell;
-(void)swip;
@end
