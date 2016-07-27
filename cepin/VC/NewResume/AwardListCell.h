//
//  AwardListCell.h
//  cepin
//
//  Created by dujincai on 15/6/26.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class AwardListCell;
@protocol AwardListCellDelegate <NSObject>

-(void)PushCellDelete:(AwardListCell*)cell model:(AwardsListDataModel*)model;
-(void)GestureGo:(AwardListCell*)cell isReset:(BOOL)isReset;

@end
@interface AwardListCell : UITableViewCell
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <AwardListCellDelegate>delegate;
@property(nonatomic,strong)AwardsListDataModel *model;

- (void)configureWithModel:(AwardsListDataModel*)model;
-(void)resetCell;
-(void)swip;

@end
