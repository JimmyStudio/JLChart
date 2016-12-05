//
//  JLChartDataItem.h
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JLChartPointItem : NSObject

+ (instancetype)pointItemWithRawX:(NSString *)rawx andRowY:(NSString *)rowy;

@property (nonatomic, copy, readonly) NSString *rawX;
@property (nonatomic, copy, readonly) NSString *rawY;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end
