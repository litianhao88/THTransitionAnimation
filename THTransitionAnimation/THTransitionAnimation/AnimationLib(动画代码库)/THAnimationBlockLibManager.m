//
//  THAnimationBlockLibManager.m
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THAnimationBlockLibManager.h"

#import "THWaterWaveLayer.h"

#import "masterView.h"

#import "CADisplayLink+THBlockSupportEx.h"

NSString *const kTHAnimationDidEndNotificationKey = @"kTHAnimationDidEndNotificationKey";

NSString *const kTHAnimationStyleWaterWaveUpBlockKey = @"kTHAnimationStyleWaterWaveUpBlockKey";
NSString *const kTHAnimationStyleLeafPageBlockKey = @"kTHAnimationStyleLeafPageBlockKey";
NSString *const THAnimationStyleCircleExpandBlockKey = @"THAnimationStyleCircleExpandBlockKey";


static THViewTransitionAnimationBlock waterWaveUpBlock ;
static THViewTransitionAnimationBlock leafPageBlock ;


@interface THAnimationBlockLibManager ()

@end

@implementation THAnimationBlockLibManager

+ (instancetype)defaultTransitionAnimationBlockLibrary
{
        static THAnimationBlockLibManager *singleTon = nil ;
        static dispatch_once_t once_token ;
        dispatch_once(&once_token, ^{
            singleTon = [[self alloc] init];
        });
        return singleTon;
}

- (THViewTransitionAnimationBlock)transitionAnimationBlockForKey:(NSString *__nullable)blockKey
{
    if ([blockKey isEqualToString:kTHAnimationStyleWaterWaveUpBlockKey]) {
        return waterWaveUpBlock ;
    }else if ([blockKey isEqualToString:kTHAnimationStyleLeafPageBlockKey]){
    return leafPageBlock ;
    }
    return nil;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTHAnimationDidEndNotificationKey object:nil];
}

@end

static THViewTransitionAnimationBlock waterWaveUpBlock = ^(UIView *viewToAnimation , NSTimeInterval duration , BOOL dismiss){
    
    
    THWaterWaveLayer *maskLayer = [THWaterWaveLayer layer];
    [viewToAnimation.layer setMask:maskLayer];
    if(dismiss)
    {
        maskLayer.frame = viewToAnimation.bounds ;
    }
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    maskLayerAnimation.duration = duration ;
    maskLayerAnimation.fromValue = !dismiss ? @([UIScreen mainScreen].bounds.size.height) : @(0);
    maskLayerAnimation.toValue = !dismiss ? @(0) : @([UIScreen mainScreen].bounds.size.height -10) ;
    maskLayerAnimation.fillMode=kCAFillModeForwards;
    
    
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.removedOnCompletion = NO ;
    maskLayerAnimation.delegate = [THAnimationBlockLibManager defaultTransitionAnimationBlockLibrary];
    [maskLayer addAnimation:maskLayerAnimation forKey:nil];
};

static THViewTransitionAnimationBlock leafPageBlock = ^(UIView *viewToAnimation , NSTimeInterval duration , BOOL dismiss){
    UIGraphicsBeginImageContext(viewToAnimation.bounds.size);
    [viewToAnimation.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    masterView *animationView = [masterView leafAnimationViewWithTopImg:viewImg bottomImg:nil frame:viewToAnimation.bounds];
    [viewToAnimation.superview addSubview:animationView];
    [viewToAnimation removeFromSuperview];
    
    [animationView setPagePercent: !dismiss];
    
    
    __weak typeof(animationView) weakAnimationView = animationView;
    
    [animationView setCompletionBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kTHAnimationDidEndNotificationKey object:nil];
        [weakAnimationView removeFromSuperview];
    }];
    [animationView changePercent];
    
};
