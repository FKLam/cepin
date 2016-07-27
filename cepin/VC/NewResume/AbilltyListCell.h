//
//  AbilltyListCell.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class AbilltyListCell;
@protocol AbilltyListCellDelegate <NSObject>

-(void)PushCellDelete:(AbilltyListCell*)cell model:(SkillDataModel*)model;
-(void)GestureGo:(AbilltyListCell*)cell isReset:(BOOL)isReset;

@end
@interface AbilltyListCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <AbilltyListCellDelegate>delegate;
@property(nonatomic,strong)SkillDataModel *model;

- (void)configureWithModel:(SkillDataModel*)model;
-(void)resetCell;
-(void)swip;
@end
