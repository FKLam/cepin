//
//  BaseFullCell.m
//  cepin
//
//  Created by dujincai on 15-4-23.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseFullCell.h"
#import "NSDate-Utilities.h"
@implementation BaseFullCell

- (void)createCellWithModel:(id)model height:(int)height
{
    //传模型和高度
}
- (void)createCellWithModel:(id)model
{
    //传模型
}

//时间
- (NSString *)managestrTime:(NSString *)time
{
    if (!time || [time isEqualToString:@""]) {
        return @"至今";
    }else{
//    NSArray *array = [time componentsSeparatedByString:@" "];
    return [NSDate cepinYMDFromString:time];
   }
}

- (void)desWithOut:(BOOL)none
{
    //判断是否有数据
}

- (void)getModel:(id)model
{
    //cell上显示数据
}

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
