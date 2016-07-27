//
//  DynamicCompanyTalkCell.h
//  cepin
//
//  Created by ceping on 14-12-12.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CompanyTalkTopOffsetY  39
#define CompnayTalkTimeHeight  21
#define CompanyTalkLogoOffsetX 15
#define CompanyTalkLogoOffsetY CompanyTalkTopOffsetY + CompnayTalkTimeHeight + 12
#define CompanyTalkLogoSize    38
#define CompanyTalkContentOffsetX  CompanyTalkLogoOffsetX + CompanyTalkLogoSize + 8
#define CompanyTalkContentOffsetY  CompanyTalkLogoOffsetY
#define CompanyTalkMaxLength   kScreenWidth - 2*(CompanyTalkContentOffsetX)
#define CompanyTalkDefaultContentHeight  CompanyTalkLogoOffsetY ＋ CompanyTalkLogoSize
#define CompanyTalkContentFont 12

#import "DynamicCompanyChatModel.h"

@interface DynamicCompanyTalkCell : UITableViewCell
{
    
}

@property(nonatomic,retain)UILabel *lableTime;
@property(nonatomic,retain)UIImageView *imageLogo;
@property(nonatomic,retain)UIImageView *imageBackground;
@property(nonatomic,retain)UILabel *lableContent;

+(int)computerTalkContentHeight:(NSString*)str;
+(int)computerTalkCellHeight:(NSString*)str;
-(void)configureText:(NSString*)str;

-(void)configureWithModel:(DynamicCompanyChatModel*)model;

@end
