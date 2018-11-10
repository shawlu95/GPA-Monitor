//
//  DateUtilities.m
//  Grocery
//
//  Created by Xiao on 7/15/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import "DateUtilities.h"

@implementation DateUtilities

+ (NSDateFormatter*)dateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}

+ (NSDateFormatter *) timeFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    return formatter;
}

+ (NSDateFormatter *) dateTimeFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;
}

+ (NSString *) mySQLDateTimeForDate: (NSDate *) date{
    return [NSString stringWithFormat:@"%@ %@", [self mySQLDateForDate:date], [self mySQLTimeForDate:date]];
}

+ (NSString*) mySQLDateForDate: (NSDate*) date {
    return [[DateUtilities dateFormatter] stringFromDate:date];
}

+ (NSString*) mySQLTimeForDate: (NSDate*) date {
    return [[DateUtilities timeFormatter] stringFromDate:date];
}

+ (NSDate *) dateTimeUsingStringFromAPI: (NSString *) mySQLDate {
    return [[DateUtilities dateTimeFormatter] dateFromString:mySQLDate];
}

@end
