//
//  ResumeCALCell.h
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class ResumeCALCell;
@protocol ResumeCALCellDelegate <NSObject>

-(void)PushCellDelete:(ResumeCALCell*)cell model:(CredentialListDataModel*)model;
-(void)GestureGo:(ResumeCALCell*)cell isReset:(BOOL)isReset;

@end
@interface ResumeCALCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <ResumeCALCellDelegate>delegate;
@property(nonatomic,strong)CredentialListDataModel *model;

- (void)configureWithModel:(CredentialListDataModel*)model;
-(void)resetCell;
-(void)swip;
@end
