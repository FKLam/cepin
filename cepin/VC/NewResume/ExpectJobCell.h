//
//  ExpectJobCell.h
//  cepin
//
//  Created by dujincai on 15/6/10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPResumeTextField.h"

@interface ExpectJobCell : UITableViewCell
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)CPResumeTextField *placeholderField;
@property(nonatomic,strong)UIImageView *inputImage;
@property(nonatomic,strong)UIButton *clickButton;

-(void)configureTextFieldText:(NSString*)text;
@end
