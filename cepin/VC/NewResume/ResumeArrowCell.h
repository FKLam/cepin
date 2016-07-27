//
//  ResumeArrowCell.h
//  cepin
//
//  Created by dujincai on 15/6/3.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPResumeTextField.h"

@interface ResumeArrowCell : UITableViewCell
@property(nonatomic,strong)CPResumeTextField *infoText;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *line;

@property (nonatomic, assign) BOOL showStar;

- (void)configureInfoText:(NSString*)text;
@end
