//
//  UINavigationController+THTransitionSupportExtension.m
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "UINavigationController+THTransitionSupportExtension.h"

#import "THTransitionDelegateManager.h"
#import "THTransitionInfoModel.h"

@implementation UINavigationController (THTransitionSupportExtension)

- (void)th_pushViewController:  (UIViewController *)viewController
                   preAnimationStyle:  (THTransitionPreAnimationStyle)preAnimationStyle
                                    duration:  (NSTimeInterval)duration
                               completion:  (void (^)(void))completion
{
    
    THTransitionInfoModel *model = [[THTransitionInfoModel alloc] init];
    model.transitionDuration = duration ;
    model.preAnimationStyle = preAnimationStyle ;

    if (completion) {
        model.completion = [completion copy];
    }
    
    self.delegate = [THTransitionDelegateManager shareManager];
    [THTransitionDelegateManager pushTransitionInfoModel:model];
    
    [self pushViewController:viewController animated:YES];

    self.delegate = nil ;
}


- (UIViewController *)th_popViewControllerPreAnimationStyle:(THTransitionPreAnimationStyle)preAnimationStyle  duration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    THTransitionInfoModel *model = [[THTransitionInfoModel alloc] init];
    model.transitionDuration = duration ;
    model.preAnimationStyle = preAnimationStyle ;
    
    if (completion) {
        model.completion = [completion copy];
    }
    
    self.delegate = [THTransitionDelegateManager shareManager];
    [THTransitionDelegateManager pushTransitionInfoModel:model];
    
   UIViewController *vc =  [self popViewControllerAnimated:YES];
    self.delegate = nil;
    return vc ;
}

@end
