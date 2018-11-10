//
//  NavigationController.m
//  GPACalculator
//
//  Created by Xiao on 8/4/16.
//  Copyright © 2016 Xiao Lu. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

@end
