//
//  CourseCell.h
//  GPACalculator
//
//  Created by Xiao on 7/20/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *termLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@end
