//
//  SurveyListViewController.m
//  Survey
//
//  Created by György Tóth on 08/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "SurveyListViewController.h"
#import "LoginViewController.h"
#import "MasterViewController.h"
#import "SurveyManager.h"
#import "Survey.h"

@interface SurveyListViewController () <LoginDismissDelegate>

@property (nonatomic, strong) NSArray *surveys;

@end

@implementation SurveyListViewController

- (void)awakeFromNib {
    _surveys = [[SurveyManager sharedManager] surveys];

    [super awakeFromNib];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.surveys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Survey *survey = [self.surveys objectAtIndex:indexPath.row];
    
    cell.textLabel.text = survey.title;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"formSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - LoginDismissDelegate

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)setup {
//    self.surveys = [[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_SURVEYS] copy];
//    LogDebug("SURVEYS: %@", self.surveys);
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"formSegue" isEqualToString:[segue identifier]]) {
        MasterViewController *formViewController = segue.destinationViewController;

        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        [formViewController setupForm:[self.surveys objectAtIndex:indexPath.row]];
    }
}

@end
