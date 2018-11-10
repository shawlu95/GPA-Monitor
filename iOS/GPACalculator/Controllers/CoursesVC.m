//
//  ViewController.m
//  GPACalculator
//
//  Created by Xiao on 7/20/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import "CoursesVC.h"
#import "Macros.h"

@interface CoursesVC ()
@property (weak, nonatomic) IBOutlet UILabel *gpaLabel;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewToLabel;
@property (nonatomic, strong) Course *selectedCourse;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation CoursesVC

- (void)viewDidLoad {
    [self configureMotionEffect];
    [self executeFetchedResultsController];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configureGPA];
    self.footerLabel.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [self displayDetail];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell"];
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = course.name;
    cell.termLabel.text = [NSString stringWithFormat:@"%@, %@ credits", course.termString, course.credit];
    cell.gradeLabel.text = course.grade;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSString *year = [theSection name];
    return [Course yearStringForInteger:year.integerValue];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[Course managedObjectContext] deleteObject:course];
    }
    [Course saveContext];
    [self configureGPA];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedCourse = course;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"toEditCourse" sender:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 0) {
        [self hideDetail];
    }
    
    if (- scrollView.contentOffset.y / self.tableView.frame.size.height > 0.05) {
        [self displayDetail];
    }
}

#pragma mark Fetched Results Controller delegate
- (NSFetchedResultsController *) fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [Course managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COURSE inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:KEY_YEAR ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:KEY_TERM ascending:NO];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:KEY_NAME ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor, sortDescriptor2, sortDescriptor3]];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:KEY_YEAR cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

-(void) executeFetchedResultsController {
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch: &error]) {
        if (DEVELOPMENT) NSLog(@"Error! %@", error);
        if (DEVELOPMENT) abort();
    }
}

- (void) controllerWillChangeContent:(nonnull NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void) controllerDidChangeContent:(nonnull NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case NSFetchedResultsChangeUpdate: {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeMove: {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
    }
    [self performSelector:@selector(configureGPA) withObject:self afterDelay:1];
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    UITableView *tableView = self.tableView;
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

#pragma mark - Utilities
- (void) configureGPA {
    NSMutableString *str = [[NSMutableString alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.gpaLabel.text = [NSString stringWithFormat:@"%.2f", [Course GPA].floatValue];
    if ([defaults boolForKey:SETTING_CELL_TITLE_CREDIT])
        [str appendString:[NSString stringWithFormat:@"Credits: %@\n", [Course EHRS]]];
    if ([defaults boolForKey:SETTING_CELL_TITLE_CUMULATIVE_GPA])
        [str appendString:[NSString stringWithFormat:@"Cumulative: %.3f\n", [Course cumulativeGPA].floatValue]];
    if ([defaults boolForKey:SETTING_CELL_TITLE_MAJOR_GPA]) {
        NSMutableDictionary *majorGPAs = [Course majorGPAs];
        NSArray *majors = [majorGPAs allKeys];
        for (NSString *major in majors) {
            NSNumber *majorGPA = majorGPAs[major];
            [str appendString:[NSString stringWithFormat:@"%@: %.3f", major, majorGPA.floatValue]];
            [str appendString:@"\n"];
        }
    }
    if ([defaults boolForKey:SETTING_CELL_TITLE_YEAR_1_GPA])
        [str appendString:[NSString stringWithFormat:@"Year 1: %.3f\n", [Course year1GPA].floatValue]];
    if ([defaults boolForKey:SETTING_CELL_TITLE_YEAR_2_GPA])
        [str appendString:[NSString stringWithFormat:@"Year 2: %.3f\n", [Course year2GPA].floatValue]];
    if ([defaults boolForKey:SETTING_CELL_TITLE_YEAR_3_GPA])
        [str appendString:[NSString stringWithFormat:@"Year 3: %.3f\n", [Course year3GPA].floatValue]];
    if ([defaults boolForKey:SETTING_CELL_TITLE_YEAR_4_GPA])
        [str appendString:[NSString stringWithFormat:@"Year 4: %.3f\n", [Course year4GPA].floatValue]];
    self.footerLabel.text = str;
    
}

- (void) displayDetail {
    [self animateChangeOfConstraint:self.tableViewToLabel toConstant:30+self.footerLabel.frame.size.height withDuration:0.5];
    [self animateView:self.footerLabel transparancyTo:1 duration:0.5];
}

- (void) hideDetail {
    [self animateChangeOfConstraint:self.tableViewToLabel toConstant:30 withDuration:0.5];
    [self animateView:self.footerLabel transparancyTo:0 duration:0.5];
}

#pragma mark Animation
- (void) animateView: (UIView*)view transparancyTo: (float) alpha duration:(float) time {
    [UIView animateWithDuration:time animations:^{
        if (view.alpha != alpha) {
            [view setAlpha:alpha];
        }
    }];
    [UIView commitAnimations];
}

- (void)animateChangeOfConstraint:(NSLayoutConstraint*)constraint toConstant:(float)constant withDuration: (float) duration{
    if (constraint.constant != constant) {
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:2
                            options:0
                         animations:^{
                             constraint.constant = constant;
                             [self animateConstraints];
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

- (void)animateConstraints {
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) configureMotionEffect {
    CGFloat leftRightMin = -20.0f;
    CGFloat leftRightMax = 20.0f;
    
    // Horizontal Motion effect
    UIInterpolatingMotionEffect *leftRight = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    leftRight.minimumRelativeValue = @(leftRightMin);
    leftRight.maximumRelativeValue = @(leftRightMax);
    
    // Vertical Motion effect
    UIInterpolatingMotionEffect *upDown = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    upDown.minimumRelativeValue = @(leftRightMin);
    upDown.maximumRelativeValue = @(leftRightMax);
    
    // Create a motion effect group
    UIMotionEffectGroup *meGrup = [[UIMotionEffectGroup alloc] init];
    meGrup.motionEffects = @[leftRight, upDown];
    
    [self.backgroundImage addMotionEffect:meGrup];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toEditCourse"]) {
        DetailVC *dsvc = segue.destinationViewController;
        dsvc.selectedCourse = self.selectedCourse;
        dsvc.title = @"Edit Course";
        dsvc.editingState = EDIT_EXISTING_COURSE;
    } else if ([segue.identifier isEqualToString:@"toAddCourse"]){
        DetailVC *dsvc = segue.destinationViewController;
        dsvc.editingState = ADDING_NEW_COURSE;
    }
}

- (IBAction)unwindtoTableView:(UIStoryboardSegue *)unwindSegue{
    [self configureGPA];
}

@end
