//
//  SaveJobCell.h
//  cepin
//
//  Created by dujincai on 15/6/4.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveJobDTO.h"

@interface SaveJobCell : UITableViewCell
@property(nonatomic,strong)UIButton *buttonDelete;
@property(nonatomic,strong)UILabel *positionLabel;
@property(nonatomic,strong)UILabel *salaryLabel;
@property(nonatomic,strong)UILabel *companyLabel;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UIImageView *deleImage;
@property(nonatomic,assign)BOOL isChoice;
@property (nonatomic, strong) UIView *lineView;

-(void)configWithSaveBean:(SaveJobDTO*)bean;

-(void)setChoice:(BOOL)isChoice;


@end
