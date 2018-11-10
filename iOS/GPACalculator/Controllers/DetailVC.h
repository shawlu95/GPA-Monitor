//
//  DetailVC.h
//  GPACalculator
//
//  Created by Xiao on 7/20/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

typedef NS_ENUM(NSInteger, EditingState) {
    ADDING_NEW_COURSE,
    EDIT_EXISTING_COURSE
};

@interface DetailVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) Course *selectedCourse;
@property (nonatomic, assign) EditingState editingState;
@end
