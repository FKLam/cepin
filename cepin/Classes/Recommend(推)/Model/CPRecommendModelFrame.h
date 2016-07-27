//
//  CPRecommendModelFrame.h
//  cepin
//
//  Created by ceping on 15/11/19.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JobSearchModel;

@interface CPRecommendModelFrame : NSObject

/** 推荐页列表数据模型 */
@property (nonatomic, strong) id recommendModel;
/** 收藏图标的frame */
@property (nonatomic, assign) CGRect cllectionFrame;
/** 职位的frame */
@property (nonatomic, assign) CGRect positionFrame;
/** 简历类型图标的frame */
@property (nonatomic, assign) CGRect resumeTypeFrame;
/** 职位置顶图标的frame */
@property (nonatomic, assign) CGRect topFrame;
/** 职位发布时间的frame */
@property (nonatomic, assign) CGRect timeFrame;
/** 工作地点的frame */
@property (nonatomic, assign) CGRect addressFrame;
/** 工作年限的frame */
@property (nonatomic, assign) CGRect experienceFrame;
/** 学历的frame */
@property (nonatomic, assign) CGRect educationFrame;
/** 薪水的frame */
@property (nonatomic, assign) CGRect saleFrame;
/** 公司的frame */
@property (nonatomic, assign) CGRect companyFrame;
/** 职位诱惑的frame数组 */
@property (nonatomic, strong) NSArray *temptationsFrames;
@property (nonatomic, strong) NSArray *temptations;
/** 整个数据模型在cell中的frame */
@property (nonatomic, assign) CGRect totalFrame;
/** 公司简称 */
@property (nonatomic, assign) CGRect shortNameFrame;

@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, assign) CGFloat maxMarge;
@property (nonatomic, assign) CGSize positionSize;
@property (nonatomic, assign) CGFloat totalHeight;

/**
 *  返回职位模型数据recommendModelFrame
 *
 *  @param  recommendModel JobSearchModel模型
 */
+ (instancetype)recommendModel:(id)modelObject;

/**
 *  返回职位模型数据frame的数组
 *
 *  @param array 存放JobSearchModel模型的数组
 */
+ (NSArray *)framesWithArray:(NSArray *)array modelClass:(__unsafe_unretained Class)modelClass;

@end
