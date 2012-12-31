// http://iphonedevelopment.blogspot.com/2009/07/category-on-nsdate.html

#import <Foundation/Foundation.h>

@interface NSDate(Misc)
+ (NSDate *)dateWithoutTime;
- (NSDate *)dateByAddingDays:(NSInteger)numDays;
- (NSDate *)dateAsDateWithoutTime;
- (int)differenceInDaysTo:(NSDate *)toDate;
- (NSString *)formattedDateString;
- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat;
@end