//
//  CPResumeEditSecondExpectCell.m
//  cepin
//
//  Created by ceping on 16/2/24.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEditSecondExpectCell.h"
#import "CPResumeEditThirdExpectCell.h"
#import "CPCommon.h"
@interface CPResumeEditSecondExpectCell ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,retain)UILabel *labelTitle;
@property(nonatomic,retain)UIImageView *imageViewArrow;
@property (nonatomic, strong) NSMutableArray *childArray;
@property (nonatomic, assign) BOOL isSeleceted;
@property (nonatomic, strong) UITableView *secondTabelView;
@property (nonatomic, strong) NSMutableArray *selectedChildArrayM;
@property (nonatomic, assign) CGFloat contentTableViewWidth;
@property(nonatomic,assign)BOOL isSingleSelectModel;//是否单选模式

@end
@implementation CPResumeEditSecondExpectCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentTableViewWidth = -1;
        [self setBackgroundColor:[UIColor colorWithHexString:@"efeff4"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(80 / CP_GLOBALSCALE, 0, self.viewWidth - 80 / CP_GLOBALSCALE - 105 / CP_GLOBALSCALE, 144 / CP_GLOBALSCALE)];
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
+ (instancetype)editSecondExpectCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"editSecondAddressCell";
    CPResumeEditSecondExpectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPResumeEditSecondExpectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
- (void)configWithTitle:(NSString *)titleStr childArray:(NSMutableArray *)childArray isSelected:(BOOL)isSelected selectedRegions:(NSMutableArray *)selectedRegions
{
    if ( 0 < [self.selectedChildArrayM count] )
        [self.selectedChildArrayM removeAllObjects];
    [self.selectedChildArrayM addObjectsFromArray:[selectedRegions copy]];
    if ( 0 < [self.childArray count] )
    {
        [self.childArray removeAllObjects];
    }
    [self.childArray addObjectsFromArray:[childArray copy]];
    _isSeleceted = isSelected;
    [self.labelTitle setText:titleStr];
    if ( _isSeleceted )
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_up_gray"];
        [self.secondTabelView setHidden:NO];
        self.secondTabelView.viewHeight = 144 / CP_GLOBALSCALE * [self.childArray count];
        [self.secondTabelView reloadData];
    }
    else
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_down_gray"];
        [self.secondTabelView setHidden:YES];
        self.secondTabelView.viewHeight = 0;
    }
}
- (void)configWithTitle:(NSString *)titleStr childArray:(NSMutableArray *)childArray isSelected:(BOOL)isSelected selectedRegion:(BaseCode *)selectedRegion
{
    if ( 0 < [self.childArray count] )
    {
        [self.childArray removeAllObjects];
    }
    [self.childArray addObjectsFromArray:[childArray copy]];
    self.isSeleceted = isSelected;
    [self.labelTitle setText:titleStr];
    if ( self.isSeleceted )
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_up_gray"];
        [self.secondTabelView setHidden:NO];
        self.secondTabelView.viewHeight = 144 / CP_GLOBALSCALE * [self.childArray count];
        [self.secondTabelView reloadData];
    }
    else
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_down_gray"];
        [self.secondTabelView setHidden:YES];
        self.secondTabelView.viewHeight = 0;
    }
}
//搜索页面的职能筛选
- (void)changeContenTableWidth:(CGFloat)tableWidth
{
    self.isSingleSelectModel = YES;
    self.contentTableViewWidth = tableWidth;
    self.secondTabelView.viewWidth = self.contentTableViewWidth;
}
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.childArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144 / CP_GLOBALSCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPResumeEditThirdExpectCell *cell = [CPResumeEditThirdExpectCell editThirdExpectCellWithTableView:tableView];
    BaseCode *code = self.childArray[indexPath.row];
    BOOL isSelected = NO;
    for ( BaseCode *BC in self.selectedChildArrayM )
    {
        if ( [BC.CodeKey isEqualToValue:code.CodeKey] )
        {
            isSelected = YES;
            break;
        }
    }
    [cell configWithTitle:code.CodeName isSelected:isSelected];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCode *selectedRegion = self.childArray[indexPath.row];
    if ( [self.editSecondExpectCellDelegate respondsToSelector:@selector(editSecondExpectCell:selecetdBaseCode:isAdd:)] )
    {
        BOOL isAdd = YES;
        for ( BaseCode *code in self.selectedChildArrayM )
        {
            if ( [selectedRegion.CodeKey isEqualToValue:code.CodeKey] )
            {
                isAdd = NO;
                break;
            }
        }
        //判断是否单选模式
        if(self.isSingleSelectModel){
            if([self.selectedChildArrayM count]>0){
                [self.selectedChildArrayM  removeAllObjects];
                [tableView reloadData];
                if(!isAdd){
                    return;
                }
            }
        }
        [self.editSecondExpectCellDelegate editSecondExpectCell:self selecetdBaseCode:selectedRegion isAdd:isAdd];
    }
}
- (UITableView *)secondTabelView
{
    if ( !_secondTabelView )
    {
        _secondTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 144 / CP_GLOBALSCALE, kScreenWidth, 0) style:UITableViewStylePlain];
        _secondTabelView.dataSource = self;
        _secondTabelView.delegate = self;
        [_secondTabelView setBackgroundColor:[UIColor clearColor]];
        [_secondTabelView setHidden:YES];
        [_secondTabelView setScrollEnabled:NO];
        [_secondTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _secondTabelView;
}
- (NSMutableArray *)childArray
{
    if ( !_childArray )
    {
        _childArray = [NSMutableArray array];
    }
    return _childArray;
}
- (NSMutableArray *)selectedChildArrayM
{
    if ( !_selectedChildArrayM )
    {
        _selectedChildArrayM = [NSMutableArray array];
    }
    return _selectedChildArrayM;
}
@end