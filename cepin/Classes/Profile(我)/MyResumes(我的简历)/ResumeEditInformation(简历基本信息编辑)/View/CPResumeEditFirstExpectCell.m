//
//  CPResumeEditFirstExpectCell.m
//  cepin
//
//  Created by ceping on 16/2/24.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEditFirstExpectCell.h"
#import "BaseCodeDTO.h"
#import "CPResumeEditSecondExpectCell.h"
#import "CPCommon.h"
@interface CPResumeEditFirstExpectCell ()<UITableViewDataSource, UITableViewDelegate, CPResumeEditSecondExpectCellDelegate>
@property(nonatomic,retain)UILabel *labelTitle;
@property(nonatomic,retain)UIImageView *imageViewArrow;
@property (nonatomic, strong) NSMutableArray *firstChildArray;
@property (nonatomic, strong) NSMutableArray *secondChildArray;
@property (nonatomic, assign) BOOL isSeleceted;
@property (nonatomic, strong) UITableView *secondTabelView;
@property (nonatomic, strong) NSMutableArray *selectedChildArrayM;
@property (nonatomic, assign) NSInteger selectedFirstRow;
@property (nonatomic, assign) NSInteger selectedSecondRow;
@property (nonatomic, assign) CGFloat contentTableWidth;
@property(nonatomic,assign)UITableView *rootTableView;
@end
@implementation CPResumeEditFirstExpectCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentTableWidth = -1;
        self.selectedFirstRow = -1;
        self.selectedSecondRow = -1;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, 0, self.viewWidth - 40 / CP_GLOBALSCALE - 105 / CP_GLOBALSCALE, 144 / CP_GLOBALSCALE)];
        self.labelTitle.textColor = [UIColor colorWithHexString:@"404040"];
        self.labelTitle.font = [UIFont systemFontOfSize:42 / CP_GLOBALSCALE];
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        self.imageViewArrow = [[UIImageView alloc] init];
        self.imageViewArrow.backgroundColor = [UIColor clearColor];
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_down_gray"];
        [self.contentView addSubview:self.imageViewArrow];
        [self.imageViewArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self.mas_right ).offset( -35 / CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top ).offset( (144 - 70) / 2.0 / CP_GLOBALSCALE );
            make.width.equalTo( @( 70 / CP_GLOBALSCALE ) );
            make.height.equalTo( @( 70 / CP_GLOBALSCALE ) );
        }];
        UIView *separatorLine = [[UIView alloc] init];
        [separatorLine setBackgroundColor:[UIColor colorWithHexString:@"ede3e6"]];
        [self.contentView addSubview:separatorLine];
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left );
            make.top.equalTo( self.mas_top ).offset( ( 144 - 2 ) / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        [self.contentView addSubview:self.secondTabelView];
    }
    return self;
}
+ (instancetype)editFirstExpectCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"editFirestExpectCell";
    CPResumeEditFirstExpectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPResumeEditFirstExpectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.firstChildArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.selectedSecondRow == indexPath.row )
    {
        BaseCode *code = self.firstChildArray[indexPath.row];
        NSMutableArray *firstArray = [BaseCode thirdLevelJobFunctionWithPathCode:code.PathCode];
        CGFloat height = 144 / CP_GLOBALSCALE * ([firstArray count] + 1);
        return height;
    }
    return 144 / CP_GLOBALSCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPResumeEditSecondExpectCell *cell = [CPResumeEditSecondExpectCell editSecondExpectCellWithTableView:tableView];
    [cell setEditSecondExpectCellDelegate:self];
    BaseCode *code = self.firstChildArray[indexPath.row];
    NSMutableArray *secondChildArray = [BaseCode thirdLevelJobFunctionWithPathCode:code.PathCode];
    BOOL isSelected = NO;
    if ( self.selectedSecondRow == indexPath.row )
        isSelected = YES;
    [cell configWithTitle:code.CodeName childArray:secondChildArray isSelected:isSelected selectedRegions:self.selectedChildArrayM];
    if ( -1 != self.contentTableWidth )
        [cell changeContenTableWidth:self.contentTableWidth];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat changeHeight = 0;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( tableView == self.secondTabelView )
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ( indexPath.row != self.selectedSecondRow )
        {
            BaseCode *code = self.firstChildArray[indexPath.row];
            NSMutableArray *secondChildArray = [BaseCode thirdLevelJobFunctionWithPathCode:code.PathCode];
            changeHeight = [secondChildArray count] * 144 / CP_GLOBALSCALE;
            NSInteger tempRow = -1;
            if ( -1 != self.selectedSecondRow )
                tempRow = self.selectedSecondRow;
            self.selectedFirstRow = indexPath.row;
            if ( [self.editFirstExpectCellDelegate respondsToSelector:@selector(editFirstExpectCell:changeHeight:selectedRow:)] )
            {
                [self.editFirstExpectCellDelegate editFirstExpectCell:self changeHeight:changeHeight selectedRow:indexPath.row];
            }
            [self.secondTabelView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedFirstRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            if ( -1 != tempRow )
            {
                [self.secondTabelView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else
        {
            NSInteger tempRow = -1;
            tempRow = self.selectedSecondRow;
            self.selectedFirstRow = -1;
            self.selectedSecondRow = -1;
            if ( [self.editFirstExpectCellDelegate respondsToSelector:@selector(editFirstExpectCell:changeHeight:selectedRow:)] )
            {
                [self.editFirstExpectCellDelegate editFirstExpectCell:self changeHeight:changeHeight selectedRow:self.selectedSecondRow];
            }
            if ( -1 != tempRow )
            {
                [self.secondTabelView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}
- (void)configWithTitle:(NSString *)titleStr firstChildArray:(NSMutableArray *)firstChildArray isSelected:(BOOL)isSelected selectedRegions:(NSMutableArray *)selectedRegions
{
    if ( 0 < [self.selectedChildArrayM count] )
        [self.selectedChildArrayM removeAllObjects];
    [self.selectedChildArrayM addObjectsFromArray:[selectedRegions copy]];
    if ( 0 < [self.firstChildArray count] )
        [self.firstChildArray removeAllObjects];
    if ( 0 < [self.secondChildArray count] )
        [self.secondChildArray removeAllObjects];
    [self.firstChildArray addObjectsFromArray:[firstChildArray copy]];
    self.isSeleceted = isSelected;
    [self.labelTitle setText:titleStr];
    if ( self.isSeleceted )
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_up_gray"];
        [self.secondTabelView setHidden:NO];
        CGFloat tableViewH = 144 / CP_GLOBALSCALE * [self.firstChildArray count];
        if ( self.selectedSecondRow != -1 )
        {
            BaseCode *secodnBaseCode = self.firstChildArray[self.selectedSecondRow];
            NSMutableArray *thirdChildArray = [BaseCode thirdLevelJobFunctionWithPathCode:secodnBaseCode.PathCode];
            tableViewH += 144 / CP_GLOBALSCALE * [thirdChildArray count];
        }
        self.secondTabelView.viewHeight = tableViewH;
        [self.secondTabelView reloadData];
    }
    else
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_down_gray"];
        [self.secondTabelView setHidden:YES];
        self.secondTabelView.viewHeight = 0;
    }
}
- (void)configWithTitle:(NSString *)titleStr firstChildArray:(NSMutableArray *)firstChildArray isSelected:(BOOL)isSelected selectedRegions:(NSMutableArray *)selectedRegions selectedSecondRow:(NSInteger)selectedSecondRow
{
    [self.selectedChildArrayM addObjectsFromArray:[selectedRegions copy]];
    self.selectedSecondRow = -1;
    self.selectedSecondRow = selectedSecondRow;
    [self configWithTitle:titleStr firstChildArray:firstChildArray isSelected:isSelected selectedRegions:selectedRegions];
}
#pragma mark- 在搜索页面要更改第二三级的宽度
- (void)changeContenTableWidth:(CGFloat)tableWidth
{
    self.contentTableWidth = tableWidth;
    self.secondTabelView.viewWidth = self.contentTableWidth;
}
#pragma mark - CPResumeEditSecondExpectCellDelegate
- (void)editSecondExpectCell:(CPResumeEditSecondExpectCell *)editSecondExpectCell selecetdBaseCode:(BaseCode *)selecetdBaseCode isAdd:(BOOL)isAdd
{
    if ( [self.editFirstExpectCellDelegate respondsToSelector:@selector(editFirstExpectCell:selecetdBaseCode:isAdd:)] )
    {
        [self.editFirstExpectCellDelegate editFirstExpectCell:self selecetdBaseCode:selecetdBaseCode isAdd:isAdd];
    }
}
- (NSMutableArray *)firstChildArray
{
    if ( !_firstChildArray )
    {
        _firstChildArray = [NSMutableArray array];
    }
    return _firstChildArray;
}
- (NSMutableArray *)secondChildArray
{
    if ( !_secondChildArray )
    {
        _secondChildArray = [NSMutableArray array];
    }
    return _secondChildArray;
}
- (NSMutableArray *)selectedChildArrayM
{
    if ( !_selectedChildArrayM )
    {
        _selectedChildArrayM = [NSMutableArray array];
    }
    return _selectedChildArrayM;
}
- (UITableView *)secondTabelView
{
    if ( !_secondTabelView )
    {
        _secondTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 144 / CP_GLOBALSCALE, self.viewWidth, 0) style:UITableViewStylePlain];
        _secondTabelView.dataSource = self;
        _secondTabelView.delegate = self;
        [_secondTabelView setBackgroundColor:[UIColor clearColor]];
        [_secondTabelView setHidden:YES];
        [_secondTabelView setScrollEnabled:NO];
        [_secondTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _secondTabelView;
}
@end
