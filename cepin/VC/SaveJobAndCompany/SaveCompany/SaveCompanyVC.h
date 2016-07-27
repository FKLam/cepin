//
//  SaveCompanyVC.h
//  cepin
//  关注企业
//  Created by ricky.tang on 14-10-29.
//  Copyright (c) 2014年 talebase. All rights reserved.
//

#import "BaseTableViewController.h"


@protocol SaveCompanyVCDelegate <NSObject>

- (void)getCompanySelect:(NSMutableArray*)array;

@end




@interface SaveCompanyVC : BaseTableViewController
{
    BOOL isAddFooterView;
}
@property(nonatomic,strong)id<SaveCompanyVCDelegate>delegate;

- (void)reloadData;
@end
