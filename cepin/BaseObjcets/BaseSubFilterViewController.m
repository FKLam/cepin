//
//  BaseSubFilterViewController.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-30.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseSubFilterViewController.h"
#import "RTAPPHelper.h"
#import "BaseTableObject.h"

@interface BaseSubFilterViewController ()

@end

@implementation BaseSubFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.frame = CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.tableView.frame)-self.navigationController.navigationBar.frame.size.height);
    
    self.tableView.rowHeight = 44;
    
    self.navigationItem.rightBarButtonItem = nil;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (TABVIEWISSHOW) {
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
//    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;//[[RTAPPHelper shareInstance] cellHeightWithClassName:[[[self.tableObject datas] objectAtIndex:indexPath.row] objectForKey:PlistCellClass]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //RTLog(@"currentID %d",self.currentID);
    //RTLog(@"currentName %@",self.currentName);
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectedName:value:index:viewController:)]) {
        [self.delegate selectedName:self.currentName value:self.currentID index:self.currentIndex viewController:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
