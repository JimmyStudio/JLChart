//
//  JLBaseChart.h
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ChartAxisType) {
    ChartAxisTypeNone           = 0,
    ChartAxisTypeVertical       = 1 << 0,
    ChartAxisTypeHorizontal     = 1 << 1,
    ChartAxisTypeBoth           = ChartAxisTypeVertical | ChartAxisTypeHorizontal,
    ChartAxisTypeSolid          = 1 << 3,
    ChartAxisTypeDash           = 1 << 4,
};

typedef NS_ENUM(NSUInteger, ChartIndicateLineType) {
    ChartIndicateLineTypeNone           = 0,
    ChartIndicateLineTypeVertical       = 1 << 0,
    ChartIndicateLineTypeHorizontal     = 1 << 1,
    ChartIndicateLineTypeBoth           = ChartIndicateLineTypeVertical | ChartIndicateLineTypeHorizontal,
    ChartIndicateLineTypeSolid          = 1 << 3,
    ChartIndicateLineTypeDash           = 1 << 4,
};
@interface JLBaseChart : UIView

//xLabel
@property (nonatomic, strong) UIFont *xLabelFont;
@property (nonatomic, strong) UIColor *xLabelColor;

//yLabel
@property (nonatomic, strong) UIFont *yLabelFont;
@property (nonatomic, strong) UIColor *yLabelColor;
@property (nonatomic, assign) CGFloat yLabelWidthPadding;
@property (nonatomic, assign, getter=isSignedValue) BOOL signedValue; //+ / -
//@property (nonatomic, copy) NSString *yLabelFormat; 
@property (nonatomic, copy) NSString *yLabelSuffix; //%
@property (nonatomic, assign) NSInteger stepCount;

//marginleft/right
@property (nonatomic, assign) float chartMarginLeft;
@property (nonatomic, assign) float chartMarginRight;
@property (nonatomic, assign) float chartMarginTop;
@property (nonatomic, assign) float chartMarginBottom;

//axis
@property (nonatomic, assign) ChartAxisType axisType;
@property (nonatomic, assign) CGFloat axisWidth;
@property (nonatomic, strong) UIColor *axisColor;

//indicateline
@property (nonatomic, assign) ChartIndicateLineType indicateLineType;
@property (nonatomic, strong) UIColor *indicatePointColor;
@property (nonatomic, strong) UIColor *indicatePointBackColor;

@property (nonatomic, assign) CGFloat xIndicateLineWidth;
@property (nonatomic, strong) UIColor *xIndicateLineColor;
@property (nonatomic, strong) UIFont *xIndicateLabelFont;
@property (nonatomic, strong) UIColor *xIndicateLabelTextColor;
@property (nonatomic, strong) UIColor *xIndicateLabelBackgroundColor;

@property (nonatomic, assign) CGFloat yIndicateLineWidth;
@property (nonatomic, strong) UIColor *yIndicateLineColor;
@property (nonatomic, strong) UIFont *yIndicateLabelFont;
@property (nonatomic, strong) UIColor *yIndicateLabelTextColor;
@property (nonatomic, strong) UIColor *yIndicateLabelBackgroundColor;

//if animated
@property (nonatomic, assign, getter=isDisplayAnimated) BOOL displayAnimated;
@property (nonatomic, assign) CGFloat animateDuration;


@end
