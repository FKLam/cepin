//
//  BaseFilterViewController.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-28.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseFilterViewController.h"
#import "RTAPPHelper.h"
#import "BaseTableObject.h"


NSString *const FilterDictionaryName = @"FilterDictionaryName";
NSString *const FilterDictionaryValue = @"FilterDictionaryValue";


@interface BaseFilterViewController ()

@end

@implementation BaseFilterViewController
@synthesize delegate,outputDelegate,currentIndex,currentName,currentID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(UIViewController<BaseFilterViewControllerDelegate> *)value index:(NSInteger)index dictionary:(NSDictionary *)dic
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.delegate = value;
        self.view.frame = value.view.frame;
        self.currentIndex = index;
        
        NSAssert([[dic objectForKey:FilterDictionaryName] isKindOfClass:[NSString class]], @"FilterDictionaryName is not String");
        
        NSAssert([[dic objectForKey:FilterDictionaryValue] isKindOfClass:[NSNumber class]], @"FilterDictionaryValue is not number");
        
        self.currentName = [dic objectForKey:FilterDictionaryName];
        self.currentID = [[dic objectForKey:FilterDictionaryValue] longLongValue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    [self setImageButtonOnBarWithType:ButtonOnNaviBarImageTypeRight target:self selector:@selector(saveFitlerData:) position:ButtonOnNaviBarPosisitionRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && self.view.window == nil) {
        self.delegate = nil;
        self.currentName = nil;
    }
}

-(void)setupTableView
{
    CGRect rect;
    rect = self.view.frame;
    
    rect = CGRectMake(rect.origin.x, CGRectGetMinY(rect)-CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]), CGRectGetWidth(rect), CGRectGetHeight(rect)-44);
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}



-(void)saveFitlerData:(id)sender{
    /*[[RTAPPHelper shareInstance] writeFilterDataWithArray:self.tableObject.datas type:FilterTableTypeSearch];
    
    if ([self.outputDelegate respondsToSelector:@selector(didFinishSetTheFilter:)]) {
        [self.outputDelegate didFinishSetTheFilter:self];
    }*/
}

@end
