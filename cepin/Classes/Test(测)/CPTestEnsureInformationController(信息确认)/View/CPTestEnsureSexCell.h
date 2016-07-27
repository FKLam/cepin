//
//  CPTestEnsureSexCell.h
//  cepin
//
//  Created by ceping on 16/1/15.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM( NSInteger, CPSexButtonType )
{
    CPSexButtonMale = 100,
    CPSexButtonFemale
};
@class CPTestEnsureSexCell;
@protocol CPTestEnsureSexCellDelegate <NSObject>

@optional
- (void)ensureSexCell:(CPTestEnsureSexCell *)ensureSexCell changeSexWithSexNumber:(NSInteger)sexNumber;

@end
@interface CPTestEnsureSexCell : UITableViewCell
@property (nonatomic, weak) id<CPTestEnsureSexCellDelegate> ensureSexCellDelegate;
+ (instancetype)ensureSexCellWithTableView:(UITableView *)tableView;
- (void)configWithSex:(NSNumber *)sexNumber;
@end
