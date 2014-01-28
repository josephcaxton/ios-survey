//
//  BubbleHTTPClient.h
//  Buildings
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "AFHTTPClient.h"

@interface BubbleHTTPClient : AFHTTPClient

+ (BubbleHTTPClient *)sharedClient;

@end
