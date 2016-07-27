//
//  JobDynamicCellNew.h
//  cepin
//
//  Created by zhu on 15/1/5.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TKRoundedView.h"

@interface JobDynamicCellNew : UITableViewCell

@property(nonatomic,retain)TKRoundedView *viewBlockBackground;
@property(nonatomic,retain)UILabel *labelName;
@property(nonatomic,retain)UILabel *labelAddress;
@property(nonatomic,retain)UILabel *labelSarly;
@property(nonatomic,retain)UIImageView *imageArrow;

@end
