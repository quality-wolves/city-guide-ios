/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "NSDateAdditions.h"

@implementation NSDate(FormatExtensions)

+(NSDate*) dateFromString:(NSString*)string withFormat:(NSString*)format
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
	[dateFormatter setDateFormat:format];	
    NSDate *dateFromString = [dateFormatter dateFromString:string];
	
	return dateFromString;
}

-(NSString*) stringValueWithFormat:(NSString*)format
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
	[dateFormatter setDateFormat:format];
	NSString* result = [dateFormatter stringFromDate:self];
	
	return result;
}

-(NSString*) stringValueWithStyle:(NSDateFormatterStyle)style
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
	[dateFormatter setDateStyle:style];
	NSString* result = [dateFormatter stringFromDate:self];
	
	return result;
}

-(NSDateComponents*) components
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:[self dateWithoutTimeComponent]];
	
	
	return  components;
}

-(NSInteger) weekDay
{		
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate* today = self;
			
	NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit | NSWeekCalendarUnit fromDate:today];		
	NSInteger weekDay = [comps weekday];
	
	
	return weekDay;
}

-(NSDate*) dateWithoutTimeComponent
{
	// Deleting time component from NSDate object.
		
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
											   fromDate:self];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	[components setTimeZone:[NSTimeZone systemTimeZone]];
	
	NSDate* result = [calendar dateFromComponents:components];	
			
	return result;	
}

+(NSDate*) dateWithoutTimeComponent
{
	return [[NSDate date] dateWithoutTimeComponent];
}

-(NSDate*) dayEndTime
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];	
	[comps setHour:23];
	[comps setMinute:59];
	[comps setSecond:59];
	NSDate *date = [calendar dateByAddingComponents:comps toDate:[self dateWithoutTimeComponent] options:0];
	
	return date;
}

+(NSDate*) yearBeginDateForYear:(NSInteger) year
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:[self dateWithoutTimeComponent]];
	
	if (year != 0)
		[components setYear:year];
	
	[components setMonth:1];
	[components setDay:1];
		
	NSDate* result = [calendar dateFromComponents:components];
	
	return result;
}
+(NSDate*) yearEndDateForYear:(NSInteger) year
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:[self dateWithoutTimeComponent]];
	
	if (year != 0)
		[components setYear:year];
	
	[components setMonth:12];
	[components setDay:31];
	[components setHour:23];
	[components setMinute:59];
	[components setSecond:59];
		
	NSDate* result = [calendar dateFromComponents:components];
	
	return result;
}

+(NSDate*) yearBeginDate
{
	return [self yearBeginDateForYear:0];
}
+(NSDate*) yearEndDate
{
	return [self yearEndDateForYear:0];
}

+(NSDate*) monthBeginDateForMonth:(NSInteger) month
{	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:[self dateWithoutTimeComponent]];
	
	if (month != 0)
	{
		[components setMonth:month];
	}
	[components setDay:1];
	
	NSDate* result = [calendar dateFromComponents:components];
	
	return result;
}
+(NSDate*) monthEndDateForMonth:(NSInteger) month
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:[self dateWithoutTimeComponent]];
	
	if (month != 0)
	{
		[components setMonth:month];		
	}
	
	[components setHour:23];
	[components setMinute:59];
	[components setSecond:59];
	
	NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit
								   inUnit:NSMonthCalendarUnit
								  forDate:[calendar dateFromComponents:components]];
	
	[components setDay:range.length];
	
	NSDate* result = [calendar dateFromComponents:components];
	
	return result;
}

+(NSDate*) monthBeginDate
{
	return [self monthBeginDateForMonth:0];
}
+(NSDate*) monthEndDate
{
	return [self monthEndDateForMonth:0];
}

-(NSDate*) monthBeginDate
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:[self dateWithoutTimeComponent]];
	
	
	[components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	NSDate* result = [calendar dateFromComponents:components];
	
	return result;
}
-(NSDate*) monthEndDate
{
	NSDate* monthBeginDate = [self monthBeginDate];
	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:monthBeginDate];
		
	
	NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit
								   inUnit:NSMonthCalendarUnit
								  forDate:[calendar dateFromComponents:components]];
	
	NSLog(@"Hour: %li", (long)[components hour]);
	NSLog(@"Minutes: %li", (long)[components minute]);
	NSLog(@"Seconds: %li", (long)[components second]);
	
	[components setDay:range.length];
			
	[components setHour:23];
	[components setMinute:59];
	[components setSecond:59];
	
	NSDate* result = [calendar dateFromComponents:components];
	
	return result;
}

+(NSDate*) weekBeginDateForWeek:(NSInteger) week
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekdayCalendarUnit|NSWeekdayOrdinalCalendarUnit
											   fromDate:[self yearBeginDateForYear:0]];
	
	if (week != 0)
		[components setDay:week*7];
	else
		[components setDay:[[NSDate date] week]*7];
	
	NSInteger weekDay = [[calendar dateFromComponents:components] weekDay]-1;
	NSInteger day = [components day];
	[components setDay:(day-weekDay)];
		
	return [calendar dateFromComponents:components];
}
+(NSDate*) weekEndDateForWeek:(NSInteger) week
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:[self weekBeginDateForWeek:week]];
	
	[components setDay:([components day] + 6)];
	[components setHour:23];
	[components setMinute:59];
	[components setSecond:59];
	
	NSDate* result = [calendar dateFromComponents:components];
	
	return result;
}

+(NSDate*) weekBeginDate
{
	return [self weekBeginDateForWeek:0];
}
+(NSDate*) weekEndDate
{
	return [self weekEndDateForWeek:0];
}

-(NSInteger) day
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:self];
	
	NSInteger result = [components day];
	
	return result;	
}
-(NSInteger) week
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:self];
	
	NSInteger result = [components week];
	
	return result;	
}
-(NSInteger) month
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:self];
	
	NSInteger result = [components month];
	
	return result;	
}
-(NSInteger) year
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:self];
	
	NSInteger result = [components year];
	
	return result;	
}

-(NSInteger) hour
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:self];
	
	NSInteger result = [components hour];
	
	return result;	
}

-(NSInteger) minute
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:self];
	
	NSInteger result = [components minute];
	
	return result;	
}

-(NSInteger) second
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
											   fromDate:self];
	
	NSInteger result = [components second];
	
	return result;	
}

-(NSDate*) dateByAddingDays:(NSInteger) days
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];	
	[comps setDay:days];
	NSDate *date = [calendar dateByAddingComponents:comps toDate:self options:0];
	
	return date;
}

-(NSDate*) dateByAddingMonths:(NSInteger) months
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];	
	[comps setMonth:months];
	NSDate *date = [calendar dateByAddingComponents:comps toDate:self options:0];
	
	return date;
}

-(NSDate*) dateByAddingYears:(NSInteger) years
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];	
	[comps setYear:years];
	NSDate *date = [calendar dateByAddingComponents:comps toDate:self options:0];
	
	return date;
}

@end
