//
//  THTransitionInfoModel.h
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THTransitionCommon.h"

@interface THTransitionInfoModel : NSObject

@property (nonatomic,assign) NSTimeInterval transitionDuration;
@property (nonatomic,assign) THTransitionPreAnimationStyle preAnimationStyle;
@property (nonatomic,copy)  void (^customAnimationBlock)(UIView *viewToAnimation);
@property (nonatomic,copy) void(^completion)(void);
@property (nonatomic,assign) UINavigationControllerOperation operation;

@end
