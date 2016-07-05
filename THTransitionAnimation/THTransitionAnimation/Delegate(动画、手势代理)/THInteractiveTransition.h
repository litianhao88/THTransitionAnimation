//
//  THInteractiveTransition.h
//  THTransitionAnimation
//
//  Created by litianhao on 16/7/5.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "THTransitionCommon.h"

typedef void(^GestureConifg)();

typedef NS_ENUM(NSUInteger, THInteractiveTransitionGestureDirection) {//手势的方向
    THInteractiveTransitionGestureDirectionLeft = 0,
    THInteractiveTransitionGestureDirectionRight,
    THInteractiveTransitionGestureDirectionUp,
    THInteractiveTransitionGestureDirectionDown
};

typedef NS_ENUM(NSUInteger, THInteractiveTransitionType) {//手势控制哪种转场
    THInteractiveTransitionTypePresent = 0,
    THInteractiveTransitionTypeDismiss,
    THInteractiveTransitionTypePush,
    THInteractiveTransitionTypePop,
};

@interface THInteractiveTransition : UIPercentDrivenInteractiveTransition
/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;
/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg presentConifg;
/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg pushConifg;

@property (nonatomic,assign) THTransitionPreAnimationStyle popStyle;
//初始化方法

+ (instancetype)interactiveTransitionWithTransitionType:(THInteractiveTransitionType)type GestureDirection:(THInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(THInteractiveTransitionType)type GestureDirection:(THInteractiveTransitionGestureDirection)direction;
- (void)bindingTransitionType:(THInteractiveTransitionType)type withGestureDirection:(THInteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;
@end
