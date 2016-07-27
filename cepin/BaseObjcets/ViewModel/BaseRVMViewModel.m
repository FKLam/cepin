//
//  BaseRVMViewModel.m
//  letsgo
//
//  Created by Ricky Tang on 14-7-31.
//  Copyright (c) 2014年 Ricky Tang. All rights reserved.
//

#import "BaseRVMViewModel.h"
#import "RTHUDModel.h"
#import "AutoLoginVM.h"

@implementation BaseRVMViewModel


/*-(void)AutoLogin
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults]objectForKey:@"IsThirdPartLogin"];
    if (number && number.intValue == 1)
    {
        [self thirdPartLogin];
    }
    else
    {
        [self normalLogin];
    }
}*/

-(void)CheckErrorCode:(NSDictionary*)dic
{
}

-(BOOL)CheckLoginOut
{
    AutoLoginVM *viewModel = [AutoLoginVM new];
    [viewModel autoLogin];
    return NO;
}


-(void)momeryRelease
{
    
}


@end
