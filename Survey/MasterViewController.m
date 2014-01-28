//
//  MasterViewController.m
//  Survey
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "MasterViewController.h"
#import "FreeTextCell.h"
#import "QuestionCell.h"
#import "CheckboxCell.h"
#import "RadioCell.h"
#import "M13Checkbox.h"
#import "AFNetworking.h"
#import "BubbleHTTPClient.h"
#import "Survey.h"

@interface MasterViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *formElems;
@property (nonatomic, strong) NSMutableDictionary *checkboxGroups;
@property (nonatomic, strong) Survey *survey;

@end

@implementation MasterViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSDictionary *state = [[NSUserDefaults standardUserDefaults] objectForKey:@"state"];
    if (state) {
        [self setupFromState:state];
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.formElems count]
            + 1; // submit button
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.tableView.numberOfSections - 1) {
        return 1;
    } else {
        return [[self.formElems objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == tableView.numberOfSections - 1) {
        UITableViewCell *submitCell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        submitCell.textLabel.textAlignment = NSTextAlignmentCenter;
        submitCell.textLabel.text = NSLocalizedString(@"Submit", nil);

        return submitCell;
    } else {
        return [[self.formElems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // submit row
    if (indexPath.section == [tableView numberOfSections] - 1) {
        return 44.0f;
    }

    // question row
    if (indexPath.row == 0) {
        return 88.0f;
    }

    if ([[[self.formElems objectAtIndex:indexPath.section] objectAtIndex:1] isKindOfClass:[FreeTextCell class]]) {
        return 88.0f;
    }

    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [tableView numberOfSections] - 1) {
        [self submit];
    }
}

#pragma mark - 

- (void)setupForm:(Survey *)survey {
    self.survey = survey;
    self.title = survey.title;

    if (survey.descriptor) {
        [self setupFormFromDescriptor:survey.descriptor];
    } else {
        [self.activityIndicator startAnimating];

        BubbleHTTPClient *client = [BubbleHTTPClient sharedClient];
        NSDictionary *params = [NSDictionary dictionaryWithObject:survey.id forKey:@"surveyID"];
        NSURLRequest *request = [client requestWithMethod:@"GET" path:@"userSurvey.jsp" parameters:params];

        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

            [self setupFormFromDescriptor:[JSON objectForKey:@"userSurvey"]];
            [self.tableView reloadData];


            [self.activityIndicator stopAnimating];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            LogError(@"error: %@\n%@", error, JSON);

            NSString *errorMessage =
            [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Error downloading survey", nil),
             [error localizedDescription]];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"APP_NAME", nil)
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];

            [alert show];

            [self.activityIndicator stopAnimating];
        }];

        [operation start];
    }
}

- (void)setupFormFromDescriptor:(NSArray *)descriptor {
    self.formElems = [[NSMutableArray alloc] init];

    for (NSDictionary *eachElemDesc in descriptor) {
        QuestionCell *questionCell =
        [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        questionCell.textLabel.numberOfLines = 2;
        questionCell.textLabel.text = [eachElemDesc objectForKey:@"Question"];
        questionCell.questionId = [NSNumber numberWithInt:[[eachElemDesc objectForKey:@"QuestionID"] intValue]];

        NSString *elemType = [eachElemDesc objectForKey:@"Type"];
        if ([@"Freetext" isEqualToString:elemType]) {
            FreeTextCell *freetextCell =
            [[FreeTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

            [self.formElems addObject:@[questionCell, freetextCell]];
        } else if ([@"Checkbox" isEqualToString:elemType]) {
            NSMutableArray *elems = [NSMutableArray arrayWithObject:questionCell];

            NSArray *options = [[eachElemDesc objectForKey:@"Options"] componentsSeparatedByString:@"/"];
            for (NSString *eachOption in options) {
                CheckboxCell *checkboxCell =
                [[CheckboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

                checkboxCell.optionLabel.text = eachOption;

                [elems addObject:checkboxCell];
            }

            [self.formElems addObject:elems];
        } else if ([@"Radio" isEqualToString:elemType]) {
            RadioCell *radioCell = [[RadioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            NSArray *options = [[eachElemDesc objectForKey:@"Options"] componentsSeparatedByString:@"/"];
            [radioCell setOptions:options];
            
            [self.formElems addObject:@[questionCell, radioCell]];
        }
    }
}

- (IBAction)resetSurvey:(id)sender {
    UIAlertView *resetAlert =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reset", nil)
                               message:NSLocalizedString(@"This will discard all changes. Are you sure you want to continue?", nil)
                              delegate:self
                     cancelButtonTitle:NSLocalizedString(@"No", nil)
                     otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];

    [resetAlert show];
}

- (void)submit {
    NSDictionary *surveyState = [self surveyState];

    LogDebug(@"submit: %@", [surveyState class]);

    [[NSUserDefaults standardUserDefaults] setObject:surveyState forKey:@"state"];
}

- (NSDictionary *)surveyState {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];

    for (NSArray *eachFormElem in self.formElems) {
        QuestionCell *questionCell = [eachFormElem objectAtIndex:0];

        if ([[eachFormElem objectAtIndex:1] isKindOfClass:[FreeTextCell class]]) {
            FreeTextCell *freetextCell = [eachFormElem objectAtIndex:1];

            LogDebug(@"Freeeeee: %@", [questionCell.questionId class]);
            [json setObject:freetextCell.answerTextView.text forKey:[questionCell.questionId stringValue]];
        } else if ([[eachFormElem objectAtIndex:1] isKindOfClass:[RadioCell class]]) {
            RadioCell *radioCell = [eachFormElem objectAtIndex:1];

            [json setObject:radioCell.button.titleLabel.text forKey:[questionCell.questionId stringValue]];
        } else if ([[eachFormElem objectAtIndex:1] isKindOfClass:[CheckboxCell class]]) {
            NSMutableArray *answers = [[NSMutableArray alloc] init];

            for (CheckboxCell *eachCheckboxCell in eachFormElem) {
                if (eachCheckboxCell.checkbox.checkState == M13CheckboxStateChecked) {
                    [answers addObject:eachCheckboxCell.optionLabel.text];
                }
            }

            [json setObject:[answers componentsJoinedByString:@", "] forKey:[questionCell.questionId stringValue]];
        }
    }
    
    LogDebug(@"submit:\n%@", json);

    return json;
}

- (void)setupFromState:(NSDictionary *)state {
    for (id eachQuestionId in [state allKeys]) {
        for (NSArray *eachQuestion in self.formElems) {
            if ([[[[eachQuestion objectAtIndex:0] questionId] stringValue] isEqualToString:eachQuestionId]) {
                [self setAnswer:[state objectForKey:eachQuestionId] forCell:eachQuestion];
            }
        }
    }
}

- (void)setAnswer:(NSString *)answer forCell:(NSArray *)answerCells {
    UITableViewCell *answerCell = [answerCells objectAtIndex:1];

    if ([answerCell isKindOfClass:[FreeTextCell class]]) {
        FreeTextCell *freeTextCell = (FreeTextCell *)answerCell;

        freeTextCell.answerTextView.text = answer;
    } else if ([answerCell isKindOfClass:[RadioCell class]]) {
        RadioCell *radioCell = [answerCells objectAtIndex:1];

        [radioCell.button setTitle:answer forState:UIControlStateNormal];
    } else if ([answerCell isKindOfClass:[CheckboxCell class]]) {
        for (int i = 1; i < [answerCells count] - 1; i++) {
            CheckboxCell *eachCheckboxCell = [answerCells objectAtIndex:i];

            [eachCheckboxCell.checkbox setCheckState:M13CheckboxStateUnchecked];
            if ([eachCheckboxCell.optionLabel.text isEqualToString:answer]) {
                [eachCheckboxCell.checkbox setCheckState:M13CheckboxStateChecked];
            }
        }
    }
}

#pragma mark - Actions

- (void)refreshSurvey:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"1" forKey:@"surveyID"];

    NSURLRequest *request = [[BubbleHTTPClient sharedClient] requestWithMethod:@"GET"
                                                                          path:@"userSurvey.jsp"
                                                                    parameters:params];

    LogInfo(@"request (%@): %@", request.HTTPMethod, request.URL);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        LogDebug(@"response: %@", JSON);

        [self setupForm:[JSON objectForKey:@"userSurvey"]];
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        LogError(@"Error: %@\n%@", error, JSON);
    }];

    [operation start];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        for (NSArray *eachQuestion in self.formElems) {
            [eachQuestion makeObjectsPerformSelector:@selector(reset)];
        }
    }
}

@end
