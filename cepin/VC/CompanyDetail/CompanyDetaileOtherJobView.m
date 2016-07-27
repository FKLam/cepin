//
//  CompanyDetaileOtherJobView.m
//  cepin
//
//  Created by dujincai on 15/5/28.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CompanyDetaileOtherJobView.h"
#import "OtherJobViewCell.h"
#import "PositionIdModel.h"
#import "RecommendCell.h"
#import "CPRecommendModelFrame.h"
#import "CPRecommendCell.h"
#import "JobSearchVM.h"
#import "JobSearchModel.h"

@interface CompanyDetaileOtherJobView()

@property (nonatomic, strong) NSArray *recommendArray;

@end

@implementation CompanyDetaileOtherJobView

- (NSArray *)recommendArray
{
    if( !_recommendArray )
    {
        NSMutableArray *recommendM = [NSMutableArray array];
        
        if( 0 < _positionModel.AppPositionInfoList.count )
        {
            for( int index = 0; index < _positionModel.AppPositionInfoList.count; index++ )
            {
                CPRecommendModelFrame *recommendModelFrame = [CPRecommendModelFrame recommendModel:[JobSearchModel beanFromDictionary:self.positionModel.AppPositionInfoList[index]]];
                [recommendM addObject:recommendModelFrame];
            }
        }
        _recommendArray = [recommendM copy];
    }
    return _recommendArray;
}

- (instancetype)initWithFrame:(CGRect)frame model:(CompanyDetailModelDTO *)model positionIds:(NSMutableArray *)positionIds
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.positionModel = model;
        
        if ( self.positionModel )
        {
            CGFloat height = 0;
            for (CPRecommendModelFrame *recommend in self.recommendArray)
            {
                height += recommend.totalFrame.size.height;
            }
            
            CGRect tempFrame = frame;
            tempFrame.size.height += height;
            frame = tempFrame;
        }
        
        self.positionIdArray = positionIds;
        self.tableview = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        self.tableview.scrollEnabled = NO;
        self.tableview.scrollsToTop = NO;
        [self addSubview:self.tableview];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//        return IS_IPHONE_5?110:130;
    CPRecommendModelFrame *recommendModelFrame = self.recommendArray[indexPath.row];
    if ( nil != recommendModelFrame ){
        return recommendModelFrame.totalFrame.size.height;
    }
    else
        return IS_IPHONE_5?110:130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return self.positionModel.AppPositionInfoList.count;
    return self.recommendArray.count;
}


- (void)drawCell:(CPRecommendCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell clear];
    
    CPRecommendModelFrame *recommendModelFrame;
    
    if( self.recommendArray.count > 0 )
        recommendModelFrame = self.recommendArray[indexPath.row];
    
    
    // 检查cell是否被查阅过
    BOOL isChecked = NO;
    
    JobSearchModel *recommendModel = nil;
    
    if( [recommendModelFrame.recommendModel isKindOfClass:[JobSearchModel class]] )
        recommendModel = (JobSearchModel *)recommendModelFrame.recommendModel;

    if( nil != recommendModel )
    {
        for (PositionIdModel *model in self.positionIdArray) {
            
            if ([model.positionId isEqualToString:recommendModel.PositionId]) {
                isChecked = YES;
                break;
            }
        }
    }
    
    recommendModelFrame.isCheck = isChecked;
    
    cell.recommendModelFrame = recommendModelFrame;
    
    [cell draw];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommendCell *cell = [CPRecommendCell recommendCellWithTableView:tableView];
    
    [self drawCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didTouchOtherJob:)]) {
        
        CPRecommendModelFrame *recommendModelFrame = self.recommendArray[indexPath.row];
        
        [self.delegate didTouchOtherJob:recommendModelFrame];
    }
}
@end
