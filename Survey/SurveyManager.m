//
//  SurveyManager.m
//  Survey
//
//  Created by György Tóth on 09/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "SurveyManager.h"
#import "Survey.h"

@implementation SurveyManager

+ (SurveyManager *)sharedManager {
    static SurveyManager *sharedManager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[SurveyManager alloc] init];
    });

    return sharedManager;
}

/*
 surveyData:
 [
    {
        "1": "Survey"
    },
    ...
 ]
 */
- (void)initWithSurveys:(NSArray *)surveyData {
    NSMutableDictionary *surveys = [[NSMutableDictionary alloc] initWithCapacity:[surveyData count]];

    for (NSDictionary *eachSurveyData in surveyData) {
        NSString *surveyId = [[eachSurveyData allKeys] objectAtIndex:0];
        NSString *surveyTitle = [[eachSurveyData allValues] objectAtIndex:0];

        NSDictionary *survey = [NSDictionary dictionaryWithObjectsAndKeys:
                                surveyId, @"surveyId",
                                surveyTitle, @"surveyTitle", nil];

        [surveys setObject:survey forKey:surveyId];
    }

    [[NSUserDefaults standardUserDefaults] setObject:surveys forKey:SETTINGS_SURVEYS];
}

- (NSArray *)surveys {
    NSDictionary *storedSurveys = [[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_SURVEYS];

    NSMutableArray *surveys = [NSMutableArray arrayWithCapacity:[[storedSurveys allKeys] count]];
    for (NSString *eachStoredSurveyId in [storedSurveys allKeys]) {
        NSDictionary *eachStoredSurvey = [storedSurveys objectForKey:eachStoredSurveyId];

        NSString *surveyName = [eachStoredSurvey objectForKey:@"surveyTitle"];

        Survey *survey = [[Survey alloc] initWith:surveyName id:eachStoredSurveyId];
        survey.descriptor = [eachStoredSurvey objectForKey:@"userSurvey"];
        survey.answers = [eachStoredSurvey objectForKey:@"answers"];

        [surveys addObject:survey];
    }

    return [NSArray arrayWithArray:surveys];
}

- (void)setSurveyDescriptor:(NSArray *)desctriptor to:(NSString *)surveyId {
    NSMutableDictionary *surveys =
    [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_SURVEYS]];

    NSMutableDictionary *survey = [NSMutableDictionary dictionaryWithDictionary:[surveys objectForKey:surveyId]];

    [survey setObject:desctriptor forKey:@"userSurvey"];

    [[NSUserDefaults standardUserDefaults] setObject:surveys forKey:SETTINGS_SURVEYS];
}

- (void)setAnswers:(NSDictionary *)answers to:(NSString *)surveyId {
    NSMutableDictionary *surveys =
    [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_SURVEYS]];

    NSMutableDictionary *survey = [NSMutableDictionary dictionaryWithDictionary:[surveys objectForKey:surveyId]];

    [survey setObject:answers forKey:@"userSurvey"];

    [[NSUserDefaults standardUserDefaults] setObject:surveys forKey:SETTINGS_SURVEYS];

}

- (NSDictionary *)surveyForId:(NSString *)surveyId {
    NSArray *surveys = [[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_SURVEYS];
    NSDictionary *res = nil;

    for (NSDictionary *eachSurvey in surveys) {
        if ([[eachSurvey objectForKey:@"id"] isEqualToString:surveyId]) {
            res = eachSurvey;
            break;
        }
    }

    return res;
}

@end
