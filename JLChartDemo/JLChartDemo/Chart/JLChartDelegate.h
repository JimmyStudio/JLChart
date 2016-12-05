//
//  JLChartDelegate.h
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JLChartPointItem;
@protocol JLChartDelegat <NSObject>
@optional

- (void)didClickedOnChartAtIndex:(NSInteger )index withChartPointItem:(JLChartPointItem *)chartPointItem;

@end

