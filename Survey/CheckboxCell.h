//
//  CheckboxCell.h
//  Survey
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class M13Checkbox;

@interface CheckboxCell : UITableViewCell

@property (nonatomic, readonly) M13Checkbox *checkbox;
@property (nonatomic, readonly) UILabel *optionLabel;

- (void)reset;

@end
