//
//  UIScrollView+TopRefresh.h
//  zhj
//
//  Created by 红军张 on 16/7/26.
//  Copyright © 2016年 红军张. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJRefreshHeader, MJRefreshFooter;
@interface UIScrollView (TopRefresh)


/** 下拉刷新控件 */
@property (strong, nonatomic) MJRefreshHeader *Top_header;

@end

