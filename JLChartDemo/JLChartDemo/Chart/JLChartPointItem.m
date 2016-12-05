//
//  JLChartDataItem.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import "JLChartPointItem.h"
@interface JLChartPointItem()

@property (nonatomic, copy, readwrite) NSString *rawX;
@property (nonatomic, copy, readwrite) NSString *rawY;

@end

@implementation JLChartPointItem

+ (instancetype)pointItemWithRawX:(NSString *)rawx andRowY:(NSString *)rowy{
    return [[JLChartPointItem alloc]initWithX:rawx andY:rowy];
}

#pragma mark -init
- (id)initWithX:(NSString *)x andY:(NSString *)y{
    if (self = [super init]) {
        self.rawX = x;
        self.rawY = y;
    }
    return self;
}

@end
