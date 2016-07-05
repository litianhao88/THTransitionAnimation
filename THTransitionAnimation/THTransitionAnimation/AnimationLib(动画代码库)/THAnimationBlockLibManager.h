//
//  THAnimationBlockLibManager.h
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^THViewTransitionAnimationBlock)(UIView *viewToAnimation , NSTimeInterval duration , BOOL dismiss);

@interface THAnimationBlockLibManager : NSObject

+ (instancetype)defaultTransitionAnimationBlockLibrary;
- (THViewTransitionAnimationBlock)transitionAnimationBlockForKey:(NSString *)blockKey ;

@end


UIKIT_EXTERN NSString *const kTHAnimationDidEndNotificationKey;

UIKIT_EXTERN NSString *const kTHAnimationStyleWaterWaveUpBlockKey;
UIKIT_EXTERN NSString *const kTHAnimationStyleLeafPageBlockKey;
UIKIT_EXTERN NSString *const THAnimationStyleCircleExpandBlockKey;

//