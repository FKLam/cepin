//
//  JobFilterCell.h
//  cepin
//
//  Created by zhu on 14/12/14.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseCustomLineCell.h"

@interface JobFilterCell : BaseCustomLineCell

@property(nonatomic,retain)UILabel *labelTitle;
@property(nonatomic,retain)UILabel *labelSub;
@property(nonatomic,retain)UIImageView *imageViewArrow;

-(void)configureLableTitleText:(NSString*)text;
-(void)configureLableSubText:(NSString*)text;

@end
