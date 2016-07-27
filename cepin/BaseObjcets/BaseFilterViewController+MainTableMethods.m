//
//  BaseFilterViewController+MainTableMethods.m
//  yanyu
//
//  Created by 唐 嘉宾 on 13-7-30.
//  Copyright (c) 2013年 唐 嘉宾. All rights reserved.
//

#import "BaseFilterViewController+MainTableMethods.h"
#import "RTAPPHelper.h"
//#import "NMRangeSlider.h"
#import "BaseTableObject.h"

@implementation BaseFilterViewController (MainTableMethods)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [[RTAPPHelper shareInstance] cellHeightWithClassName:[[[self.tableObject datas] objectAtIndex:indexPath.row] objectForKey:PlistCellClass]];
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *dic = [self.tableObject.datas objectAtIndex:indexPath.row];
    
//    Class class = NSClassFromString([dic objectForKey:PlistCellToClass]);
//    NSString *tempName = ([dic objectForKey:PlistCellValueName]) ? [dic objectForKey:PlistCellValueName] : [dic objectForKey:PlistCellDefaultName];
//    NSNumber *tempValue = ([dic objectForKey:PlistCellValue]) ? [dic objectForKey:PlistCellValue] : [dic objectForKey:PlistCellDefaultValue];
    
//    NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:tempName,FilterDictionaryName,tempValue,FilterDictionaryValue, nil];
//    
//    BaseFilterViewController *filterVC = [[class alloc] initWithNibName:nil bundle:nil delegate:self index:indexPath.row dictionary:tempDic];
    
//    [self.navigationController pushViewController:filterVC animated:YES];
}


-(void)selectedName:(NSString *)name value:(int64_t)Id index:(NSInteger)index viewController:(BaseFilterViewController *)vc
{
    //取出对应index的字典
//    NSDictionary *dic = (NSDictionary *)[self.tableObject.datas objectAtIndex:index];
    
    //重新生成一个可变字典,并将值放到对应的键中
//    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dic];
//    [temp setObject:name forKey:PlistCellValueName];
//    [temp setObject:[NSNumber numberWithLongLong:Id] forKey:PlistCellValue];
    
    //替换原来的字典值
//    [self.tableObject.datas removeObjectAtIndex:index];
    [self.tableObject.datas insertObject:temp atIndex:index];
    
    //先将数据保存到内存，等用用户按确定时再保存到硬盘中
    //[[RTAPPHelper shareInstance] setFilters:_tableObject.datas];
    [self.tableView reloadData];
}


//-(void)sliderChangeMaxValue:(float)max minValue:(float)min slider:(NMRangeSlider *)slider cell:(FilterTableSliderCell *)cell index:(NSInteger)index
//{
//    NSDictionary *dic = (NSDictionary *)[self.tableObject.datas objectAtIndex:index];
//    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dic];
//    [temp setObject:[NSNumber numberWithFloat:max] forKey:PlistCellMaxValue];
//    [temp setObject:[NSNumber numberWithFloat:min] forKey:PlistCellMinValue];
//    [self.tableObject.datas removeObjectAtIndex:index];
//    [self.tableObject.datas insertObject:temp atIndex:index];
//    
//    //先将数据保存到内存，等用用户按确定时再保存到硬盘中
//    //[[RTAPPHelper shareInstance] setFilters:_tableObject.datas];
//}

@end
