//
//  SRChatInputToolBar.m
//  SRWebSocketChat
//
//  Created by xuran on 16/6/23.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

static const CGFloat InputTextViewMinHeight = 30.0;
static const CGFloat InputTextViewMaxHeight = 60.0;
static const CGFloat InputTextViewTopInsert = 8.0;

#import "SRChatInputToolBar.h"

@interface SRChatInputToolBar ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView * inputTextView;

@end

@implementation SRChatInputToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorWithRGB(244, 244, 244);
        
        [self addSubview:self.inputTextView];
    }
    return self;
}

- (UITextView *)inputTextView
{
    if (nil == _inputTextView) {
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(50.0, InputTextViewTopInsert, self.es_width - 80.0, InputTextViewMinHeight)];
        _inputTextView.backgroundColor = ColorWithRGB(252, 252, 252);
        _inputTextView.layer.cornerRadius = 5.0;
        _inputTextView.layer.borderColor = ColorWithRGB(234, 234, 234).CGColor;
        _inputTextView.layer.borderWidth = 1.0;
        _inputTextView.font = [UIFont systemFontOfSize:16.0];
        _inputTextView.textColor = [UIColor blackColor];
        _inputTextView.textAlignment = NSTextAlignmentJustified;
        _inputTextView.delegate = self;
        _inputTextView.returnKeyType = UIReturnKeySend;
    }
    return _inputTextView;
}

- (void)setFrame:(CGRect)frame animated:(BOOL)animated
{
    CGRect textViewFrame = self.inputTextView.frame;
    textViewFrame.size.height = frame.size.height - InputTextViewTopInsert * 2.0;
    
    __weak __typeof(self) weakSelf = self;
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            weakSelf.frame = frame;
            weakSelf.inputTextView.frame = textViewFrame;
        } completion:^(BOOL finished) {
            [self layoutIfNeeded];
        }];
    }
    else {
        self.frame = frame;
        self.inputTextView.frame = textViewFrame;
        [self layoutIfNeeded];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect textViewFrame = textView.frame;
    CGSize textSize = [textView sizeThatFits:CGSizeMake(textView.es_width, 0)];
    CGFloat offSet = InputTextViewTopInsert;
    textView.scrollEnabled = (textSize.height > InputTextViewMaxHeight - offSet);
    textViewFrame.size.height = MAX(34.0, MIN(InputTextViewMaxHeight, textSize.height));
    CGFloat barHeight = textViewFrame.size.height + InputTextViewTopInsert * 2.0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatInputToolBar:didReciveBarHeightChanged:)]) {
        [self.delegate chatInputToolBar:self didReciveBarHeightChanged:barHeight];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"] && range.length == 0) {
        NSLog(@"发送");
        return NO;
    }
    else if ([text isEqualToString:@""] && range.length == 1) {
        NSLog(@"删除");
        return YES;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

@end
