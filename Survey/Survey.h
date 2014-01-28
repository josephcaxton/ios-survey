//
//  Survey.h
//  Survey
//
//  Created by György Tóth on 09/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Survey : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *id;

@property (nonatomic, strong) NSArray *descriptor;
@property (nonatomic, strong) NSDictionary *answers;

- (id)initWith:(NSString *)title id:(NSString *)id;

@end
