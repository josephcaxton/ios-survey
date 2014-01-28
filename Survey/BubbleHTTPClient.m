//
//  BubbleHTTPClient.m
//  Buildings
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "BubbleHTTPClient.h"

@implementation BubbleHTTPClient

+ (BubbleHTTPClient *)sharedClient {
    static BubbleHTTPClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8080/BBCHRAPI", BUBBLE_HOST]];
        LogInfo(@"bubbleclient inited with URL: %@", url);
        sharedClient = [[BubbleHTTPClient alloc] initWithBaseURL:url];
    });

    return sharedClient;
}

@end
