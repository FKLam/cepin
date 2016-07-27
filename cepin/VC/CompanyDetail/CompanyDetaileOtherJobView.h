//
//  CompanyDetaileOtherJobView.h
//  cepin
//
//  Created by dujincai on 15/5/28.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyDetailModelDTO.h"
@class CPRecommendModelFrame;


@protocol CompanyDetaileOtherJobViewDelegate <NSObject>

- (void)didTouchOtherJob:(CPRecommendModelFrame *)recommendModelFrame;

@end

@interface CompanyDetaileOtherJobView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)CompanyDetailModelDTO *positionModel;
@property(nonatomic,strong)NSMutableArray *positionIdArray;
@property(nonatomic)id <CompanyDetaileOtherJobViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame model:(CompanyDetailModelDTO *)model positionIds:(NSMutableArray *)positionIds;

@end
