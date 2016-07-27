//
//  CompanyAddressMapCell.h
//  cepin
//
//  Created by dujincai on 15/7/21.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyAddressMapCell : UITableViewCell
@property(nonatomic,strong)UIButton     *addressButton;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIImageView *addressImage;
@property(nonatomic,strong)UIView *viewCell;

+(int)computerCellHeihgt:(NSString*)str;
@end
