/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926
#define D_yyyy @"yyyy"
#define D_MM @"MM"
#define D_MMdd @"MM-dd"
#define D_yyyyMM @"yyyy-MM"
#define D_HHmm @"HH:mm"
#define D_HHmmss @"HH:mm:ss"
#define D_yyyyMMdd @"yyyy-MM-dd"
#define D_yyyyMMddHHmm @"yyyy-MM-dd HH:mm"
#define D_yyyyMMddHHmmss @"yyyy-MM-dd HH:mm:ss"
#define D_MMddHHmm @"MM-dd HH:mm"
#define D_yyyyMMddHHmmsszzz @"yyyy-MM-dd HH:mm:ss:ZZZ"

#define D_yyyyMdHHmmss @"yyyy/M/d HH:mm:ss"

@interface NSDate (Utilities)

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate; 
- (BOOL) isThisMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger) distanceInDaysToDate:(NSDate *)anotherDate;

//- (NSInteger) yearsAfterDate:(NSDate *)date;
//- (NSInteger) yearsBeforeDate:(NSDate *)date;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

+(NSDateFormatter *)formatterWithString:(NSString *)string;

-(NSString *)stringyyyyFromDate;

-(NSString *)stringMMFromDate;

-(NSString *)stringyyyyMMFromDate;

-(NSString *)stringMMddFromDate;

-(NSString *)stringHHmmFromDate;

-(NSString *)stringHHmmssFromDate;

-(NSString *)stringyyyyMMddFromDate;

-(NSString *)stringyyyyMMddHHmmFromDate;

-(NSString *)stringyyyyMMddHHmmssFromDate;

-(NSString *)stringyyyyMMddHHmmsszzzFromDate;

-(NSString *)stringyyyyMdHHmmssFromDate;

-(NSString *)customStringBeforeCurrentDate;

-(NSString *)customStringAfterCurrentDate;

-(NSString *)customString24Hours;

-(NSInteger)age;

+(NSDate *)dateMMddFromString:(NSString *)string;

+(NSDate *)dateHHmmssFromString:(NSString *)string;

+(NSDate *)dateHHmmFromgString:(NSString *)string;

+(NSDate *)dateyyyyMMddFromString:(NSString *)string;

+(NSDate *)dateyyyyMMddHHmmFromString:(NSString *)string;

+(NSDate *)dateyyyyMMddHHmmssFromString:(NSString *)string;

+(NSDate *)dateyyyyMMddHHmmsszzzFromString:(NSString *)string;

+(NSString *)stringChineseWithWeekday:(NSUInteger)weekday;

-(NSString *)chineseWeekDay;

-(NSString *)chineseShortWeekDay;

-(NSString *)chineseDay;

-(NSString *)chineseWeekAndDay;

-(NSString *)customDateFormatterWithString:(NSString *)format;

+(NSDate *)dateFromDay:(NSDate *)day time:(NSDate *)time;

+(NSString *)stampTime;

+(NSInteger)ageWithBirthday:(NSDate *)birthday;

-(NSString*)cepinDateString;

+(NSString*)cepinDateStringFromString:(NSString*)str;

+(NSString*)cepinYearString:(NSString*)str;

+(NSString*)cepinYearStringFromDate:(NSDate*)date;

+(NSString*)cepinYearMonthFromString:(NSString*)str;
+(NSString*)cepinYearMonthDayFromString:(NSString*)str;
+(NSDate *)cepinyyyyMMddFromString:(NSString *)string;
+(NSDate *)cepinMMddFromString:(NSString *)string;


+(NSString*)cepinYMDFromString:(NSString*)str;

+(NSDate *)cepinyyyyMMddHHmmssFromString:(NSString *)string;


+(NSString *)cepinMMdd:(NSString *)string;
+(NSString *)cepinMMminusdd:(NSString *)string;

+(NSString *)cepinMMddHHddFromString:(NSString *)string;
+(BOOL)dataBeforeCurrentData:(NSString *)data;


//职位时间格式
+(NSString*)cepinJobYearMonthDayFromString:(NSString*)str;


@end
