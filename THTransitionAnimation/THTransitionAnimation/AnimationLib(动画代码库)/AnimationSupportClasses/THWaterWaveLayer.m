//
//  THWaterWaveLayer.m
//  THTransationDemo
//
//  Created by litianhao on 16/5/8.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THWaterWaveLayer.h"


@implementation THWaterWaveLayer
{
    UIColor *_currentWaterColor;
    float _currentLinePointY;
    float a;
    float b;
    
    BOOL jia;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor redColor].CGColor];
        
        a = 1.5;
        b = 0;
        jia = NO;
        
        _currentWaterColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1];
        _currentLinePointY = -30;
        
       _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateWave)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    return self;
}

-(void)animateWave
{
    if (jia) {
        a += 0.1;
    }else{
        a -= 0.1;
    }
    
    
    if (a<= 1) {
        jia = YES;
    }
    
    if (a>=5) {
        jia = NO;
    }
    
    
    b+= 0.1;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    //画水
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    float y=_currentLinePointY;
    [path moveToPoint:CGPointMake(0, y)];
    for(float x=0;x<=[UIScreen mainScreen].bounds.size.width;x++){
        y= a * sin( x/180*M_PI + 4*b/M_PI ) * 5 + _currentLinePointY;
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [path addLineToPoint:CGPointMake(0, rect.size.height)];
    [path addLineToPoint:CGPointMake(0, _currentLinePointY)];
    
    self.path = path.CGPath;
    
}

- (void)removeFromSuperlayer
{
    [_displayLink invalidate];
    [super removeFromSuperlayer];
}

- (void)dealloc
{
    NSLog(@"水波layer  销毁");
}

@end
