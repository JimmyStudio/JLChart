//
//  JLBubble.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/9/29.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import "JLBubble.h"
#define IndicateColor [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:1.0f]
#define IndicateBackColor [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:0.4f]
static float magrin = 5.0f;

@interface JLBubble()

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) UILabel *label;


@end


@implementation JLBubble
- (instancetype)init{
    if ( self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:12.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}


- (void)showWithPoint:(CGPoint)point Content:(NSString *)content{
    _content = content;
    _point = point;
    CGRect textRect = [_content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]
                                             context:nil];
    CGFloat width = textRect.size.width + magrin *2;
    CGFloat height = textRect.size.height + magrin *2;
    CGFloat x = _point.x - (width + 4.0f );
    CGFloat y = _point.y - (height + 4.0f + 4.0f + 2.0f + 4.0f);
    CGFloat rectWidth = width + 4*2;
    CGFloat rectHeight = height + 4.0f + 4.0f + 2.0f + 4.0f *2;
    
    CAShapeLayer *roundRect = [CAShapeLayer layer];
    roundRect.frame = self.bounds;
    roundRect.lineCap = kCALineCapRound;
    roundRect.lineJoin = kCALineJoinBevel;
    roundRect.fillColor = IndicateColor.CGColor;
    roundRect.strokeColor = nil;
    [self.layer addSublayer:roundRect];
    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(4.0f, 4.0f, width, height) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(2.0f, 2.0f)];
    roundRect.path = roundedRectPath.CGPath;
    
    CAShapeLayer *triangle = [CAShapeLayer layer];
    triangle.frame = self.bounds;
    triangle.lineCap = kCALineCapRound;
    triangle.lineJoin = kCALineJoinBevel;
    triangle.fillColor = IndicateColor.CGColor;
    triangle.strokeColor = nil;
    [self.layer addSublayer:triangle];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(width, height +4.0f)];
    [trianglePath addLineToPoint:CGPointMake(width + 4.0f, height +4.0f)];
    [trianglePath addLineToPoint:CGPointMake(width + 4.0f, height +4.0f +4.0f)];
    [trianglePath closePath];
    triangle.path = trianglePath.CGPath;
    
    CAShapeLayer *round = [CAShapeLayer layer];
    round.frame = self.bounds;
    round.lineCap = kCALineCapRound;
    round.lineJoin = kCALineJoinBevel;
    round.fillColor = IndicateColor.CGColor;
    round.strokeColor = nil;
    [self.layer addSublayer:round];
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rectWidth - 4.0f, rectHeight -4.0f) radius:2.0f startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
    round.path = roundPath.CGPath;
    
    CAShapeLayer *roundBack = [CAShapeLayer layer];
    roundBack.frame = self.bounds;
    roundBack.lineCap = kCALineCapRound;
    roundBack.lineJoin = kCALineJoinBevel;
    roundBack.fillColor = IndicateBackColor.CGColor;
    roundBack.strokeColor = nil;
    [self.layer addSublayer:roundBack];
    UIBezierPath *roundBackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rectWidth - 4.0f, rectHeight -4.0f) radius:4.0f startAngle:0.0f endAngle:M_PI *2.0f clockwise:YES];
    roundBack.path = roundBackPath.CGPath;
    
    
    self.frame = CGRectMake(x, y, rectWidth, rectHeight);
    self.label.frame = CGRectMake(magrin, 4.0f +magrin, rectWidth -magrin *2.0f, rectHeight - 4.0f -4.0f-2.0f-4.0f*2 -magrin*2);
    _label.text = content;
    [self setNeedsDisplay];
}

@end
