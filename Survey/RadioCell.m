//
//  RadioCell.m
//  Survey
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "RadioCell.h"
#import "ActionSheetStringPicker.h"

@interface RadioCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *options;

@end

@implementation RadioCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = self.contentView.bounds;
        _button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTitle:@"Select" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:_button];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOptions:(NSArray *)options {
    _options = [NSArray arrayWithArray:options];

    [self.button setTitle:[self.options objectAtIndex:0] forState:UIControlStateNormal];
}

#pragma mark - UIPickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_options count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_options objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    LogDebug(@"picker row selected: %d", row);
    [self.button setTitle:[self.options objectAtIndex:row] forState:UIControlStateNormal];
}

#pragma mark - Actions

- (void)showPicker:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select"
                                            rows:self.options
                                initialSelection:0
                                          target:self
                                   successAction:@selector(didSelectRow:)
                                    cancelAction:nil
                                          origin:self];
}

- (void)didSelectRow:(NSNumber *)row {
    [self.button setTitle:[self.options objectAtIndex:[row intValue]] forState:UIControlStateNormal];
}

- (void)reset {
    [self.button setTitle:[self.options objectAtIndex:0] forState:UIControlStateNormal];
}

@end
