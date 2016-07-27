//
//  HotSearchKeyModel.h
//  cepin
//
//  Created by dujincai on 16/2/1.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import <Foundation/Foundation.h>

//3.2新增 用于搜索页面的热词
@interface HotSearchModel : BaseBeanModel
@property (nonatomic, strong) NSString<Optional> *SearchId;
@property (nonatomic, strong) NSString<Optional> *Name;

@end
