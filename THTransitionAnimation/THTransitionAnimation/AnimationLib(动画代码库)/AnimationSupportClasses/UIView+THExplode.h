//
//  UIView+THExplode.h
//  THTransitionAnimation
//
//  Created by litianhao on 16/7/5.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

typedef void(^ExplodeCompletion)(void);

@interface UIView (THExplode)

@property (nonatomic, copy) ExplodeCompletion completionCallback;

- (void)th_explodeWithDuration:(NSTimeInterval)duration;
- (void)th_explodeWithDuration:(NSTimeInterval)duration callback:(ExplodeCompletion)callback;

@end