//
//  CheckboxCell.m
//  Survey
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "CheckboxCell.h"
#import "M13Checkbox.h"

@interface CheckboxCell ()

@end

@implementation CheckboxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat checkboxHeight = 26.0f;
        CGRect checkboxFrame =  CGRectMake(8.0f,
                                           CGRectGetMidY(self.contentView.frame) - checkboxHeight / 2.0f,
                                           checkboxHeight,
                                           checkboxHeight);

        _checkbox = [[M13Checkbox alloc] initWithFrame:checkboxFrame];
        _checkbox.flat = YES;
        [_checkbox addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];

        CGRect optionFrame = CGRectMake(CGRectGetMaxX(_checkbox.frame) + 8.0f,
                                        0,
                                        CGRectGetWidth(self.contentView.frame) - (CGRectGetWidth(_checkbox.frame) + 2 * 8.0f),
                                        CGRectGetHeight(self.contentView.frame));
        _optionLabel = [[UILabel alloc] initWithFrame:optionFrame];
        _optionLabel.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:_checkbox];
        [self.contentView addSubview:_optionLabel];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)reset {
    [self.checkbox setCheckState:M13CheckboxStateUnchecked];
}

@end
