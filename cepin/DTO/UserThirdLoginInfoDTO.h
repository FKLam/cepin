//
//  UserThirdLoginInfoDTO.h
//  cepin
//
//  Created by ricky.tang on 14-10-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "JSONModel.h"


/**
 *  sina =     {
 birthday = "<null>";
 company = "<null>";
 education = "<null>";
 gender = 1;
 icon = "http://tp1.sinaimg.cn/1850180184/180/1300756458/1";
 "profile_url" = "http://www.weibo.com/u/1850180184";
 tags =         (
 "IT\U6570\U7801"
 );
 username = RickyTT;
 usid = 1850180184;
 };
 *
 
 
 qzone =     {
 birthday = "<null>";
 company = "<null>";
 education = "<null>";
 gender = "\U7537";
 icon = "http://qzapp.qlogo.cn/qzapp/100424468/CBE5B575FFF7E3B23944F5B89CACAD11/100";
 openid = CBE5B575FFF7E3B23944F5B89CACAD11;
 "profile_url" = "";
 tags =         (
 );
 username = "T T";
 usid = CBE5B575FFF7E3B23944F5B89CACAD11;
 };
 */

@interface UserThirdLoginInfoDTO : JSONModel

@property(nonatomic,strong)NSString<Optional> *usid;
@property(nonatomic,strong)NSString<Optional> *username;
@property(nonatomic,strong)NSString<Optional> *type;

//+(instancetype)infoWithDictionary:(NSDictionary *)dic;

+(UserThirdLoginInfoDTO *)info;

-(void)saveToFile;
+(void)disconnect;




@end
