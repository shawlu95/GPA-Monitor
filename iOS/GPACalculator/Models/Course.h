//
//  Course.h
//  GPACalculator
//
//  Created by Xiao on 7/23/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course : NSManagedObject

@property (nonatomic, strong) NSString *yearString;
@property (nonatomic, strong) NSString *termString;

- (NSMutableDictionary*) dictionaryRepresentation;
- (NSMutableDictionary*) JSONdictionaryRepresentation;
+ (NSString *) yearStringForInteger: (NSInteger) integer;
+ (NSString *) termStringForInteger: (NSInteger) integer;
- (float) numGrade;
- (void) copyFromDict: (NSDictionary *) dict;

+ (void) logXMLFilePath;
+ (NSArray *) allItems;
+ (NSNumber*) GPA;
+ (NSNumber*) year1GPA;
+ (NSNumber*) year2GPA;
+ (NSNumber*) year3GPA;
+ (NSNumber*) year4GPA;
+ (NSNumber*) cumulativeGPA;
+ (NSNumber*) majorGPA;
+ (NSMutableDictionary *)majorGPAs;
+ (NSNumber*) EHRS;
+ (Course *)findByName:(NSString *)name;
+ (Course *)findByIndex:(NSNumber *)index;
+ (void) exportAllItems;
+ (NSManagedObjectContext *) managedObjectContext;
+ (void)saveContext;
+ (void)read;
@end

NS_ASSUME_NONNULL_END

#import "Course+CoreDataProperties.h"
