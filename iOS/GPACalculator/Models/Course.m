//
//  Course.m
//  GPACalculator
//
//  Created by Xiao on 7/23/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import "Course.h"
#import "Macros.h"
#import "DateUtilities.h"

@interface Course ()
@end

@implementation Course

#pragma mark - Properties
- (NSString *)yearString {
    return [Course yearStringForInteger:self.year.integerValue];
}

-(void)setYearString:(NSString *)yearString {
    NSDictionary *conversion = @{
                                 YEAR_0 :   @"0",
                                 YEAR_1 :   @"1",
                                 YEAR_2 :   @"2",
                                 YEAR_3 :   @"3"
                                 };
    self.year = conversion[yearString];
}

- (NSString *)termString {
    return [Course termStringForInteger:self.term.integerValue];
}

- (void)setTermString:(NSString *)termString {
    NSDictionary *conversion = @{
                                 TERM_0     :    @0,
                                 TERM_1     :    @1,
                                 TERM_2     :    @2,
                                 TERM_3     :    @3
                                 };
    self.term = conversion[termString];
}

#pragma mark - Transformation
- (NSMutableDictionary*) dictionaryRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.name) [dict setValue:self.name forKey:KEY_NAME];
    if (self.credit)[dict setValue:self.credit forKey:KEY_CREDIT];
    if (self.grade)[dict setValue:self.grade forKey:KEY_GRADE];
    if (self.created)[dict setValue:self.created forKey:KEY_CREATED];
    if (self.lastModified)[dict setValue:self.lastModified forKey:KEY_LAST_MODIFIED];
    if (self.term)[dict setValue:self.termString forKey:KEY_TERM_STR];
    if (self.term)[dict setValue:self.term forKey:KEY_TERM];
    if (self.year)[dict setValue:self.yearString forKey:KEY_YEAR_STR];
    if (self.year)[dict setValue:self.year forKey:KEY_YEAR];
    if (self.major)[dict setValue:self.major forKey:KEY_MAJOR];
    if (self.majorStr)[dict setValue:self.majorStr forKey:KEY_MAJOR_STR];
    if (self.id)[dict setValue:self.id forKey:KEY_ID];
    return dict;
}

-(NSMutableDictionary *)JSONdictionaryRepresentation {
    NSMutableDictionary *dict = [self dictionaryRepresentation];
    [dict removeObjectForKey:KEY_LAST_MODIFIED];
    [dict removeObjectForKey:KEY_TERM_STR];
    if (self.termString) [dict setObject:self.termString forKey:KEY_TERM];
    [dict removeObjectForKey:KEY_YEAR_STR];
    [dict setObject:self.yearString forKey:KEY_YEAR];
    if (self.created) [dict setValue:[DateUtilities mySQLDateTimeForDate:self.created] forKey:KEY_CREATED];
    if ([DateUtilities mySQLDateTimeForDate:self.lastModified] )
        [dict setValue:[DateUtilities mySQLDateTimeForDate:self.lastModified] forKey:KEY_LAST_MODIFIED];
    return dict;
}

-(void)copyFromDict:(NSDictionary *)dict {
    if (dict[KEY_NAME])             self.name = dict[KEY_NAME];
    if (dict[KEY_CREATED])          self.created = dict[KEY_CREATED];
    if (dict[KEY_LAST_MODIFIED])    self.lastModified = dict[KEY_LAST_MODIFIED];
    if (dict[KEY_GRADE])            self.grade = dict[KEY_GRADE];
    if (dict[KEY_CREDIT])           self.credit = dict[KEY_CREDIT];
    if (dict[KEY_YEAR])             self.year = dict[KEY_YEAR];
    if (dict[KEY_TERM])             self.term = dict[KEY_TERM];
    if (dict[KEY_MAJOR])            self.major = dict[KEY_MAJOR];
    if (dict[KEY_ID])               self.id = dict[KEY_ID];
}

#pragma mark - Deliverables
- (float) numGrade {
    NSNumber *scaled = [Course gradeToNumber:self.grade];
    return scaled.floatValue;
}

+ (NSNumber *)GPA {
    NSArray *arr = [Course allItems];
    NSInteger creditSum = 0;
    float scoreTimesCreditSum = 0;
    for (Course *course in arr) {
        if ([Course gradeToNumber:course.grade] &&
            ![course.year isEqualToString:@"0"]) {
            creditSum += course.credit.integerValue;
            float numGrade = [course numGrade];
            scoreTimesCreditSum += course.credit.integerValue * numGrade;
        } else {
            if (DEVELOPMENT) NSLog(@"Course is not counted to official GPA: %@", course.name);
        }
    }
    float GPA = 0;
    if (creditSum != 0) GPA = scoreTimesCreditSum/creditSum;
    if (DEVELOPMENT) NSLog(@"GPA: %f", GPA);
    return [NSNumber numberWithFloat:GPA];
}

+ (NSNumber *)year1GPA {
    NSArray *arr = [Course allItems];
    NSInteger creditSum = 0;
    float scoreTimesCreditSum = 0;
    for (Course *course in arr) {
        if ([Course gradeToNumber:course.grade] && [course.year isEqualToString:@"0"]) {
            creditSum += course.credit.integerValue;float numGrade = [course numGrade];
            scoreTimesCreditSum += course.credit.integerValue * numGrade;
        }
    }
    float GPA = 0;
    if (creditSum != 0) GPA = scoreTimesCreditSum/creditSum;
    return [NSNumber numberWithFloat:GPA];
}

+ (NSNumber *)year2GPA {
    NSArray *arr = [Course allItems];
    NSInteger creditSum = 0;
    float scoreTimesCreditSum = 0;
    for (Course *course in arr) {
        if ([Course gradeToNumber:course.grade] && [course.year isEqualToString:@"1"]) {
            creditSum += course.credit.integerValue;float numGrade = [course numGrade];
            scoreTimesCreditSum += course.credit.integerValue * numGrade;
        }
    }
    float GPA = 0;
    if (creditSum != 0) GPA = scoreTimesCreditSum/creditSum;
    return [NSNumber numberWithFloat:GPA];
}

+ (NSNumber *)year3GPA {
    NSArray *arr = [Course allItems];
    NSInteger creditSum = 0;
    float scoreTimesCreditSum = 0;
    for (Course *course in arr) {
        if ([Course gradeToNumber:course.grade] && course.year.integerValue == 2) {
            creditSum += course.credit.integerValue;float numGrade = [course numGrade];
            scoreTimesCreditSum += course.credit.integerValue * numGrade;
        }
    }
    float GPA = 0;
    if (creditSum != 0) GPA = scoreTimesCreditSum/creditSum;
    return [NSNumber numberWithFloat:GPA];
}

+ (NSNumber *)year4GPA {
    NSArray *arr = [Course allItems];
    NSInteger creditSum = 0;
    float scoreTimesCreditSum = 0;
    for (Course *course in arr) {
        if ([Course gradeToNumber:course.grade] && course.year.integerValue == 3) {
            creditSum += course.credit.integerValue;float numGrade = [course numGrade];
            scoreTimesCreditSum += course.credit.integerValue * numGrade;
        }
    }
    float GPA = 0;
    if (creditSum != 0) GPA = scoreTimesCreditSum/creditSum;
    return [NSNumber numberWithFloat:GPA];
}

+ (NSNumber *) cumulativeGPA {
    NSArray *arr = [Course allItems];
    NSInteger creditSum = 0;
    float scoreTimesCreditSum = 0;
    for (Course *course in arr) {
        if ([Course gradeToNumber:course.grade]) {
            creditSum += course.credit.integerValue;float numGrade = [course numGrade];
            scoreTimesCreditSum += course.credit.integerValue * numGrade;
        }
    }
    float GPA = 0;
    if (creditSum != 0) GPA = scoreTimesCreditSum/creditSum;
    return [NSNumber numberWithFloat:GPA];
}

+ (NSNumber *)majorGPA {
    NSArray *arr = [Course allItems];
    NSInteger creditSum = 0;
    float scoreTimesCreditSum = 0;
    for (Course *course in arr) {
        if ([Course gradeToNumber:course.grade] && [course.majorStr isEqualToString:MAJOR_NA]) {
            creditSum += course.credit.integerValue;float numGrade = [course numGrade];
            scoreTimesCreditSum += course.credit.integerValue * numGrade;
        }
    }
    float GPA = 0;
    if (creditSum != 0) GPA = scoreTimesCreditSum/creditSum;
    return [self GPAForCoursesArray:arr];
}

+ (NSMutableDictionary *)majorGPAs {
    NSArray *arr = [Course allItems];
    NSInteger creditSum = 0;
    float scoreTimesCreditSum = 0;
    for (Course *course in arr) {
        if ([Course gradeToNumber:course.grade] && course.major.integerValue == 1) {
            creditSum += course.credit.integerValue;float numGrade = [course numGrade];
            scoreTimesCreditSum += course.credit.integerValue * numGrade;
        }
    }
    float GPA = 0;
    if (creditSum != 0) GPA = scoreTimesCreditSum/creditSum;
    
    NSMutableDictionary *majorGPAs = [[NSMutableDictionary alloc] init];
    NSArray *majorArr = [Course allMajors];
    for (NSString *majorStr in majorArr) {
        NSArray *courses = [self coursesForMajor:majorStr];
        NSNumber *majorGPA = [self GPAForCoursesArray:courses];
        [majorGPAs setObject:majorGPA forKey: majorStr];
    }
    return majorGPAs;
}

+ (NSArray *) allMajors {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:COURSE];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COURSE inManagedObjectContext:self.managedObjectContext];
    
    // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
    // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
    // Since you only want distinct names, only ask for the 'name' property.
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:KEY_MAJOR_STR]];
    fetchRequest.returnsDistinctResults = YES;
    
    // Now it should yield an NSArray of distinct values in dictionaries.
    NSArray *dictionaries = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSMutableArray *majors = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dictionaries) {
        NSArray *values = [dict allValues];
        [majors addObject:values[0]];
    }
    if ([majors containsObject:MAJOR_NA]) [majors removeObject:MAJOR_NA];
    return majors;
}

+ (NSNumber *) GPAForCoursesArray: (NSArray *) array {
    NSInteger creditSum = 0;
    float scoreTimesCreditSum = 0;
    for (Course *course in array) {
        if ([Course gradeToNumber:course.grade]) {
            creditSum += course.credit.integerValue;float numGrade = [course numGrade];
            scoreTimesCreditSum += course.credit.integerValue * numGrade;
        }
    }
    float GPA = 0;
    if (creditSum != 0) GPA = scoreTimesCreditSum/creditSum;
    return [NSNumber numberWithFloat:GPA];
}

+ (NSArray *) coursesForMajor: (NSString *) major {
    NSManagedObjectContext *managedObjectContext = [Course managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription  entityForName:COURSE inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"majorStr == %@", major];
    fetchRequest.predicate = predicate;
    NSError *error = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return objects;
}

// Units taken towards graduation, any class that is not failed.
+ (NSNumber *) EHRS {
    NSArray *arr = [Course allItems];
    NSInteger creditSum = 0;
    for (Course *course in arr) {
        if (![course invalidCredit]) {
            creditSum += course.credit.integerValue;
        }
    }
    return [NSNumber numberWithInteger:creditSum];
}

#pragma mark - Local Storage
+ (NSManagedObjectContext *) managedObjectContext {
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

+ (void) saveContext {
    NSManagedObjectContext *managedObjectContext = [Course managedObjectContext];
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            // abort();
        }
    }
}

+ (void) logXMLFilePath {
    NSURL *fileURL = [NSURL URLWithString:COURSE relativeToURL:[self XMLDataRecordsDirectory]];
    if (DEVELOPMENT) NSLog(@"%@", [fileURL path]);
}

+ (NSURL *)applicationCacheDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (void) exportAllItems {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Course *course in [Course allItems]) {
        [array addObject: [course dictionaryRepresentation]];
    }
    NSURL *fileURL = [NSURL URLWithString:COURSE relativeToURL:[self XMLDataRecordsDirectory]];
    [array writeToFile:[fileURL path] atomically:YES];
}

+ (void)read {
    NSURL *fileURL = [NSURL URLWithString:COURSE relativeToURL:[self XMLDataRecordsDirectory]];
    NSArray *array = [NSMutableArray arrayWithContentsOfURL:fileURL];
    if (array) {
        for (NSDictionary *dict in array) {
            Course *coreDataItem = [Course findByName:dict[KEY_NAME]];
            if (!coreDataItem) {
                NSEntityDescription *entityWorkout = [NSEntityDescription entityForName:COURSE
                                                                 inManagedObjectContext:[Course managedObjectContext]];
                NSManagedObject *new = [[NSManagedObject alloc] initWithEntity:entityWorkout
                                                insertIntoManagedObjectContext:[Course managedObjectContext]];
                Course *item = (Course *)new;
                [item copyFromDict:dict];
            }
            [Course saveContext];
        }
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    }
}

+ (NSURL *)XMLDataRecordsDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:@"XML/" relativeToURL:[self applicationCacheDirectory]];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:[url path]]) {
        [fileManager createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return url;
}

+ (NSArray *)allItems {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [Course managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COURSE inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:KEY_NAME ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error;
    NSArray *results = [[Course managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return results;
}

#pragma mark - Utilities
- (BOOL) invalidCredit {
    return [self.grade isEqualToString:GRADE_I] || [self.grade isEqualToString:GRADE_W] || [self.grade isEqualToString:GRADE_F];
}

+ (Course *)findByName:(NSString *)name {
    NSManagedObjectContext *managedObjectContext = [Course managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription  entityForName:COURSE inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    fetchRequest.predicate = predicate;
    NSError *error = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (objects.count == 1) {
        return objects[0];
    } else if (objects.count > 1) {
        Course *first = objects[0];
        for (Course *item in objects) {
            [managedObjectContext deleteObject:item];
        }
        [Course saveContext];
        return first;
    }
    return nil;
}

+(Course *)findByIndex:(NSNumber *)index {
    NSManagedObjectContext *managedObjectContext = [Course managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription  entityForName:COURSE inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", index];
    fetchRequest.predicate = predicate;
    NSError *error = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (objects.count == 1) {
        return objects[0];
    } else if (objects.count > 1) {
        Course *first = objects[0];
        for (Course *item in objects) {
            [managedObjectContext deleteObject:item];
        }
        [Course saveContext];
        return first;
    }
    return nil;
}

+ (NSNumber *) gradeToNumber: (NSString *) grade {
    NSDictionary *conversion = @{
                                 GRADE_A :  @4,     GRADE_A_M: @3.7,
                                 GRADE_B_P: @3.3,   GRADE_B : @3,      GRADE_B_M: @2.7,
                                 GRADE_C_P: @2.3,   GRADE_C : @2.0,    GRADE_C_M: @1.7,
                                 GRADE_D_P: @1.3,   GRADE_D : @1,      GRADE_D_M: @0.7,
                                 GRADE_F :  @0
                                 };
    return [conversion objectForKey:grade];
}

+ (NSString *)yearStringForInteger:(NSInteger)integer {
    switch (integer) {
        case 0:
            return YEAR_0;
            break;
        case 1:
            return YEAR_1;
            break;
        case 2:
            return YEAR_2;
            break;
        case 3:
            return YEAR_3;
            break;
        default:
            break;
    }
    return @"Err";
}

+ (NSString *)termStringForInteger:(NSInteger)integer {
    switch (integer) {
        case 0:
            return TERM_0;
            break;
        case 1:
            return TERM_1;
            break;
        case 2:
            return TERM_2;
            break;
        case 3:
            return TERM_3;
            break;
        default:
            break;
    }
    return @"Err";
}

@end
