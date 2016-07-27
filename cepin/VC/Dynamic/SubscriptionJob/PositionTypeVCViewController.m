//
//  PositionTypeVCViewController.m
//  cepin
//
//  Created by dujincai on 15/11/19.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "PositionTypeVCViewController.h"
#import "RTSelectedCell.h"
@interface PositionTypeVCViewController ()
@property(nonatomic,strong)NSArray *titles;
@end

@implementation PositionTypeVCViewController

- (instancetype)initWithJobModel:(SubscriptionJobModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
        self.titles = @[@"不限",@"校园招聘",@"社会招聘"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"招聘类型";
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.rowHeight = 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTSelectedCell *cell = [RTSelectedCell cellForTableView:tableView fromNib:[RTSelectedCell nib] andOwner:self];
    
    //    BaseCode *item = self.viewModel.datas[indexPath.row];
    
    cell.labelTitle.text = self.titles[indexPath.row];
    cell.labelSub.hidden = YES;

    if (indexPath.row == 0 && ([self.model.positionType isEqualToString:@""] || !self.model.positionType)) {
        cell.isSelected = YES;
    }else
        
        if ([[NSString stringWithFormat:@"%ld",[indexPath row]]isEqualToString:self.model.positionTypekey]) {
            cell.isSelected = YES;
        }else
        {
            cell.isSelected = NO;
        
    }
    
    cell.buttonSelected.userInteractionEnabled = NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTSelectedCell *c = (RTSelectedCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //将现在的选中
    c.isSelected = YES;
    
   
    if ([indexPath row]==0) {
         self.model.positionType = @"";
        self.model.positionTypekey = @"";
    }else{
         self.model.positionType = self.titles[indexPath.row];
        self.model.positionTypekey = [NSString stringWithFormat:@"%ld",[indexPath row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
