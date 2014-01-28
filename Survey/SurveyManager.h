//
//  SurveyManager.h
//  Survey
//
//  Created by György Tóth on 09/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyManager : NSObject

+ (SurveyManager *)sharedManager;

- (void)initWithSurveys:(NSArray *)surveyData;

- (void)setSurveyDescriptor:(NSArray *)desctriptor to:(NSString *)surveyId;
- (void)setAnswers:(NSDictionary *)answers to:(NSString *)surveyId;

- (NSArray *)surveys;

@end
