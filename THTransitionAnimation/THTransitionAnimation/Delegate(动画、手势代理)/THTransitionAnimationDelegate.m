
//
//  THTransitionAnimationDelegate.m
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THTransitionAnimationDelegate.h"

#import "THTransitionInfoModel.h"
#import "THAnimationBlockLibManager.h"


#import "UIView+THExplode.h"

@interface THTransitionAnimationDelegate ()

@property (nonatomic,weak) id<NSObject> obseverOfAnimationEnded;
@property (nonatomic,weak) id<NSObject> obserVer;

@end

@implementation THTransitionAnimationDelegate

- (instancetype)initWithModel:(THTransitionInfoModel *)transitionModel
{
    if (self = [super init]) {
        _transitionInfoModel = transitionModel ;
        
    }
    return self ;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _transitionInfoModel.transitionDuration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.transitionInfoModel.preAnimationStyle) {
        case THTransitionPreAnimationStyleWaterWaveUp:
           [ self p_transitionWaterwaveUpAnimationWithTransition:transitionContext];
            return ;            
        case THTransitionPreAnimationStyleLeafPage:
           [ self p_transitionLeafPageAnimationWithTransition:transitionContext];
            break;
       
        case  THTransitionPreAnimationStyleExplode:
        {
            [self p_transitionExplodeAnimationWithTransition:transitionContext];
            break ;
        }
        case THTransitionPreAnimationStylePage:
        case THTransitionPreAnimationStyleRippluEffect:
        case THTransitionPreAnimationStyleSuckEffect:
        case THTransitionPreAnimationStyleCube:
        case THTransitionPreAnimationStyleOglFlip:
        case THTransitionPreAnimationStyleFade:
        case THTransitionPreAnimationStyleMoveIn:
        case THTransitionPreAnimationStylePush:
        case THTransitionPreAnimationStyleReveal:
        {
            [self p_transitionBySystemAnimationWithTransition:transitionContext animationStyle:self.transitionInfoModel.preAnimationStyle];
        }
        default:
            break;
    }

}


- (void)p_transitionExplodeAnimationWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView =  [transitionContext containerView] ;
    UIView *toView =  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view ;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;

    [containerView addSubview:toView];
    [containerView bringSubviewToFront:fromView];

    [fromView th_explodeWithDuration:_transitionInfoModel.transitionDuration callback:^{

        __weak typeof(self) weakSelf = self ;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            [containerView addSubview:fromView];
        }
        __strong typeof(weakSelf) strongSelf = weakSelf ;
        if (strongSelf.transitionInfoModel.completion) {
            strongSelf.transitionInfoModel.completion();
        }
    }];
}

- (void)p_transitionBySystemAnimationWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext animationStyle:(THTransitionPreAnimationStyle)animationStyle
{
    UIView *containerView =  [transitionContext containerView] ;
    UIView *toView =  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view ;
    toView.frame = containerView.bounds ;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.frame = containerView.bounds ;
    toView.hidden = NO ;
    
    BOOL isDismissMode = UINavigationControllerOperationPop==  _transitionInfoModel.operation;
    if (!isDismissMode) {
        [containerView addSubview:toView];
    }else
    {
        [containerView insertSubview:toView belowSubview:fromView];
    }
    
    if (isDismissMode && THTransitionPreAnimationStyleSuckEffect != animationStyle ) {
        [containerView addSubview:toView];
    }
    
    NSInteger index = animationStyle ;

    CATransition *transion = [CATransition animation];
    transion.type = animationKeyMap[index];
    transion.subtype =  kCATransitionFromRight;
    if ( THTransitionPreAnimationStylePage == animationStyle) {
        transion.type = isDismissMode ? @"pageUnCurl" : @"pageCurl";
    }else if ((THTransitionPreAnimationStyleCube == animationStyle||
              THTransitionPreAnimationStyleOglFlip == animationStyle||
              THTransitionPreAnimationStyleMoveIn == animationStyle ||
               THTransitionPreAnimationStylePush == animationStyle ||
               THTransitionPreAnimationStyleReveal == animationStyle) && isDismissMode
              )
    {
        transion.subtype = kCATransitionFromLeft ;
    }else if( THTransitionPreAnimationStyleSuckEffect == animationStyle && isDismissMode)
    {
        transion.subtype = kCATransitionFromBottom ;
        transion.startProgress = 1 ;
        transion.endProgress = 0 ;
        transion.duration = self.transitionInfoModel.transitionDuration;
        transion.delegate = self ;
        [transion setValue:transitionContext forKey:@"transitionContext22"];
        [toView.layer addAnimation:transion forKey:@"suck"];
        toView.hidden = YES ;
        [containerView addSubview:toView];
        return ;
    }
    _obserVer = [[NSNotificationCenter defaultCenter] addObserverForName:@"removeToView" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [toView removeFromSuperview];
    }];
    transion.duration = self.transitionInfoModel.transitionDuration;
    transion.delegate = self ;
    [transion setValue:transitionContext forKey:@"transitionContext22"];
    [containerView.layer addAnimation:transion forKey:@"page"];
    
}



- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

       id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext22"];

    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view  ;
      UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    BOOL isDismiss = toView.hidden ;
    BOOL isCancel = [transitionContext transitionWasCancelled] ;
    if (!isDismiss && isCancel) {
        [toView removeFromSuperview];
    }
       toView.hidden = isCancel;

        if (!isCancel && isDismiss) {
            [fromView removeFromSuperview];
        }
        [transitionContext completeTransition:!isCancel];
    NSLog(@"animation stop");
        toView.hidden = NO;

        if (self.transitionInfoModel.completion) {
                    self.transitionInfoModel.completion();
                }
    
}

- (void)p_transitionLeafPageAnimationWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView =  [transitionContext containerView] ;
    UIView *toView =  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view ;
    toView.frame = containerView.bounds ;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.frame = containerView.bounds ;

    BOOL isDismissMode = UINavigationControllerOperationPop==  _transitionInfoModel.operation;

    [containerView addSubview:toView];
    if (isDismissMode) {
        [containerView bringSubviewToFront:fromView];
    }

    THViewTransitionAnimationBlock animation = [[THAnimationBlockLibManager defaultTransitionAnimationBlockLibrary] transitionAnimationBlockForKey:kTHAnimationStyleLeafPageBlockKey] ;
    
    __weak typeof(self) weakSelf = self ;
    
    _obseverOfAnimationEnded = [[NSNotificationCenter defaultCenter] addObserverForName:kTHAnimationDidEndNotificationKey object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf) strongSelf = weakSelf ;
        [containerView addSubview:toView];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];

        NSLog(@" 接到通知 完成动画 ");
        if (strongSelf.transitionInfoModel.completion) {
            strongSelf.transitionInfoModel.completion();
        }
    }];
    animation(isDismissMode ? toView : fromView , self.transitionInfoModel.transitionDuration , isDismissMode);

    
}

- (void)p_transitionWaterwaveUpAnimationWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView *containerView =  [transitionContext containerView] ;
    UIView *toView =  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view ;
    toView.frame = containerView.bounds ;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.frame = containerView.bounds ;

    BOOL isDismissMode = UINavigationControllerOperationPop==  _transitionInfoModel.operation;
    if (!isDismissMode) {
        [containerView addSubview:toView];
    }else
    {
        [containerView insertSubview:toView belowSubview:fromView];
    }
    
    UIView *viewToAnimation = isDismissMode ? fromView : toView ;

    
    THViewTransitionAnimationBlock animation = [[THAnimationBlockLibManager defaultTransitionAnimationBlockLibrary] transitionAnimationBlockForKey:kTHAnimationStyleWaterWaveUpBlockKey] ;
    
    __weak typeof(toView) weakToView = toView ;
    __weak typeof(self) weakSelf = self ;
    
    _obseverOfAnimationEnded = [[NSNotificationCenter defaultCenter] addObserverForName:kTHAnimationDidEndNotificationKey object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf ;

        
        
        if (weakToView.layer.mask) {
            [weakToView.layer.mask removeFromSuperlayer] ;
        }
        if (fromView.layer.mask) {
            [fromView.layer.mask removeFromSuperlayer] ;
        }
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        if (!transitionContext.transitionWasCancelled) {
            [containerView addSubview:toView];
        }
        
        if (strongSelf.transitionInfoModel.completion) {
            strongSelf.transitionInfoModel.completion();
        }
    }];
    animation(viewToAnimation , weakSelf.transitionInfoModel.transitionDuration , isDismissMode);

}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:_obseverOfAnimationEnded name:kTHAnimationDidEndNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_obserVer];

    NSLog(@"transition dealloc");
}


@end
