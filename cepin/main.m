//
//  main.m
//  cepin
//
//  Created by tassel.li on 14-10-9.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TBAppDelegate.h"

int main(int argc, char * argv[])
{
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([TBAppDelegate class]));
        }
    }
    @catch ( NSException *exception ){
        NSLog(@"Exception = %@\nStack Trace:%@", exception, [exception callStackSymbols]);
    }

}
