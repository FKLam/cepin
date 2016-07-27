//
//  BaseCollectionObject.m
//  yanyunew
//
//  Created by Ricky Tang on 14-5-7.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "BaseCollectionObject.h"

@implementation BaseCollectionObject
-(id)initWithDatas:(NSMutableArray *)datas viewController:(UIViewController *)vc
{
    if (self = [super init]) {
        self.datas = datas;
        self.viewController = vc;
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{return 0;}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{return nil;}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{return nil;}
@end
