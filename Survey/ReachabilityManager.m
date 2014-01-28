//
//  ReachabilityManager.m
//  Survey
//
//  Created by György Tóth on 10/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *sharedManager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[ReachabilityManager alloc] init];
    });

    return sharedManager;
}

- (int)networkStatus {
    return 0;
}

- (int)serviceStatus {
    return 0;
}

@end
