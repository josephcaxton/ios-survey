//
//  FreeTextCell.m
//  Survey
//
//  Created by György Tóth on 01/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "FreeTextCell.h"
#import <QuartzCore/QuartzCore.h>

@interface FreeTextCell () <UITextViewDelegate>

@end

@implementation FreeTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect answerFrame = CGRectMake(0,
                                        0,
                                        CGRectGetWidth(self.contentView.frame),
                                        CGRectGetHeight(self.contentView.frame));

        _answerTextView = [[UITextView alloc] initWithFrame:CGRectInset(answerFrame, 10.0f, 14.0f)];
        _answerTextView.backgroundColor = [UIColor clearColor];
        _answerTextView.autoresizingMask =
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _answerTextView.delegate = self;
        
        _answerTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _answerTextView.layer.borderWidth = 1.0f;

        [self.contentView addSubview:_answerTextView];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

- (void)reset {
    self.answerTextView.text = @"";
}

@end
