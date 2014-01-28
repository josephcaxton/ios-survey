//
//  Survey.m
//  Survey
//
//  Created by György Tóth on 09/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "Survey.h"

@implementation Survey

- (id)initWith:(NSString *)title id:(NSString *)id {
    self = [super init];

    if (self) {
        _title = [title copy];
        _id = [id copy];
    }

    return self;
}

@end
