//
//  FullExamReportCell.h
//  cepin
//
//  Created by dujincai on 15/7/29.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullExamReportCell : UITableViewCell
//@property(nonatomic,strong)UILabel *titleLabel;
//@property(nonatomic,strong)UILabel *appendText;
@property(nonatomic,strong)UIButton *readExam;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
