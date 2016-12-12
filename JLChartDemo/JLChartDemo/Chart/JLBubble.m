//
//  JLBubble.m
//  JLChartDemo
//
//  Created by JimmyLaw on 16/11/27.
//  Copyright © 2016年 JimmyStudio. All rights reserved.
//

#import "JLBubble.h"
#define IndicateColor [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:1.0f]
#define IndicateBackColor [UIColor colorWithRed:238.0f/255.0f green:64.0f/225.0f blue:0.0f alpha:0.4f]
static float magrin = 4;

@interface JLBubble()

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
        _label.font = [UIFont systemFontOfSize:14.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    CGFloat width = rectWidth - 4*2;
    CGFloat height = rectHeight - (4 + 4 + 2 + 4 *2);
    
    CGContextSetFillColorWithColor(ctx, [IndicateColor CGColor]);
    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(4, 4, width, height) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(3.0f, 3.0f)];
    CGContextAddPath(ctx, roundedRectPath.CGPath);
    CGContextFillPath(ctx);
    
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(width, height +4)];
    [trianglePath addLineToPoint:CGPointMake(width + 4, height +4)];
    [trianglePath addLineToPoint:CGPointMake(width + 4, height +4 +4)];
    [trianglePath closePath];
    CGContextAddPath(ctx, trianglePath.CGPath);
    CGContextFillPath(ctx);
    
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rectWidth - 4, rectHeight -4) radius:2.0f startAngle:0 endAngle:M_PI *2 clockwise:YES];
    CGContextAddPath(ctx, roundPath.CGPath);
    CGContextFillPath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [IndicateBackColor CGColor]);
    UIBezierPath *roundBackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rectWidth - 4, rectHeight -4) radius:4.0f startAngle:0 endAngle:M_PI *2 clockwise:YES];
    CGContextAddPath(ctx, roundBackPath.CGPath);
    CGContextFillPath(ctx);
}


- (void)showWithPoint:(CGPoint)point Content:(NSString *)content{
    
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil]
                                            context:nil];
    CGFloat width = textRect.size.width + magrin *2;
    CGFloat height = textRect.size.height + magrin *2;
    CGFloat x = point.x - (width + 4 );
    CGFloat y = point.y - (height + 4 + 4 + 2 + 4);
    CGFloat rectWidth = width + 4*2;
    CGFloat rectHeight = height + 4 + 4 + 2 + 4 *2;
    self.frame = CGRectMake(x, y, rectWidth, rectHeight);
    
    self.label.frame = CGRectMake(magrin, 4 +magrin, rectWidth -magrin *2, rectHeight - 4 -4-2-4*2 -magrin*2);
    _label.text = content;
    [self setNeedsDisplay];
}

@end
