//
//  CertifierVC.m
//  cepin
//
//  Created by dujincai on 15/11/16.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "CertifierVC.h"
#import "ResumeEditCell.h"
#import "UIViewController+NavicationUI.h"
#import "CPTestEnsureEditCell.h"
#import "CPTipsView.h"
#import "CPCommon.h"
@interface CertifierVC ()<UITextFieldDelegate, CPTipsViewDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property (nonatomic, strong) CPTipsView *tipsView;
@end
@implementation CertifierVC

-(instancetype)initWithModel:(WorkListDateModel *)model{
    self = [super init];
    if (self) {
        self.model = model;
        self.titleArray = @[@"证明人姓名", @"证明人关系", @"证明人职务", @"证明人单位", @"证明人电话"];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"证明人";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    [self createNoHeadImageTable];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(30 / CP_GLOBALSCALE, 0, 0, 0)];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        if (!self.model.AttestorName || [@"" isEqualToString:self.model.AttestorName]) {
            [self showMessageTips:@"请输入证明人姓名"];
            return ;
        }
        if (!self.model.AttestorRelation || [@"" isEqualToString:self.model.AttestorRelation]) {
            [self showMessageTips:@"请输入证明人关系"];
            return ;
        }
        if (!self.model.AttestorPosition || [@"" isEqualToString:self.model.AttestorPosition]) {
            [self showMessageTips:@"请输入证明人职务"];
            return ;
        }
        if (!self.model.AttestorCompany || [@"" isEqualToString:self.model.AttestorCompany]) {
            [self showMessageTips:@"请输入证明人单位"];
            return ;
        }
        if (!self.model.AttestorPhone || [@"" isEqualToString:self.model.AttestorPhone]) {
            [self showMessageTips:@"请输入证明人电话"];
            return ;
        }
        else if( 0 < [self.model.AttestorPhone length] )
        {
            if ( ![APPFunctionHelper checkMobileAndPhoneText:self.model.AttestorPhone] )
            {
                [self showMessageTips:@"证明人电话格式不正确"];
                return;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTestEnsureEditCell *cell = [CPTestEnsureEditCell ensureEditCellWithTableView:tableView];
    [cell.inputTextField setTag:indexPath.row + indexPath.section * 10];
    NSString *leftTitleStr = self.titleArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
            {
                [cell configCellLeftString:leftTitleStr placeholder:@"请输入证明人姓名"];
                cell.inputTextField.text = self.model.AttestorName;
                [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                        return;
                    self.model.AttestorName = text;
                }];
            }
            break;
        case 1:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请输入证明人关系"];
            cell.inputTextField.text = self.model.AttestorRelation;
            [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                    return;
                self.self.model.AttestorRelation = text;
            }];
        }
            break;
        case 2:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请输入证明人职务"];
            cell.inputTextField.text = self.model.AttestorPosition;
            [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                    return;
                self.self.model.AttestorPosition = text;
            }];
        }
            break;
        case 3:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请输入证明人单位"];
            cell.inputTextField.text = self.model.AttestorCompany;
            [cell.inputTextField setKeyboardType:UIKeyboardTypeDefault];
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                    return;
                self.self.model.AttestorCompany = text;
            }];
        }
            break;
        case 4:
        {
            [cell configCellLeftString:leftTitleStr placeholder:@"请输入证明人电话"];
            cell.inputTextField.text = self.model.AttestorPhone;
            [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row + indexPath.section * 10 != cell.inputTextField.tag )
                    return;
                self.self.model.AttestorPhone = text;
            }];
        }
            break;
            
    default:
            break;
    }
    BOOL isShowAll = NO;
    if ( indexPath.row == [self.titleArray count] - 1 )
        isShowAll = YES;
    [cell resetSeparatorLineShowAll:isShowAll];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark - UISrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)showMessageTips:(NSString *)tips
{
    self.tipsView = [self messageTipsViewWithTips:tips];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tipsView];
}
#pragma mark - CPTipsViewDelegate
- (void)tipsView:(CPTipsView *)tipsView clickCancelButton:(UIButton *)cancelButton
{
    self.tipsView = nil;
}
- (CPTipsView *)messageTipsViewWithTips:(NSString *)tips
{
    if ( !_tipsView )
    {
        _tipsView = [CPTipsView tipsViewWithTitle:@"提示" buttonTitles:@[@"确定"] showMessageVC:self message:tips];
        _tipsView.tipsViewDelegate = self;
    }
    return _tipsView;
}
@end
