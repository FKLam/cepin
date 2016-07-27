//
//  SubscriptionJobCell.h
//  cepin
//
//  Created by dujincai on 15/5/22.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptionJobCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imageLogo;
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UITextField *placeholderField;
@property(nonatomic,strong)UIImageView *inputImage;
@property(nonatomic,strong)UIButton *clickButton;
-(void)configureTextFieldText:(NSString*)text;
@end
