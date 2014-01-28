//
//  RadioCell.h
//  Survey
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioCell : UITableViewCell

@property (nonatomic, readonly) UIButton *button;

- (void)setOptions:(NSArray *)option;

- (void)reset;

@end
