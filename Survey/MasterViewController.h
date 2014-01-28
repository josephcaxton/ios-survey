//
//  MasterViewController.h
//  Survey
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Survey;

@interface MasterViewController : UIViewController

- (void)setupForm:(Survey *)survey;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)resetSurvey:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
