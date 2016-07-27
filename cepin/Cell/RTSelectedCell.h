//
//  RTSelectedCell.h
//  cepin
//
//  Created by ricky.tang on 14-10-22.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTSelectedCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel *labelTitle;
@property(nonatomic,weak)IBOutlet UILabel *labelSub;
@property(nonatomic,weak)IBOutlet UIButton *buttonSelected;
@property (weak, nonatomic) IBOutlet UIView *line;
@property(nonatomic,readwrite)BOOL isSelected;

@end
