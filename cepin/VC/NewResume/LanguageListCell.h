//
//  LanguageListCell.h
//  cepin
//
//  Created by dujincai on 15/6/25.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeNameModel.h"
@class LanguageListCell;
@protocol LanguageListCellDelegate <NSObject>

-(void)PushCellDelete:(LanguageListCell*)cell model:(LanguageDataModel*)model;
-(void)GestureGo:(LanguageListCell*)cell isReset:(BOOL)isReset;

@end
@interface LanguageListCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,retain)UIView       *containerView;
@property(nonatomic,retain)UIButton     *deleteButton;
@property(nonatomic,retain)UIImageView  *btnImage;
@property(nonatomic,retain)UILabel      *btnTitle;
@property(nonatomic,retain)UISwipeGestureRecognizer      *swipGesture;
@property(nonatomic,strong)id <LanguageListCellDelegate>delegate;
@property(nonatomic,strong)LanguageDataModel *model;

- (void)configureWithModel:(LanguageDataModel*)model;
-(void)resetCell;
-(void)swip;
@end
