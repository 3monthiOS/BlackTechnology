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



@implementation AYScrollerLabel


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:_textLabel];
        _scrollerLabelSize = frame.size;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)setText:(NSString *)text{
    [self ay_setText:text Font:nil];
}

- (void)ay_setText:(NSString *)text Font:(UIFont *)font{
    _text = text;
    _font = font ? font : kDefaultFont;
   
    
    NSString *tempStr = [text stringByAppendingString:text];
    _textLabel.text = tempStr;

    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_font} context:nil].size;
    _textLabel.font = _font;
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height = _scrollerLabelSize.height > size.height ? _scrollerLabelSize.height : size.height;
    self.frame = selfFrame;
    self.contentSize = CGSizeMake(size.width + 2, _scrollerLabelSize.height > size.height ? _scrollerLabelSize.height : size.height);
    _textLabel.frame = CGRectMake(0, 0, size.width + 2, _scrollerLabelSize.height > size.height ? _scrollerLabelSize.height : size.height);
    
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(ay_scrollingLabelAction)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)ay_scrollingLabelAction{
    
    CGPoint point = self.contentOffset;
    if (point.x < self.contentSize.width / 2) {
        point.x += _slidingSpeed ? _slidingSpeed : 1;
    }else{
        point.x = 0;
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
