//
//  Course+CoreDataProperties.h
//  GPACalculator
//
//  Created by Xiao on 7/23/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *created;
@property (nullable, nonatomic, retain) NSDate *lastModified;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *grade;
@property (nullable, nonatomic, retain) NSNumber *major;
@property (nullable, nonatomic, retain) NSNumber *credit;
@property (nullable, nonatomic, retain) NSNumber *term;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *year;
@property (nullable, nonatomic, retain) NSString *majorStr;
@end

NS_ASSUME_NONNULL_END
