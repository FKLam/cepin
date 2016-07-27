//
//  ResumeProjectCell.h
//  cepin
//
//  Created by dujincai on 15/6/17.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class ResumeProjectCell;
@protocol ResumeProjectCellDelegate <NSObject>

-(void)PushCellDelete:(ResumeProjectCell*)cell model:(ProjectListDataModel*)model;
-(void)GestureGo:(ResumeProjectCell*)cell isReset:(BOOL)isReset;

@end

@interface ResumeProjectCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)UILabel *describeLabel;
@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <ResumeProjectCellDelegate>delegate;
@property(nonatomic,strong)ProjectListDataModel *model;

- (void)configureWithModel:(ProjectListDataModel*)model;
-(void)resetCell;
-(void)swip;
@end
