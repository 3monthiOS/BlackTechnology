//
//  AYScrollerLabel.h
//  AYScrollerLabel_OC
//
//  Created by Andy on 2017/6/1.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYScrollerLabel : UIScrollView


/**
 显示的文字
 */
@property (nonatomic , strong )NSString *text;


/**
 字体
 */
@property (nonatomic , strong , readonly)UIFont *font;


/**
 背景
 */
@property (nonatomic , strong)UIColor *bgColor;


/**
 字体颜色
 */
@property (nonatomic , strong)UIColor *textColor;


/**
 每帧移动距离
 */
@property (nonatomic , assign)CGFloat slidingSpeed;

/**
 设置控件值

 @param text 显示文字
 @param font 字体
 */
- (void)ay_setText:(NSString*)text Font:(UIFont *)font;

/**
 开启暂停滚动

 @param paused 滚动状态
 */
- (void)ay_setPaused:(BOOL)paused;

@end
