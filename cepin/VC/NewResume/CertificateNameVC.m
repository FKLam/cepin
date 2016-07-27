//
//  CertificateNameVC.m
//  cepin
//
//  Created by dujincai on 15/6/18.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "CertificateNameVC.h"
#import "BaseCodeDTO.h"
#import "ResumeChooseCell.h"
#import "CPCommon.h"
@interface CertificateNameVC ()
@property(nonatomic,strong)NSMutableArray *certData;

@end

@implementation CertificateNameVC
- (instancetype)initWithEduModel:(CredentialListDataModel *)model
{
    self = [super init];
    if (self) {
        self.certData = [NSMutableArray new];
        self.certData = [BaseCode Certificate];
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"证书名称";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.certData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResumeChooseCell class])];
    if (cell == nil) {
        cell = [[ResumeChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ResumeChooseCell class])];
    }
    
    BaseCode *item = self.certData[indexPath.row];
    cell.titleLabel.text = item.CodeName;
    if ([self.model.Name isEqualToString:item.CodeName]) {
        cell.chooseImage.hidden = NO;
    }else
    {
        cell.chooseImage.hidden = YES;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.certData count] - 1 )
        isShowAll = YES;
    [cell showSeparatorLine:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *item = self.certData[indexPath.row];
    self.model.Name = item.CodeName;
    self.model.BaseCodeKey = [NSString stringWithFormat:@"%@",item.CodeKey];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
