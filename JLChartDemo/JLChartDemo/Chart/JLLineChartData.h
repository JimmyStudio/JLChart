//
//  JLLineChartData.h
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JLChartPointSet.h"

@interface JLLineChartData : NSObject

//data
@property (nonatomic, strong) NSMutableArray <JLChartPointSet *> *sets;

//line
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

//fillColor
@property (nonatomic, strong) UIColor *fillColor;

//smooth
@property (nonatomic, assign, getter=isShowSmooth) BOOL showSmooth;

@end
