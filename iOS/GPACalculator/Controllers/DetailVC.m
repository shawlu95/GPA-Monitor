//
//  DetailVC.m
//  GPACalculator
//
//  Created by Xiao on 7/20/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import "DetailVC.h"
#import "TextFieldCell.h"
#import "UIViewController+BackButtonHandler.h"
#import "Macros.h"

typedef NS_ENUM(NSInteger, PickerState) {
    CHOOSE_GRADE = 1000,
    CHOOSE_TERM = 1001,
    CHOOSE_MAJOR = 1002,
    CHOOSE_CREDIT = 1003
};

@interface DetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) TextFieldCell *nameCell;
@property (nonatomic, assign) TextFieldCell *gradeCell;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *pickerLabel;
@property (nonatomic, assign) TextFieldCell *creditCell;
@property (assign, nonatomic) PickerState pickerState;
@property (strong, nonatomic) NSArray *gradeOptions;
@property (strong, nonatomic) NSArray *creditOptions;
@property (strong, nonatomic) NSArray *yearOptions;
@property (strong, nonatomic) NSArray *termsOptions;
@property (strong, nonatomic) NSArray *majorOptions;
@property (strong, nonatomic) NSMutableDictionary *dictCopy;
@end

@implementation DetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.dictCopy = [self.selectedCourse dictionaryRepresentation];
    self.pickerView.alpha = 0;
    self.pickerLabel.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (self.editingState == ADDING_NEW_COURSE) {
        [self.nameCell.textField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.creditCell.textField]) {
        textField.text = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.nameCell.textField]) {
        self.dictCopy[KEY_NAME] = textField.text;
    } else if ([textField isEqual:self.creditCell.textField]) {
        self.dictCopy[KEY_CREDIT] = [NSNumber numberWithInteger: textField.text.integerValue];
    }
    return YES;
}

#pragma mark - UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
    if (indexPath.row == 0) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTitleCell"];
        cell.textField.text = self.dictCopy[KEY_NAME];
        cell.titleLabel.text = CELL_TITLE_NAME;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (indexPath.row == 1) {
        cell.textField.text = self.dictCopy[KEY_GRADE];
        cell.textField.userInteractionEnabled = NO;
        cell.titleLabel.text = CELL_TITLE_GRADE;
    } else if (indexPath.row == 2) {
        cell.textField.text = [NSString stringWithFormat:@"%@", self.dictCopy[KEY_CREDIT]];
        cell.textField.userInteractionEnabled = NO;
        cell.titleLabel.text = CELL_TITLE_CREDIT;
    } else if (indexPath.row == 3) {
        NSNumber *year = self.dictCopy[KEY_YEAR_STR];
        NSNumber *term = self.dictCopy[KEY_TERM_STR];
        cell.textField.text = [NSString stringWithFormat:@"%@ %@", year, term];
        cell.textField.userInteractionEnabled = NO;
        cell.titleLabel.text = CELL_TITLE_TERM;
    } else if (indexPath.row == 4) {
        cell.titleLabel.text = CELL_TITLE_MAJOR;
        cell.textField.text = self.dictCopy[KEY_MAJOR_STR];
        cell.textField.userInteractionEnabled = NO;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TextFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
    if (indexPath.row == 1) {
        self.pickerState = CHOOSE_GRADE;
        [self.pickerView reloadAllComponents];
        [self showPicker];
    } else if (indexPath.row == 2) {
        self.pickerState = CHOOSE_CREDIT;
        [self.pickerView reloadAllComponents];
        [self showPicker];
    } else if (indexPath.row == 3) {
        self.pickerState = CHOOSE_TERM;
        [self.pickerView reloadAllComponents];
        [self showPicker];
    } else if (indexPath.row == 4) {
        self.pickerState = CHOOSE_MAJOR;
        [self.pickerView reloadAllComponents];
        [self showPicker];
    } else {
        [self hidePicker];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.pickerState == CHOOSE_GRADE) {
        return 1;
    } else if (self.pickerState == CHOOSE_CREDIT) {
        return 1;
    } else if (self.pickerState == CHOOSE_TERM) {
        return 2;
    } else if (self.pickerState == CHOOSE_MAJOR) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickerState == CHOOSE_GRADE) {
        return self.gradeOptions.count;
    } else if (self.pickerState == CHOOSE_CREDIT) {
        return self.creditOptions.count;
    } else if (self.pickerState == CHOOSE_TERM) {
        if (component == 0) {
            return self.yearOptions.count;
        } else if (component == 1) {
            return self.termsOptions.count;
        }
        return 0;
    } else if (self.pickerState == CHOOSE_MAJOR) {
        return self.majorOptions.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.pickerState == CHOOSE_GRADE) {
        return self.gradeOptions[row];
    } if (self.pickerState == CHOOSE_CREDIT) {
        return self.creditOptions[row];
    } else if (self.pickerState == CHOOSE_TERM){
        if (component == 0) {
            return [NSString stringWithFormat:@"%@", self.yearOptions[row]];
        } else if (component == 1) {
            return self.termsOptions[row];
        }
        return 0;
    } else if (self.pickerState == CHOOSE_MAJOR) {
        return self.majorOptions[row];
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerState == CHOOSE_GRADE) {
        self.dictCopy[KEY_GRADE] = self.gradeOptions[row];
    } else if (self.pickerState == CHOOSE_CREDIT) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterNoStyle;
        self.dictCopy[KEY_CREDIT] = [f numberFromString: self.creditOptions[row]];
    } else if (self.pickerState == CHOOSE_TERM){
        if (component == 0) {
            self.dictCopy[KEY_YEAR_STR] = self.yearOptions[row];
        } else if (component == 1) {
            self.dictCopy[KEY_TERM_STR] = self.termsOptions[row];
        }
    } else if (self.pickerState == CHOOSE_MAJOR) {
        self.dictCopy[KEY_MAJOR_STR] = self.majorOptions[row];
    }
    [self.tableView reloadData];
}

#pragma mark - Utilities
- (TextFieldCell *)nameCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (TextFieldCell *)gradeCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (TextFieldCell *)creditCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (Course *)selectedCourse {
    if (!_selectedCourse) {
        NSEntityDescription *entityWorkout = [NSEntityDescription entityForName:COURSE
                                                         inManagedObjectContext:[Course managedObjectContext]];
        NSManagedObject *new = [[NSManagedObject alloc] initWithEntity:entityWorkout
                                        insertIntoManagedObjectContext:[Course managedObjectContext]];
        
        // Casting the newly created workout from NSManagedObject class to Workout class.
        Course *course = (Course *)new;
        course.created = [NSDate date];
        course.grade = GRADE_A;
        course.major = @0;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_TERM]) {
            course.term = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TERM];
        } else {
            course.term = [NSNumber numberWithInteger:0];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_YEAR]) {
            course.year = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_YEAR];
        } else {
            course.year = @"0";
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_CREDIT]) {
            course.credit = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CREDIT];
        } else {
            course.credit = [NSNumber numberWithInteger:4];
        }
        course.majorStr = MAJOR_NA;
        self.editingState = ADDING_NEW_COURSE;
        _selectedCourse = course;
    }
    return _selectedCourse;
}

- (void) hidePicker {
    self.pickerView.alpha = 0;
    self.pickerLabel.alpha = 0;
}

- (void) showPicker {
    self.pickerView.alpha = 1;
    [self.nameCell.textField resignFirstResponder];
    if (self.pickerState == CHOOSE_GRADE) {
        NSInteger grade = [self.gradeOptions indexOfObject:self.selectedCourse.grade];
        [self.pickerView selectRow:grade inComponent:0 animated:NO];
        self.pickerLabel.alpha = 0;
    } else if (self.pickerState == CHOOSE_CREDIT) {
        NSNumber *credit = self.dictCopy[KEY_CREDIT];
        [self.pickerView selectRow: credit.integerValue inComponent:0 animated:NO];
        self.pickerLabel.alpha = 0;
    } else if (self.pickerState == CHOOSE_TERM) {
        NSInteger term = [self.termsOptions indexOfObject:self.selectedCourse.termString];
        [self.pickerView selectRow:term inComponent:1 animated:NO];
        
        NSInteger year = [self.yearOptions indexOfObject:self.selectedCourse.yearString];
        [self.pickerView selectRow:year inComponent:0 animated:NO];
        self.pickerLabel.alpha = 0;
    } else if (self.pickerState == CHOOSE_MAJOR) {
        [self.pickerView selectRow:[self.majorOptions indexOfObject:self.dictCopy[KEY_MAJOR_STR]] inComponent:0 animated:NO];
        self.pickerLabel.alpha = 1;
    }
}

- (NSArray *)gradeOptions {
    if (!_gradeOptions) {
        _gradeOptions = @[GRADE_A, GRADE_A_M, GRADE_B_P, GRADE_B, GRADE_B_M,
                          GRADE_C_P, GRADE_C, GRADE_C_M, GRADE_D_P, GRADE_D,
                          GRADE_D_M, GRADE_P, GRADE_F, GRADE_W, GRADE_I];
    }
    return _gradeOptions;
}

- (NSArray *)creditOptions {
    if (!_creditOptions) {
        _creditOptions = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    }
    return _creditOptions;
}
- (NSArray *)yearOptions {
    if (!_yearOptions) {
        _yearOptions = @[YEAR_0, YEAR_1, YEAR_2, YEAR_3];
    }
    return _yearOptions;
}

- (NSArray *)termsOptions {
    if (!_termsOptions) {
        _termsOptions = @[TERM_0, TERM_1, TERM_2, TERM_3];
    }
    return _termsOptions;
}

- (NSArray *) majorOptions {
    if (!_majorOptions) {
        _majorOptions = @[MAJOR_NA, MAJOR_ART_ARAB_CROSSROAD, MAJOR_ART_HISTORY, MAJOR_BIOLOGY, MAJOR_CHEMISTRY,
                          MAJOR_CIVIL_ENGR, MAJOR_COMPUTER_ENGR, MAJOR_COMPUTER_SCIENCE, MAJOR_ECONOMICS,
                          MAJOR_ELECTRICAL_ENGR, MAJOR_FILM, MAJOR_GENERAL_ENGR, MAJOR_HISTORY, MAJOR_LITERATURE,
                          MAJOR_MATH, MAJOR_MECHANICAL_ENGR, MAJOR_MUSIC, MAJOR_PHYLOSOPHY, MAJOR_PHYSICS,
                          MAJOR_POLISCI, MAJOR_PSYCHOLOGY, MAJOR_SRPP, MAJOR_THEATER, MAJOR_VISUAL_ARTS];
    }
    return _majorOptions;
}

- (UIAlertController *) noCourseNameAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Required field empty."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                         [self.nameCell.textField becomeFirstResponder];}];
    [alert addAction:action];
    return alert;
}

#pragma mark IBAction & Navigation
- (IBAction)didTapSave:(id)sender {
    [self.view endEditing:YES];
    if ([self.nameCell.textField.text isEqualToString:@""]) {
        [self presentViewController:[self noCourseNameAlert] animated:YES completion:nil];
    } else {
        self.selectedCourse.name = self.dictCopy[KEY_NAME];
        self.selectedCourse.grade = self.dictCopy[KEY_GRADE];
        self.selectedCourse.credit = self.dictCopy[KEY_CREDIT];
        self.selectedCourse.termString = self.dictCopy[KEY_TERM_STR];
        self.selectedCourse.yearString = self.dictCopy[KEY_YEAR_STR];
        self.selectedCourse.lastModified = [NSDate date];
        self.selectedCourse.majorStr = self.dictCopy[KEY_MAJOR_STR];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.selectedCourse.term forKey:KEY_TERM];
        [[NSUserDefaults standardUserDefaults] setObject:self.selectedCourse.year forKey:KEY_YEAR];
        [[NSUserDefaults standardUserDefaults] setObject:self.selectedCourse.credit forKey:KEY_CREDIT];
        
        [Course saveContext];
        
        [self performSegueWithIdentifier:@"unwindtoTableView" sender:self];
    }
}

-(BOOL) navigationShouldPopOnBackButton {
    if (self.editingState == ADDING_NEW_COURSE)
        [[Course managedObjectContext] deleteObject:self.selectedCourse];
    return YES;
}

#pragma mark Device Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return NO;
}

@end
