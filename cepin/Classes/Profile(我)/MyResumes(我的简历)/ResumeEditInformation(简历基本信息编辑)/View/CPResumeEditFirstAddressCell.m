//
//  CPResumeEditFirstAddressCell.m
//  cepin
//
//  Created by ceping on 16/2/23.
//  Copyright © 2016年 talebase. All rights reserved.
//

#import "CPResumeEditFirstAddressCell.h"
#import "CPRsumeEditSecondAddressCell.h"
#import "RegionDTO.h"
#import "CPCommon.h"
@interface CPResumeEditFirstAddressCell ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,retain)UILabel *labelTitle;
@property(nonatomic,retain)UIImageView *imageViewArrow;
@property (nonatomic, strong) NSMutableArray *childArray;
@property (nonatomic, assign) BOOL isSeleceted;
@property (nonatomic, strong) UITableView *secondTabelView;
@property (nonatomic, strong) Region *selectedRegion;
@property (nonatomic, strong) NSMutableArray *selectedChildArrayM;
@property (nonatomic, strong) UIView *separatorLine;
@end
@implementation CPResumeEditFirstAddressCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(40 / CP_GLOBALSCALE, 0, self.viewWidth / 2.0, 144 / CP_GLOBALSCALE)];
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
            make.left.equalTo( self.mas_left ).offset( 40/CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top ).offset( ( 144 - 2 ) / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40/CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
        self.separatorLine = separatorLine;
        [self.contentView addSubview:self.secondTabelView];
    }
    return self;
}
+ (instancetype)editFirstAddressCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"editFirstAddressCell";
    CPResumeEditFirstAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( !cell )
    {
        cell = [[CPResumeEditFirstAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
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
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 0 );
            make.top.equalTo( self.mas_top ).offset( ( 144 - 2 ) / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( 0 );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    else
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_down_gray"];
        [self.secondTabelView setHidden:YES];
        self.secondTabelView.viewHeight = 0;
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40/CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top ).offset( ( 144 - 2 ) / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40/CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
}
- (void)configWithTitle:(NSString *)titleStr childArray:(NSMutableArray *)childArray isSelected:(BOOL)isSelected selectedRegion:(Region *)selectedRegion
{
    self.selectedRegion = selectedRegion;
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
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 0 );
            make.top.equalTo( self.mas_top ).offset( ( 144 - 2 ) / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( 0 );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
    else
    {
        self.imageViewArrow.image = [UIImage imageNamed:@"ic_down_gray"];
        [self.secondTabelView setHidden:YES];
        self.secondTabelView.viewHeight = 0;
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo( self.mas_left ).offset( 40/CP_GLOBALSCALE );
            make.top.equalTo( self.mas_top ).offset( ( 144 - 2 ) / CP_GLOBALSCALE );
            make.right.equalTo( self.mas_right ).offset( -40/CP_GLOBALSCALE );
            make.height.equalTo( @( 2 / CP_GLOBALSCALE ) );
        }];
    }
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
    return 144.0 / CP_GLOBALSCALE;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRsumeEditSecondAddressCell *cell = [CPRsumeEditSecondAddressCell editSecondAddressCellWithTableView:tableView];
    Region *region = self.childArray[indexPath.row];
    BOOL isSelected = NO;
    BOOL isLast = NO;
    if ( [region.PathCode isEqualToString:self.selectedRegion.PathCode] )
        isSelected = YES;
    for ( Region *childRegion in self.selectedChildArrayM )
    {
        if ( [region.PathCode isEqualToString:childRegion.PathCode] )
            isSelected = YES;
    }
    if ( indexPath.row == [self.childArray count] - 1 )
        isLast = YES;
    [cell configWithTitle:region.RegionName isSelected:isSelected];
    [cell setIsLast:isLast];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Region *selectedRegion = self.childArray[indexPath.row];
    BOOL isCanAdd = YES;
    if ( [self.selectedChildArrayM count] >= 3 )
    {
        isCanAdd = NO;
    }
    if ( self.selectedRegion )
    {
        if ( [selectedRegion.PathCode isEqualToString:self.selectedRegion.PathCode] )
        {
            isCanAdd = NO;
        }
        if ( [self.editFirstAddressDelegate respondsToSelector:@selector(resumeEditFirstAddressCell:didSelectedRegion:)] )
        {
            [self.editFirstAddressDelegate resumeEditFirstAddressCell:self didSelectedRegion:selectedRegion];
        }
    }
    else if ( [self.selectedChildArrayM count] > 0 )
    {
        for ( Region *region in self.selectedChildArrayM )
        {
            if ( [selectedRegion.PathCode isEqualToString:region.PathCode] )
            {
                isCanAdd = NO;
                break;
            }
        }
        if ( [self.editFirstAddressDelegate respondsToSelector:@selector(resumeEditFirstAddressCell:didSelectedRegion:isCanAdd:)] )
        {
            [self.editFirstAddressDelegate resumeEditFirstAddressCell:self didSelectedRegion:selectedRegion isCanAdd:isCanAdd];
        }
    }
    else
    {
        if ( [selectedRegion.PathCode isEqualToString:self.selectedRegion.PathCode] )
        {
            isCanAdd = NO;
        }
        if ( [self.editFirstAddressDelegate respondsToSelector:@selector(resumeEditFirstAddressCell:didSelectedRegion:)] )
        {
            [self.editFirstAddressDelegate resumeEditFirstAddressCell:self didSelectedRegion:selectedRegion];
        }
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
