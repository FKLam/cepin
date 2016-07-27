//
//  AllResumeCell.h
//  cepin
//
//  Created by ceping on 15-3-10.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FUIButton.h"

@interface AllResumeCell : UITableViewCell

@property(nonatomic,retain)UIImageView *topImageIcon;//默认简历图、

@property(nonatomic,retain)UILabel     *resumeNameLable;//简历名称
@property(nonatomic,retain)UILabel     *reviewNumLable;//已阅数
@property(nonatomic,retain)UIButton *moreImageIcon;
@property(nonatomic,retain)UIButton    *moreButton;
@property(nonatomic,retain)UIView      *lineView;
@property(nonatomic,retain)UIView      *endView;
//3.1新增
@property(nonatomic,retain)UIView *resumeOperaView;//简历操作
@property(nonatomic,retain)UIImageView *schoolImageIcon;//校招简历图标
@property(nonatomic,retain)UILabel     *canSend;//是否可投
@property(nonatomic,strong)UIButton *readBtn;//浏览简历
@property(nonatomic,strong)UIButton *setDefaultBtn;//设置为默认简历
@property(nonatomic,strong)UIButton *cpBtn;//复制简历
@property(nonatomic,strong)UIButton *deleteBtn;//删除简历

@property(nonatomic)BOOL isSchool;//是否校招
@property(nonatomic)BOOL isDefault;//是否默认简历
@property(nonatomic,strong)NSNumber *isShowMenu;//是否显示简历（1显示 2不显示）



@end
