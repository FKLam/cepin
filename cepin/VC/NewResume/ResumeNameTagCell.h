//
//  ResumeNameTagCell.h
//  cepin
//
//  Created by dujincai on 15/7/8.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOTag.h"
@interface ResumeNameTagCell : UITableViewCell
@property(nonatomic,strong)UIImageView *arrowImage;
@property(nonatomic,strong)UIView *tagView;
@property(nonatomic,strong)AOTagList *tagList;
@property(nonatomic,strong)UILabel *title;
+(int)computerTextWidth:(NSString*)str;

- (void)createTagWith:(NSString*)str;

@end
