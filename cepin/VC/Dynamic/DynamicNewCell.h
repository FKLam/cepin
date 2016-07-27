//
//  DynamicNewCell.h
//  cepin
//
//  Created by zhu on 14/12/13.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DynamicNewModel.h"

@class DynamicNewCell;
@protocol DynamicCellDelegate <NSObject>

-(void)PushCellToTop:(DynamicNewCell*)cell;
-(void)PushCellDelete:(DynamicNewCell*)cell;
-(void)GestureGo:(DynamicNewCell*)cell isReset:(BOOL)isReset;

@end

@interface DynamicNewCell : UITableViewCell

@property(nonatomic,assign)id<DynamicCellDelegate> delegate;

@property(nonatomic,retain)UIView  *whiteView;
@property(nonatomic,retain)UIImageView *imageBackground;
@property(nonatomic,retain)UIImageView *imageLogo;
@property(nonatomic,retain)UILabel *labelTitle;
@property(nonatomic,retain)UILabel *labelDetail;
@property(nonatomic,retain)UILabel *labelTime;
@property(nonatomic,retain)UILabel *labelNumber;
@property(nonatomic,retain)UIButton *toTopButton;
@property(nonatomic,retain)UIButton *deleteButton;
@property(nonatomic,assign)BOOL  canSwip;
@property(nonatomic,retain)UIView   *maskView;
@property(nonatomic,retain)UILabel  *maskTitleLable;

@property(nonatomic,retain)UISwipeGestureRecognizer *swipGesture;

-(void)resetCell;

-(void)configureWithModel:(DynamicNewModel*)model;

@end
