//
//  CPJobInformationFrame.h
//  cepin
//
//  Created by ceping on 15/12/3.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JobDetailModelDTO;

@interface CPJobInformationFrame : NSObject

/** 职位详情数据模型 */
@property (nonatomic, strong) JobDetailModelDTO *jobInformation;
/** 职位frame */
@property (nonatomic, assign) CGRect positionFrame;
/** 薪水frame */
@property (nonatomic, assign) CGRect saleFrame;
/** 具体详情frame */
@property (nonatomic, assign) CGRect informatonFrame;
/** 公司名称 */
@property (nonatomic, assign) CGRect companyNameFrame;
/** 整体的高度 */
@property (nonatomic, assign) CGFloat totalHeight;

@end
