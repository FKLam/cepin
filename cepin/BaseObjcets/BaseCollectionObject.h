//
//  BaseCollectionObject.h
//  yanyunew
//
//  Created by Ricky Tang on 14-5-7.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCollectionObject : NSObject<UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)UIViewController *viewController;

-(id)initWithDatas:(NSMutableArray *)datas viewController:(UIViewController *)vc;
@end
