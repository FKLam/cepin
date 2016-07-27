//
//  UserThirdLoginInfoDTO.m
//  cepin
//
//  Created by ricky.tang on 14-10-15.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "UserThirdLoginInfoDTO.h"
#import "FileManagerHelper.h"
#import "UMSocialSnsPlatformManager.h"

@implementation UserThirdLoginInfoDTO

/*+(instancetype)infoWithDictionary:(NSDictionary *)dic
{
    UserThirdLoginInfoDTO *user = nil;
    
    NSError *error = nil;
    if (dic[@"sina"])
    {
        user = [[UserThirdLoginInfoDTO alloc] initWithDictionary:dic[@"sina"] error:&error];
        user.type = @"sina";
    }
    else if(dic[@"qzone"])
    {
        user = [[UserThirdLoginInfoDTO alloc] initWithDictionary:dic[@"qzone"] error:&error];
        user.type = @"qzone";
    }
    else
    {
        user = [[UserThirdLoginInfoDTO alloc] initWithDictionary:dic[@"renren"] error:&error];
        user.type = @"renren";
    }
    
    NSAssert(error == nil, @"UserThirdLoginInfoDTO FAIL");
    
    [FileManagerHelper writeObject:user file:NSStringFromClass([UserThirdLoginInfoDTO class]) folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
    
    return user;
}*/

+(void)disconnect
{
    UserThirdLoginInfoDTO *bean = [UserThirdLoginInfoDTO info];
    if ([bean.type isEqualToString:@"Sina"])
    {
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina completion:^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
        }];
    }
    else if([bean.type isEqualToString:@"Tencent"])
    {
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ completion:^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
        }];
    }
    else if([bean.type isEqualToString:@"UMShareToRenren"])
    {
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina completion:^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
        }];
    }
    else
    {
        
    }
}

-(void)saveToFile
{
     [FileManagerHelper writeObject:self file:NSStringFromClass([UserThirdLoginInfoDTO class]) folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
}


+(UserThirdLoginInfoDTO *)info
{
    return [FileManagerHelper readObjectWithfile:NSStringFromClass([UserThirdLoginInfoDTO class]) folder:nil sandBoxFolder:kUseDocumentTypeLibraryCaches];
}

@end
