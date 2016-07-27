//
//  BannerModel.h
//  cepin
//
//  Created by ceping on 15-1-15.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "BaseBeanModel.h"

@interface BannerModel : BaseBeanModel

@property(nonatomic,strong)NSString<Optional> *ImgUrl;	//String	图片链接(完整的图)
@property(nonatomic,strong)NSString<Optional> *LinkUrl;	//String	图片点击链接
@property(nonatomic,strong)NSString<Optional> *Title;	//String	标题

// 广告新增三个字段
@property (nonatomic, copy) NSString<Optional> *AdvType;        //  广告类型
@property (nonatomic, copy) NSString<Optional> *AppPage;        //  App页面
@property (nonatomic, copy) NSString<Optional> *AppPageParam;   //  App页面参数
@property (nonatomic, strong) NSNumber<Optional> *Id;           //  广告Id

+(BannerModel *)bannerWithDic:(NSDictionary *)dic name:(NSString*)name;

+(BannerModel *)bannerModelFromName:(NSString*)fileName;

@end
