//
//  MeHeadCell.h
//  cepin
//
//  Created by dujincai on 15/6/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoDTO.h"
@interface MeHeadCell : UITableViewCell
@property(nonatomic,strong)UIImageView *leftImage;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIImageView *rightArrow;

-(void)setLabelTitleText:(UserInfoDTO*)userDTO;
@end
