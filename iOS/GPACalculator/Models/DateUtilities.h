//
//  DateUtilities.h
//  Grocery
//
//  Created by Xiao on 7/15/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtilities : NSObject
+ (NSString *) mySQLDateTimeForDate: (NSDate *) date;
+ (NSDate *) dateTimeUsingStringFromAPI: (NSString *) mySQLDate;
@end
