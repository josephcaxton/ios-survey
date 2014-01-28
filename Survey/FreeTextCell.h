//
//  FreeTextCell.h
//  Survey
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeTextCell : UITableViewCell

@property (nonatomic, readonly) UITextView *answerTextView;

- (void)reset;

@end
