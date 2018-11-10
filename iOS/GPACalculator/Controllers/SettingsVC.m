//
//  SettingsVC.m
//  GPACalculator
//
//  Created by Xiao on 8/5/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import "Course.h"
#import "SettingsVC.h"
#import "Macros.h"
#import "SettingCell.h"
#import "TextFieldCell.h"

@interface SettingsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *settingsTitles;
@end

@implementation SettingsVC

- (IBAction)didTapSwitch:(id)sender {
    UISwitch *customSwitch = (UISwitch*) sender;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:customSwitch.isOn forKey:self.settingsTitles[customSwitch.tag]];
    [defaults synchronize];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.settingsTitles.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell;
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"officialCell"];
        cell.textLabel.text = @"NYUAD Official GPA";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.3f\n", [Course GPA].floatValue];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
        cell.titleLabel.text = self.settingsTitles[indexPath.row];
        cell.customSwitch.tag = indexPath.row;
        cell.customSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:self.settingsTitles[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Utilities
- (NSArray *)settingsTitles {
    if (!_settingsTitles) {
        _settingsTitles = @[SETTING_CELL_TITLE_CUMULATIVE_GPA, SETTING_CELL_TITLE_MAJOR_GPA, SETTING_CELL_TITLE_YEAR_1_GPA, SETTING_CELL_TITLE_YEAR_2_GPA, SETTING_CELL_TITLE_YEAR_3_GPA, SETTING_CELL_TITLE_YEAR_4_GPA, SETTING_CELL_TITLE_CREDIT];
    }
    return _settingsTitles;
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
