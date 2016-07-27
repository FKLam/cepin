//
//  CPSearchCityFilterView.h
//  cepin
//
//  Created by dujincai on 16/2/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPSearchFilterView.h"

@interface CPSearchCityFilterView : UIView
@property(nonatomic,weak) id<HotCityChangeDeleger> hotCityfilterChangeDeleger;
//-(instancetype)initWithFrame:(CGRect)frame city:(NSString *)selectCity ;
-(instancetype)initWithFrame:(CGRect)frame city:(NSString *)selectCity otherCityHeight:(CGFloat)height;
@property(nonatomic,strong)NSString *selectCity;
-(void)configView;
@end
