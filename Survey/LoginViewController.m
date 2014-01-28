//
//  LoginViewController.m
//  Survey
//
//  Created by György Tóth on 08/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "BubbleHTTPClient.h"
#import "SurveyManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.usernameField becomeFirstResponder];
}

#pragma mark - Table view delegate

- (IBAction)login:(id)sender {
    [self.activityIndicator startAnimating];

    BubbleHTTPClient *client = [BubbleHTTPClient sharedClient];
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"1" forKey:@"uid"];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:@"userSurveyList.jsp" parameters:params];

    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        LogDebug(@"response: %@", JSON);

        // TODO: make constant from JSON object key
        [[SurveyManager sharedManager] initWithSurveys:[JSON objectForKey:@"userSurveyList"]];

        [[NSNotificationCenter defaultCenter] postNotificationName:ACTION_UPDATE_STOPPED object:self];

        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        LogError(@"error: %@\n%@", error, JSON);

        NSString *errorMessage =
        [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Error", nil), [error localizedDescription]];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"APP_NAME", nil)
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];

        [alert show];

        [self.activityIndicator stopAnimating];
    }];

    LogInfo(@"request (%@): %@", request.HTTPMethod, request.URL);
    [operation start];
}

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
