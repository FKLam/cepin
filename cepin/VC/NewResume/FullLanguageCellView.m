//
//  FullLanguageCellView.m
//  cepin
//
//  Created by dujincai on 15-4-20.
//  Copyright (c) 2015年 talebase. All rights reserved.
//

#import "FullLanguageCellView.h"
#import "LanguageCell.h"
#import "MajorCell.h"
#import "CertificateCell.h"
#import "CPCETAndOtherCell.h"
#import "NSDate-Utilities.h"
#import "NSString+Extension.h"

@interface FullLanguageCellView()

@property (nonatomic, copy) NSDictionary *CETDict;

@property (nonatomic, copy) NSArray *CETNameArray;

@end

@implementation FullLanguageCellView

- (NSArray *)CETNameArray
{
    if ( !_CETNameArray )
    {
        if ( !_CETDict)
            return nil;
        
        NSMutableArray *nameM = [NSMutableArray array];
        for (NSString *name in [_CETDict allKeys])
        {
            [nameM addObject:name];
        }
        
        if ( nameM.count > 0 )
            _CETNameArray = [nameM copy];
        
    }
    return _CETNameArray;
}

- (instancetype)initWithFrame:(CGRect)frame model:(ResumeNameModel *)model CETDict:(NSDictionary *)dict;
{
    self = [super initWithFrame:frame];
    if (self) {
        _CETDict = dict;
        self.languageModel = model;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.scrollsToTop = NO;
        [self addSubview:self.tableView];
        
        CGFloat lineHeight = 0;
        
        for ( NSDictionary *dict in self.languageModel.CredentialList )
        {
            if ( [dict isEqualToDictionary:[self.languageModel.CredentialList lastObject]] )
            {
                if ( self.languageModel.SkillList.count == 0 && self.CETDict.count == 0 && self.languageModel.LanguageList.count == 0 )
                    break;
            }
            
            CredentialListDataModel *gredentialModel = [CredentialListDataModel beanFromDictionary:dict];
            
            lineHeight += [self caculateCredentialHeight:gredentialModel];
        }
        
        for ( NSDictionary *dict in self.languageModel.SkillList )
        {
            if ( [dict isEqualToDictionary:[self.languageModel.SkillList lastObject]] )
            {
                if ( self.CETDict.count == 0 && self.languageModel.LanguageList.count == 0)
                {
                    break;
                }
            }
            
            SkillDataModel *skillModel = [SkillDataModel beanFromDictionary:dict];
            
            lineHeight += [self caculateSkill:skillModel];
        }
        
        for ( NSString *str in self.CETNameArray )
        {
            if ( [str isEqualToString:[self.CETNameArray lastObject]] )
            {
                if ( self.languageModel.LanguageList.count == 0 )
                    break;
            }
            
            NSString *name = str;
            NSNumber *score = self.CETDict[name];
            
            lineHeight += [self caculateEnglish:name score:score];
        }
        
        for ( NSDictionary *dict in self.languageModel.LanguageList )
        {
            if ( [dict isEqualToDictionary:[self.languageModel.LanguageList lastObject]] )
            {
                break;
            }
            
            LanguageDataModel *otherModel = [LanguageDataModel beanFromDictionary:dict];
            lineHeight += [self caculateOtherLanguage:otherModel];
        }
        
        CGFloat lineY = 40 / 3.0 - (21.0 - [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont].pointSize) / 2.0 + 21.0 / 2.0;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake( 40 / 3.0 + 21 / 2.0 - 1 / 2.0, lineY, 1, lineHeight)];
        
        line.backgroundColor = [[RTAPPUIHelper shareInstance]lineColor];
        [self insertSubview:line belowSubview:self.tableView];
    }
    return self;
}

//时间
- (NSString *)managestrTime:(NSString *)time
{
    if (!time || [time isEqualToString:@""]) {
        return @"至今";
    }else{
        //    NSArray *array = [time componentsSeparatedByString:@" "];
        return [NSDate cepinYMDFromString:time];
    }
}

// 计算专业证书的高度
- (CGFloat)caculateCredentialHeight:(CredentialListDataModel *)model
{
    if ( !model )
        return 0;
    
    NSString *time = [self managestrTime:model.Date];
    
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  专业证书";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    NSMutableString *strM = [[NSMutableString alloc] initWithString:[timeAttStr string]];
    if ( model.Name && model.Name.length > 0 )
        [strM appendFormat:@"\n%@", model.Name];
    
    CGFloat tempH = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:[strM copy] andWith:kScreenWidth - 40 - 40 / 3.0].height;
    
    return tempH + 5.0 + 40 / 3.0 * 2;
}

// 计算专业技能的高度
- (CGFloat)caculateSkill:(SkillDataModel *)model
{
    if ( !model )
        return 0;
    
    SkillDataModel *skillModel = model;
    
    NSString *time = [NSString stringWithFormat:@"%@  |  %@", skillModel.Name, skillModel.MasteryLevel];
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  专业技能";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    CGFloat tempH = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:[timeAttStr string] andWith:kScreenWidth - 40 - 40 / 3.0].height;
    
    return tempH + 5.0 + 40 / 3.0 * 2;
}

// 计算英语等级的高度
- (CGFloat)caculateEnglish:(NSString *)name score:(NSNumber *)score
{
    NSString *time = nil;
    
    if ( [score.stringValue rangeOfString:@"."].length > 0 )
        time = [NSString stringWithFormat:@"%@（%.1lf分）", name, score.floatValue];
    else
        time = [NSString stringWithFormat:@"%@（%ld分）", name, (long)score.integerValue];
    
    NSMutableAttributedString *timeAttStr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *app = @"  |  英语等级";
    NSAttributedString *appAttStr = [[NSAttributedString alloc] initWithString:app attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [timeAttStr appendAttributedString:appAttStr];
    
    CGFloat tempH = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:[timeAttStr string] andWith:kScreenWidth - 40 - 40 / 3.0].height;
    
    return tempH + 5.0 + 40 / 3.0 * 2;
}

// 计算其它语言的高度
- (CGFloat)caculateOtherLanguage:(LanguageDataModel *)model
{
    LanguageDataModel *lanModel = model;
    
    NSMutableString *lanMutStr = [NSMutableString stringWithString:lanModel.Name];
    NSString *tempStr = nil;
    if ( lanModel.Speaking.length > 0 && lanModel.Writing.length > 0)
    {
        tempStr = [NSString stringWithFormat:@"（听说%@、读写%@）", lanModel.Speaking, lanModel.Writing];
    }
    else if ( lanModel.Speaking.length > 0 )
    {
        tempStr = [NSString stringWithFormat:@"（听说%@）", lanModel.Speaking];
    }
    else if ( lanModel.Writing.length > 0 )
    {
        tempStr = [NSString stringWithFormat:@"（读写%@）", lanModel.Writing];
    }
    
    if ( tempStr )
        [lanMutStr appendString:tempStr];
    
    NSMutableAttributedString *nameAttStr = [[NSMutableAttributedString alloc] initWithString:lanMutStr attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] mainTitleColor]}];
    NSString *append = @"  |  其它语言能力";
    NSAttributedString *appendAttStr = [[NSAttributedString alloc] initWithString:append attributes:@{ NSFontAttributeName : [[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont], NSForegroundColorAttributeName : [[RTAPPUIHelper shareInstance] subTitleColor]}];
    [nameAttStr appendAttributedString:appendAttStr];
    
    CGFloat tempH = [NSString caculateTextSize:[[RTAPPUIHelper shareInstance] companyInformationIntroduceTitleFont] text:[nameAttStr string] andWith:kScreenWidth - 40 - 40 / 3.0].height;
    
    return tempH + 5.0 + 40 / 3.0 * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 专业证书
    if (self.languageModel.CredentialList.count > 0 && indexPath.row < self.languageModel.CredentialList.count) {
        
        CredentialListDataModel *model = [CredentialListDataModel beanFromDictionary:self.languageModel.CredentialList[indexPath.row]];
        return [self caculateCredentialHeight:model];
    }
    
    NSInteger index = (int)indexPath.row;
    
    // 专业技能
    if (self.languageModel.CredentialList.count > 0) {
        index = indexPath.row - self.languageModel.CredentialList.count;
    }
    if ( self.languageModel.SkillList.count > 0 && index < self.languageModel.SkillList.count )
    {
        SkillDataModel *model = [SkillDataModel beanFromDictionary:self.languageModel.SkillList[index]];
        return [self caculateSkill:model];
    }
    
    // 英语等级
    if ( self.CETDict.count > 0 )
    {
        index = indexPath.row - self.languageModel.CredentialList.count - self.languageModel.SkillList.count;
    }
    
    if ( self.CETDict.count > 0 && index < self.CETDict.count )
    {
        NSString *name = self.CETNameArray[index];
        NSNumber *score = self.CETDict[name];
        
        return [self caculateEnglish:name score:score];
    }
    
    // 其它语言
    if ( self.languageModel.LanguageList.count > 0 )
    {
        index = indexPath.row - self.languageModel.CredentialList.count - self.languageModel.SkillList.count - self.CETDict.count;
    }
    
    if (self.languageModel.LanguageList.count > 0 && index < self.languageModel.LanguageList.count) {
        LanguageDataModel *model = [LanguageDataModel beanFromDictionary:self.languageModel.LanguageList[index]];
        
        return [self caculateOtherLanguage:model];
    }
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGFloat counts = self.languageModel.SkillList.count + self.languageModel.CredentialList.count + self.languageModel.LanguageList.count + self.CETDict.count;
    return counts;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat counts = self.languageModel.SkillList.count + self.languageModel.CredentialList.count + self.languageModel.LanguageList.count + self.CETDict.count;
    
    // 专业证书
    if (self.languageModel.CredentialList.count > 0 && indexPath.row < self.languageModel.CredentialList.count) {
        CertificateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CertificateCell class])];
        if (cell == nil) {
            cell = [[CertificateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CertificateCell class])];
        }
        CredentialListDataModel *model = [CredentialListDataModel beanFromDictionary:self.languageModel.CredentialList[indexPath.row]];
        [cell getModel:model];
        
        if ( indexPath.row == counts - 1 )
            cell.baseSeparatorView.hidden = YES;
        else
            cell.baseSeparatorView.hidden = NO;
        
        return cell;
    }
    
    NSInteger index = (int)indexPath.row;
    
    // 专业技能
    if (self.languageModel.CredentialList.count > 0) {
        index = indexPath.row - self.languageModel.CredentialList.count;
    }
    if ( self.languageModel.SkillList.count > 0 && index < self.languageModel.SkillList.count )
    {
        MajorCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MajorCell class])];
        if (cell == nil) {
            cell = [[MajorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MajorCell class])];
        }
        SkillDataModel *model = [SkillDataModel beanFromDictionary:self.languageModel.SkillList[index]];
        [cell getModel:model];
        if ( indexPath.row == counts - 1 )
            cell.baseSeparatorView.hidden = YES;
        else
            cell.baseSeparatorView.hidden = NO;
        return cell;
    }
    
    // 英语等级
    if ( self.CETDict.count > 0 )
    {
        index = indexPath.row - self.languageModel.CredentialList.count - self.languageModel.SkillList.count;
    }
    
    if ( self.CETDict.count > 0 && index < self.CETDict.count )
    {
        CPCETAndOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CPCETAndOtherCell"];
        if ( !cell)
        {
            cell = [[CPCETAndOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPCETAndOtherCell"];
        }
        NSString *name = self.CETNameArray[index];
        NSNumber *score = self.CETDict[name];
        [cell addCETName:name score:score];
        if ( indexPath.row == counts - 1 )
            cell.baseSeparatorView.hidden = YES;
        else
            cell.baseSeparatorView.hidden = NO;
        return cell;
    }
    
    // 其它语言
    if ( self.languageModel.LanguageList.count > 0 )
    {
        index = indexPath.row - self.languageModel.CredentialList.count - self.languageModel.SkillList.count - self.CETDict.count;
    }
    
    if (self.languageModel.LanguageList.count > 0 && index < self.languageModel.LanguageList.count) {
        LanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LanguageCell class])];
        if (cell == nil) {
            cell = [[LanguageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LanguageCell class])];
        }
        LanguageDataModel *model = [LanguageDataModel beanFromDictionary:self.languageModel.LanguageList[index]];
        [cell getModel:model];
        if ( indexPath.row == counts - 1 )
            cell.baseSeparatorView.hidden = YES;
        else
            cell.baseSeparatorView.hidden = NO;
        return cell;
    }
    

    return nil;
}

@end
