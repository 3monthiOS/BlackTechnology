//
//  UIButton+Swift.m
//  aha
//
//  Created by feng will on 15/12/17.
//  Copyright © 2015年 Ledong. All rights reserved.
//


#import "UIButton+Swift.h"

@implementation UIButton (Swift)
+ (instancetype)appearanceWhenContainedWithin:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedIn:containerClass, nil];
}
@end
