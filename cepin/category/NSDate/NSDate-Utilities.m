/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

/*
 #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
 ----
 General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej, Blagovest Dachev, Matthias Plappert,  Slava Bushtruk, Ali Servet Donmez, Ricardo1980, pip8786, Danny Thuerin, Dennis Madsen
*/

#import "NSDate-Utilities.h"
#import "NSString+Convert.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (Utilities)

#pragma mark Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
	return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
	return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) && 
			(components1.day == components2.day));
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (components1.week != components2.week) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (abs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
	return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark Adjusting Dates

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;			
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	components.hour = 0;
	components.minute = 0;
	components.second = 0;
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark Decomposing Dates

- (NSInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

- (NSInteger) hour
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.hour;
}

- (NSInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.minute;
}

- (NSInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.second;
}

- (NSInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.day;
}

- (NSInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.month;
}

- (NSInteger) week
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.week;
}

- (NSInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekdayOrdinal;
}

- (NSInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.year;
}


+(NSDateFormatter *)formatterWithString:(NSString *)string
{
    static NSDateFormatter *shareFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    shareFormatter = [NSDateFormatter new];
    });
    
    shareFormatter.dateFormat = string;
    return shareFormatter;
}

-(NSString *)stringyyyyMMFromDate
{
    return [[NSDate formatterWithString:D_yyyyMM] stringFromDate:self];
}

-(NSString *)stringyyyyFromDate
{
    return [[NSDate formatterWithString:D_yyyy] stringFromDate:self];
}

-(NSString *)stringMMFromDate
{
    return [[NSDate formatterWithString:D_MM] stringFromDate:self];
}

-(NSString *)stringMMddFromDate
{
    return [[NSDate formatterWithString:D_MMdd] stringFromDate:self];
}

-(NSString *)stringHHmmFromDate
{
    return [[NSDate formatterWithString:D_HHmm] stringFromDate:self];
}

-(NSString *)stringHHmmssFromDate
{
    return [[NSDate formatterWithString:D_HHmmss] stringFromDate:self];
}

-(NSString *)stringyyyyMMddFromDate
{
    return [[NSDate formatterWithString:D_yyyyMMdd] stringFromDate:self];
}

-(NSString *)stringyyyyMMddHHmmFromDate
{
    return [[NSDate formatterWithString:D_yyyyMMddHHmm] stringFromDate:self];
}

-(NSString *)stringMMddHHmmFromDate
{
    return [[NSDate formatterWithString:D_MMddHHmm] stringFromDate:self];
}

-(NSString *)stringyyyyMMddHHmmssFromDate
{
    return [[NSDate formatterWithString:D_yyyyMMddHHmmss] stringFromDate:self];
}

-(NSString *)stringyyyyMMddHHmmsszzzFromDate
{
    return [[NSDate formatterWithString:D_yyyyMMddHHmmsszzz] stringFromDate:self];
}

-(NSString *)stringyyyyMdHHmmssFromDate
{
    return [[NSDate formatterWithString:D_yyyyMdHHmmss] stringFromDate:self];
}

+(NSDate *)dateMMddFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_MMdd] dateFromString:string];
}

+(NSDate *)dateHHmmFromgString:(NSString *)string
{
    return [[NSDate formatterWithString:D_HHmm] dateFromString:string];
}

+(NSDate *)dateHHmmssFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_HHmmss] dateFromString:string];
}

+(NSDate *)dateyyyyMMddFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_yyyyMMdd] dateFromString:string];
}

+(NSDate *)dateyyyyMMddHHmmFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_yyyyMMddHHmm] dateFromString:string];
}

+(NSDate *)dateyyyyMMddHHmmssFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_yyyyMMddHHmmss] dateFromString:string];
}


+(NSDate *)dateyyyyMdHHmmssFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_yyyyMdHHmmss] dateFromString:string];
}


+(NSDate *)dateyyyyMMddHHmmsszzzFromString:(NSString *)string
{
    NSDate *date = [[NSDate formatterWithString:D_yyyyMMddHHmmsszzz] dateFromString:string];
    NSString *str = [date stringyyyyMMddHHmmssFromDate];
    return [[NSDate formatterWithString:D_yyyyMMddHHmmss] dateFromString:str];
}


+(NSString *)stringChineseWithWeekday:(NSUInteger)weekday
{
    NSString *temp = nil;
    switch (weekday) {
        case 2:
            temp = @"星期一";
            break;
        case 3:
            temp = @"星期二";
            break;
        case 4:
            temp = @"星期三";
            break;
        case 5:
            temp = @"星期四";
            break;
        case 6:
            temp = @"星期五";
            break;
        case 7:
            temp = @"星期六";
            break;
        /*case 7:
            
            break;
         **/
        
        default:
            temp = @"星期日";
            break;
    }
    return temp;
}

-(NSString *)chineseWeekDay
{
    return [NSDate stringChineseWithWeekday:self.weekday];
}

-(NSString *)chineseShortWeekDay
{
    NSString *temp = nil;
    
    switch (self.weekday) {
        case 2:
            temp = @"周一";
            break;
        case 3:
            temp = @"周二";
            break;
        case 4:
            temp = @"周三";
            break;
        case 5:
            temp = @"周四";
            break;
        case 6:
            temp = @"周五";
            break;
        case 7:
            temp = @"周六";
            break;
            /*case 7:
             
             break;
             **/
            
        default:
            temp = @"周日";
            break;
    }
    return temp;
}


-(NSString *)customStringBeforeCurrentDate
{
    NSDate *currentDate = [NSDate date];
    NSString *str = nil;
    if ([self isToday]) {
        NSInteger minutes = [self minutesBeforeDate:currentDate];
        if (minutes < D_HOUR/60) {
            //只显示分钟
            str = [NSString stringWithFormat:@"%lu分钟",(long)minutes];
        }
        else if (minutes < D_DAY/60){
            //只显示小时和分钟
//            str = [self stringHHmmFromDate];
            NSInteger hours = floorl(minutes/60);
            minutes = minutes - hours*60;
            str = [NSString stringWithFormat:@"%lu%@%lu%@",(long)hours,NSLocalizedString(@"小时", nil),(long)minutes,NSLocalizedString(@"分钟", nil)];
        }
    }
    else{
//        str = [self stringyyyyMMddHHmmFromDate];
        NSInteger minutes = [self minutesBeforeDate:currentDate];
        NSInteger hours = floorl(minutes/60);
        minutes = minutes - hours*60;
        str = [NSString stringWithFormat:@"%lu%@%lu%@",(long)hours,NSLocalizedString(@"小时", nil),(long)minutes,NSLocalizedString(@"分钟", nil)];
    }
    return str;
}


-(NSString *)customStringAfterCurrentDate
{
    NSDate *currentDate = [NSDate date];
    NSString *str = nil;
    
    if ([self isToday]) {
        NSInteger minutes = [self minutesAfterDate:currentDate];
        if (minutes < D_HOUR) {
            str = [NSString stringWithFormat:@"%lu%@",(long)minutes,NSLocalizedString(@"分钟", nil)];
        }else if(minutes < D_DAY){
            NSInteger hours = floorl(minutes/60);
            minutes = minutes - hours*60;
            str = [NSString stringWithFormat:@"%lu%@%lu%@",(long)hours,NSLocalizedString(@"小时", nil),(long)minutes,NSLocalizedString(@"分钟", nil)];
        }
    }else{
        str = [self stringyyyyMMddHHmmFromDate];
    }
    
    return str;
}

-(NSString *)customString24Hours
{
    NSDate *currentDate = [NSDate date];
    NSString *str = nil;
    NSInteger minutes = [self minutesAfterDate:currentDate];
    if (ABS(minutes) < D_HOUR/60) {
        str = [NSString stringWithFormat:@"%lu%@",(long)minutes,NSLocalizedString(@"分钟", nil)];
    }else if(minutes >= D_HOUR/60){
        NSInteger hours = floorl(minutes/60);
        minutes = minutes - hours*60;
        str = [NSString stringWithFormat:@"%lu%@%lu%@",(long)hours,NSLocalizedString(@"小时", nil),(long)minutes,NSLocalizedString(@"分钟", nil)];
    }else{
        str = [self stringyyyyMMddHHmmFromDate];
    }
    
    return str;
}

-(NSString *)chineseDay
{
    NSString *temp = [self stringMMddFromDate];
    temp = [temp replaceString:@"-" toArray:@[@"月",@"日"]];
    return temp;
}

-(NSString *)chineseWeekAndDay
{
//    NSString *temp = [NSString stringWithFormat:@"%@",[self chineseWeekAndDay]];
    static NSString *temp = @"MM月dd日";
    return [[NSDate formatterWithString:temp] stringFromDate:self];
}



-(NSString *)customDateFormatterWithString:(NSString *)format
{
    return [[NSDate formatterWithString:format] stringFromDate:self];
}

-(NSInteger)age
{
    NSTimeInterval dateDiff = [self timeIntervalSinceNow];
    
    NSInteger age =trunc(dateDiff/(60*60*24))/365;
    
    return ABS(age);
}

+(NSDate *)dateFromDay:(NSDate *)day time:(NSDate *)time
{
    NSString *dayStr = [day stringyyyyMMddFromDate];
    NSString *timeStr = [time stringHHmmFromDate];
    NSString *temp = [NSString stringWithFormat:@"%@ %@",dayStr,timeStr];
    return [NSDate dateyyyyMMddHHmmFromString:temp];
}


+(NSString *)stampTime
{
    NSDate *date = [NSDate date];
    NSString *temp = [[NSDate formatterWithString:@"yyyyMMddHHmmss"] stringFromDate:date];
    return temp;
}


+(NSInteger)ageWithBirthday:(NSDate *)birthday
{
    NSTimeInterval dateDiff = [birthday timeIntervalSinceNow];
    
    NSInteger age =trunc(dateDiff/(60*60*24))/365;
    
    return age;
}

-(NSString*)cepinDateString
{
    //NSString *strDate = [self stringyyyyMMddHHmmssFromDate];
    //NSDate   *tmDate = [NSDate dateyyyyMMddHHmmFromString:strDate];
    
    if ([self isToday])
    {
        return [self stringHHmmFromDate];
    }
    else if([self isThisWeek])
    {
        return [self chineseShortWeekDay];
    }
    else if([self isThisWeek])
    {
        //几天前
        int days = (int)[self daysBeforeDate:[NSDate date]];
        return [NSString stringWithFormat:@"%d天前",days];
    }
    else
    {
        //几月几日
//        return [self chineseWeekAndDay];
        return [self chineseDay];
    }
    
    return nil;
}

+(NSString*)cepinDateStringFromString:(NSString*)str
{
    NSDate *date = [NSDate dateyyyyMMddHHmmssFromString:str];
    return [date cepinDateString];
}

+(NSString*)cepinYearString:(NSString*)str
{
    NSArray *array = [str componentsSeparatedByString:@"/"];
    return array[0];
}

+(NSString*)cepinYearStringFromDate:(NSDate*)date;
{
    NSString *temp = [[NSDate formatterWithString:@"yyyy"] stringFromDate:date];
    return temp;
}

+(NSString*)cepinYearMonthFromString:(NSString*)str
{
    NSDate *date = [NSDate dateyyyyMdHHmmssFromString:str];
    
    NSString* tmStr = [date stringyyyyMMFromDate];
    
    NSArray *array = [tmStr componentsSeparatedByString:@"-"];
    NSString *month = [array objectAtIndex:1];
    return [NSString stringWithFormat:@"%@.%d",[array objectAtIndex:0],month.intValue];
}

+(NSString*)cepinYearMonthDayFromString:(NSString*)str
{
    if (!str || [str isEqualToString:@""]) {
        return @"";
    }
    NSDate *date = [NSDate cepinyyyyMMddFromString:str];
    if(nil == date){
        date = [NSDate cepinyyyyMMddHHmmssFromString:str];
    }
    if(nil == date){
        return @"";
    }
    NSString* tmStr = [date stringyyyyMMddFromDate];
    NSArray *array = [tmStr componentsSeparatedByString:@"-"];
    NSString *month = [array objectAtIndex:1];
    NSString *day = [array objectAtIndex:2];
    return [NSString stringWithFormat:@"%@.%d.%d",[array objectAtIndex:0],month.intValue,day.intValue];
}

+(NSDate *)cepinyyyyMMddFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_yyyyMMdd] dateFromString:string];
}

+(NSDate *)cepinMMddFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_MMdd] dateFromString:string];
}

+(NSDate *)cepinyyyyMMddHHmmssFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_yyyyMMddHHmmss] dateFromString:string];
}


+(NSDate *)cepinyyyyMMddHHmmFromString:(NSString *)string
{
    return [[NSDate formatterWithString:D_yyyyMMddHHmm] dateFromString:string];
}



+(NSString*)cepinJobYearMonthDayFromString:(NSString*)str
{
    if (!str || [str isEqualToString:@""]) {
        return @"";
    }
    NSDate *date = [NSDate cepinyyyyMMddHHmmssFromString:str];
    if(nil==date){
        date = [NSDate cepinyyyyMMddFromString:str];
    }
    if(nil==date){
         return @"";
    }
#pragma mark - 修改返回时间格式
    NSString* tmStr = [date stringMMddFromDate];
//    NSString *tmStr = [date stringyyyyMMddFromDate];
    
//    NSArray *array = [tmStr componentsSeparatedByString:@"-"];
//    NSString *month = [array objectAtIndex:1];
//    NSString *day = [array objectAtIndex:2];
//    return [NSString stringWithFormat:@"%@.%d.%d",[array objectAtIndex:0],month.intValue,day.intValue];
    return tmStr;
}

+(NSString*)cepinYMDFromString:(NSString*)str
{
    if ( [str isKindOfClass:[NSNull class]] )
        return @"";
    if (!str || [str isEqualToString:@""]) {
        return @"";
    }
    NSDate *date = [NSDate cepinyyyyMMddFromString:str];
    if(nil == date){
        date = [NSDate cepinyyyyMMddHHmmssFromString:str];
    }
    if(nil==date){
        return nil;
    }
    NSString* tmStr = [date stringyyyyMMddFromDate];
    NSArray *array = [tmStr componentsSeparatedByString:@"-"];
    NSString *month = [array objectAtIndex:1];
    return [NSString stringWithFormat:@"%@.%d",[array objectAtIndex:0],month.intValue];
}

+(NSString*)cepinMMdd:(NSString*)str
{
    if ( [str isKindOfClass:[NSNull class]] )
        return @"";
    if (!str || [str isEqualToString:@""]) {
        return @"";
    }
    NSDate *date = [NSDate cepinyyyyMMddFromString:str];
    if(nil == date){
        date = [NSDate cepinyyyyMMddHHmmssFromString:str];
        if(nil == date){
            date = [NSDate cepinyyyyMMddHHmmFromString:str];
        }
    }
    if(nil==date){
        return nil;
    }
    NSString* tmStr = [date stringMMddFromDate];
    NSArray *array = [tmStr componentsSeparatedByString:@"-"];
    NSString *month = [array objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%d月%@日",month.intValue,[array objectAtIndex:1]];
}

+(NSString*)cepinMMminusdd:(NSString*)str
{
    if ( [str isKindOfClass:[NSNull class]] )
        return @"";
    if (!str || [str isEqualToString:@""]) {
        return @"";
    }
    NSDate *date = [NSDate cepinyyyyMMddFromString:str];
    if(nil == date){
        date = [NSDate cepinyyyyMMddHHmmssFromString:str];
        if(nil == date){
            date = [NSDate cepinyyyyMMddHHmmFromString:str];
        }
    }
    
    if(nil==date){
        return nil;
    }
    NSString* tmStr = [date stringMMddFromDate];
    NSArray *array = [tmStr componentsSeparatedByString:@"-"];
    NSString *month = [array objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%d-%@",month.intValue,[array objectAtIndex:1]];
}

+(NSString *)cepinMMddHHddFromString:(NSString *)string{

    if ( [string isKindOfClass:[NSNull class]] )
        return @"";
    if (!string || [string isEqualToString:@""]) {
        return @"";
    }
   
    NSDate *date = [NSDate cepinyyyyMMddHHmmssFromString:string];
    
    if(nil==date){
        return nil;
    }
    
     NSString* tmStr = [date stringMMddHHmmFromDate];
    
    return tmStr;

}


+(BOOL)dataBeforeCurrentData:(NSString *)string{
    if ( [string isKindOfClass:[NSNull class]] )
        return @"";
    if (!string || [string isEqualToString:@""]) {
        return @"";
    }
    NSDate *date = nil;
    date = [NSDate cepinyyyyMMddFromString:string];
    if(nil==date){
        date = [NSDate cepinyyyyMMddHHmmssFromString:string];
        if(nil==date){
            date = [NSDate cepinyyyyMMddHHmmFromString:string];
            if(nil==date){
                return NO;
            }
            
        }
       
    }
   NSDate *laterDate =  [date laterDate:[NSDate date]];
    if(laterDate==date){
        return NO;
    }
    return YES;
}

@end
