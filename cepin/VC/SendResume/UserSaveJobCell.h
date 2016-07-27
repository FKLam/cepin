//
//  UserSaveJobCell.h
//  cepin
//
//  Created by ricky.tang on 14-10-28.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SendReumeModel;

@interface UserSaveJobCell : UITableViewCell

@property(nonatomic,strong) UILabel *labelTitle;
@property(nonatomic,strong) UILabel *labelState;
@property(nonatomic,strong) UILabel *detailLable;
@property(nonatomic,strong) UILabel *time;

@property (nonatomic, strong) UIView *lineView;
-(void)configWithBean:(SendReumeModel*)bean;

@end
