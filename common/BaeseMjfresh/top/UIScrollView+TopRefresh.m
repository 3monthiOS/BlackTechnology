//
//  UIScrollView+TopRefresh.m
//  zhj
//
//  Created by 红军张 on 16/7/26.
//  Copyright © 2016年 红军张. All rights reserved.
//

#import "UIScrollView+TopRefresh.h"
#import "MJRefreshHeader.h"
#import "MJRefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (MJRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end


@implementation UIScrollView (TopRefresh)

#pragma mark - header
static const char MJRefreshHeaderKey = '\0';
- (void)setTop_header:(MJRefreshHeader *)top_header
{
    if (top_header != self.Top_header) {
        // 删除旧的，添加新的
        [self.Top_header removeFromSuperview];
        [self addSubview:top_header];
        [self bringSubviewToFront:top_header];
        
        // 存储新的
        [self willChangeValueForKey:@"mj_header"]; // KVO
        objc_setAssociatedObject(self, &MJRefreshHeaderKey,
                                 top_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"mj_header"]; // KVO
    }
}

- (MJRefreshHeader *)Top_header
{
    return objc_getAssociatedObject(self, &MJRefreshHeaderKey);
}
#pragma mark - 过期

- (void)setHeader:(MJRefreshHeader *)header
{
    self.Top_header = header;
}

- (MJRefreshHeader *)header
{
    return self.Top_header;
}



@end


