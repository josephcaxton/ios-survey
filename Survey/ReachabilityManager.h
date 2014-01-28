//
//  ReachabilityManager.h
//  Survey
//
//  Created by György Tóth on 10/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReachabilityManager : NSObject

+ (ReachabilityManager *)sharedManager;

- (int)networkStatus;

- (int)serviceStatus;

@end
