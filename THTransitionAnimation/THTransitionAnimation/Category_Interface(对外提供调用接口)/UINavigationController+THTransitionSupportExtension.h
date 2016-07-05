//
//  UINavigationController+THTransitionSupportExtension.h
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "THTransitionCommon.h"

@interface UINavigationController (THTransitionSupportExtension)

- (void)th_pushViewController:  (UIViewController *)viewController
                   preAnimationStyle:  (THTransitionPreAnimationStyle)preAnimationStyle
                                    duration:  (NSTimeInterval)duration
                               completion:  (void(^)(void))completion;

- (UIViewController *)th_popViewControllerPreAnimationStyle:  (THTransitionPreAnimationStyle)preAnimationStyle
                                                                                          duration:  (NSTimeInterval)duration
                                                                                     completion:  (void(^)(void))completion;


@end
