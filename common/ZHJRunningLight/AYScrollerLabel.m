//
//  AYScrollerLabel.m
//  AYScrollerLabel_OC
//
//  Created by Andy on 2017/6/1.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import "AYScrollerLabel.h"

#define kDefaultFont [UIFont systemFontOfSize:15]

@interface AYScrollerLabel ()

@property (nonatomic , strong)UILabel *textLabel;

@property (nonatomic , assign)CGSize scrollerLabelSize;

@property (nonatomic , strong)CADisplayLink *displayLink;

@end

@implementation AYScrollerLabel {
    CGSize labelSize;
    int self_w;  // 暂时的一个宽度
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)setText:(NSString *)text{
    [self ay_setText:text Font:nil];
}
-(void)addTxtLabel:(NSString*)title {
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    for (int i = 0; i<3; i++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self_w > labelSize.width ? 0 : i == 2 ? (labelSize.width + self_w): (i*labelSize.width + self_w/2), 0, self_w > labelSize.width ? self_w : i == 1 ? self_w/2 :labelSize.width, self.frame.size.height)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = _font;
        if (i == 1) {
            textLabel.textColor = [UIColor clearColor];
        } else {
            textLabel.textColor = _textColor;
        }
        textLabel.text = _text;
        [self addSubview:textLabel];
    }
    _scrollerLabelSize = self.frame.size;
}
- (void)ay_setText:(NSString *)text Font:(UIFont *)font{
    self_w = (UIScreen.mainScreen.bounds.size.width - 24 - 24)/4 - 8;
    _text = text;
    _font = font ? font : kDefaultFont;
    labelSize = [_text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_font} context:nil].size;
    CGSize labelSizeFrame = labelSize;
    labelSizeFrame.width = labelSizeFrame.width + 6;
    labelSize = labelSizeFrame;
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height = _scrollerLabelSize.height > labelSize.height ? _scrollerLabelSize.height : labelSize.height;
    self.frame = selfFrame;
    
    if (!_textLabel) {[self addTxtLabel:text];}

    self.contentSize = CGSizeMake(self_w > labelSize.width? self_w : labelSize.width*2 + self_w, selfFrame.size.height);
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(ay_scrollingLabelAction)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    if (self_w >= labelSize.width) {
        _displayLink.paused = true;
    } else {
        _displayLink.paused = false;
    }
}

- (void)ay_scrollingLabelAction{
    
    CGPoint point = self.contentOffset;
    if (point.x < labelSize.width + self_w/2) {
        point.x += _slidingSpeed ? _slidingSpeed : 1;
    }else{
        point.x = 1;
    }
    self.contentOffset = point;
}


- (void)ay_setPaused:(BOOL)paused{
    _displayLink.paused = paused;
}

- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _textLabel.textColor = textColor;
}

- (void)dealloc{
    [_displayLink invalidate];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

@end
