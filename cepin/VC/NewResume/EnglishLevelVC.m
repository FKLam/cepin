//
//  EnglishLevelVC.m
//  cepin
//
//  Created by dujincai on 15/11/16.
//  Copyright © 2015年 talebase. All rights reserved.
//

#import "EnglishLevelVC.h"
#import "ResumeEditCell.h"
#import "UIViewController+NavicationUI.h"
#import "EnglishLevelVm.h"
#import "CPTestEnsureEditCell.h"
#import "CPCommon.h"
@interface EnglishLevelVC ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)EnglishLevelVm *viewModel;
@property(nonatomic,strong)UITextField *textField;
@end

@implementation EnglishLevelVC

-(instancetype)initWithModel:(ResumeNameModel *)model{
    self = [super init];
    if (self) {
        self.model  = model;
        self.titleArray = @[@"CET4",@"CET6",@"TEM4",@"TEM8",@"托福",@"雅思"];
        self.viewModel = [[EnglishLevelVm alloc] init];
        self.viewModel.showMessageVC = self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"英语等级";
    [self createNoHeadImageTable];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(32 / CP_GLOBALSCALE, 0, 0, 0)];
    [[self addNavicationObjectWithType:NavcationBarObjectTypeConfirm] handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self.view endEditing:YES];
        [self.viewModel saveEnglishLevel:self.model];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    @weakify(self)
    [RACObserve(self.viewModel,stateCode) subscribeNext:^(id stateCode){
        @strongify(self);
        if ([self requestStateWithStateCode:stateCode] == HUDCodeSucess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClick)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
}
- (void)didClick
{
    [self.view endEditing:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
#pragma mark - UITableViewDatasoure UITableViewDelegate
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
    [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
    switch ( indexPath.row ) {
        case 0:
        {
            [cell configCellLeftString:self.titleArray[indexPath.row] placeholder:@"请输入成绩"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
            if ( self.model.IsHasCET4Score.intValue == 1 )
            {
                NSString *score = [NSString stringWithFormat:@"%@",self.model.CET4Score];
                if (![score isEqualToString:@"(null)"])
                {
                    cell.inputTextField.text =  [NSString stringWithFormat:@"%@",self.model.CET4Score];
                }
            }
                [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                    if ( indexPath.row != cell.inputTextField.tag )
                        return;
                   self.model.CET4Score = [NSNumber numberWithDouble:text.doubleValue];
                    if ( text.length > 0 )
                    {
                         self.model.IsHasCET4Score = [NSNumber numberWithInt:1];
                    }
                    else
                    {
                        self.model.IsHasCET4Score = [NSNumber numberWithInt:0];
                    }
            }];
        }
            break;
        case 1:
        {
            [cell configCellLeftString:self.titleArray[indexPath.row] placeholder:@"请输入成绩"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
            if ( self.model.IsHasCET6Score.intValue == 1)
            {
                NSString *score = [NSString stringWithFormat:@"%@",self.model.CET6Score];
                if (![score isEqualToString:@"(null)"]) {
                    cell.inputTextField.text =  [NSString stringWithFormat:@"%@",self.model.CET6Score];
                }
            }
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row != cell.inputTextField.tag )
                    return;
                self.model.CET6Score = [NSNumber numberWithDouble:text.doubleValue];
                if (text.length>0) {
                     self.model.IsHasCET6Score = [NSNumber numberWithInt:1];
                }else{
                    self.model.IsHasCET6Score = [NSNumber numberWithInt:0];
                }
            }];
        }
            break;
        case 2:
        {
            [cell configCellLeftString:self.titleArray[indexPath.row] placeholder:@"请输入成绩"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
            if ( self.model.IsHasTEM4Score.intValue == 1 )
            {
                NSString *score = [NSString stringWithFormat:@"%@",self.model.TEM4Score];
                if (![score isEqualToString:@"(null)"])
                {
                    cell.inputTextField.text =  [NSString stringWithFormat:@"%@",self.model.TEM4Score];
                }
            }
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row != cell.inputTextField.tag )
                    return;
                self.model.TEM4Score = [NSNumber numberWithDouble:text.doubleValue];;
                if (text.length>0)
                {
                    self.model.IsHasTEM4Score = [NSNumber numberWithInt:1];
                }
                else
                {
                    self.model.IsHasTEM4Score = [NSNumber numberWithInt:0];
                }
            }];
        }
            break;
        case 3:
        {
            [cell configCellLeftString:self.titleArray[indexPath.row] placeholder:@"请输入成绩"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
            if ( self.model.IsHasTEM8Score.intValue == 1 ) {
                NSString *score = [NSString stringWithFormat:@"%@",self.model.TEM8Score];
                if (![score isEqualToString:@"(null)"])
                {
                    cell.inputTextField.text =  [NSString stringWithFormat:@"%@",self.model.TEM8Score];
                }
            }
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row != cell.inputTextField.tag )
                    return;
                self.model.TEM8Score = [NSNumber numberWithDouble:text.doubleValue];
                if ( text.length>0 )
                {
                     self.model.IsHasTEM8Score = [NSNumber numberWithInt:1];
                }
                else
                {
                    self.model.IsHasTEM8Score = [NSNumber numberWithInt:0];
                }
            }];
        }
            break;
        case 4:
        {
            [cell configCellLeftString:self.titleArray[indexPath.row] placeholder:@"请输入成绩"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
            if (self.model.IsHasTOEFLScore.intValue == 1) {
                NSString *score = [NSString stringWithFormat:@"%@",self.model.TOEFLScore];
                if (![score isEqualToString:@"(null)"]) {
                    cell.inputTextField.text =  [NSString stringWithFormat:@"%@",self.model.TOEFLScore];
                }
            }
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row != cell.inputTextField.tag )
                    return;
                self.model.TOEFLScore = [NSNumber numberWithDouble:text.doubleValue];
                if (text.length>0) {
                     self.model.IsHasTOEFLScore = [NSNumber numberWithInt:1];
                }else{
                    self.model.IsHasTOEFLScore = [NSNumber numberWithInt:0];
                }
            }];
        }
            break;
        case 5:
        {
            [cell configCellLeftString:self.titleArray[indexPath.row] placeholder:@"请输入成绩"];
            [cell.inputTextField setTag:indexPath.row];
            [cell.inputTextField setKeyboardType:UIKeyboardTypeDecimalPad];
            if (self.model.IsHasIELTSScore.intValue == 1) {
                NSString *score = [NSString stringWithFormat:@"%@",self.model.IELTSScore];
                if (![score isEqualToString:@"(null)"]) {
                    cell.inputTextField.text =  [NSString stringWithFormat:@"%@",self.model.IELTSScore];
                }
            }
            [[cell.inputTextField rac_textSignal] subscribeNext:^(NSString *text) {
                if ( indexPath.row != cell.inputTextField.tag )
                    return;
                self.model.IELTSScore = [NSNumber numberWithDouble:text.doubleValue];
                if (text.length>0) {
                    self.model.IsHasIELTSScore = [NSNumber numberWithInt:1];
                }else{
                    self.model.IsHasIELTSScore = [NSNumber numberWithInt:0];
                }
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
    if (self.textField)
    {
        [self.textField resignFirstResponder];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.textField = nil;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.textField = nil;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 280, 0);
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    });
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self validateNumber:string];
}
- (BOOL)validateNumber:(NSString*)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
    if (range.length == 0) {
        res = NO;
        break;
    }
        i++;
    }
    return res;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
