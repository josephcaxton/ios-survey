//
//  LoginViewController.h
//  Survey
//
//  Created by György Tóth on 08/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDismissDelegate <NSObject>

- (void)dismiss;

@end

@interface LoginViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) id<LoginDismissDelegate> delegate;

@end
