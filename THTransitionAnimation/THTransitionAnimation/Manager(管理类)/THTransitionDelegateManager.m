//
//  THTransitionDelegateManager.m
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "THTransitionDelegateManager.h"

#import "THTransitionAnimationDelegate.h"

#import "THTransitionInfoModel.h"

#import "THInteractiveTransition.h"

@interface THTransitionDelegateManager ()

@property (nonatomic,strong) NSMutableArray<THTransitionInfoModel *> *transitionInfoStack;
@property (nonatomic,assign)  UINavigationControllerOperation operation;
@property (nonatomic,weak) UIViewController *fromVC;

@end

@implementation THTransitionDelegateManager

+ (instancetype)shareManager
{
    static THTransitionDelegateManager *singleTon = nil ;
    static dispatch_once_t once_token ;
    dispatch_once(&once_token, ^{
        singleTon = [[self alloc] init];
    });
    return singleTon ;
}

+ (void)pushTransitionInfoModel:(THTransitionInfoModel *)transitionInfoModel
{
    [[[self shareManager] transitionInfoStack] addObject:transitionInfoModel];
}

+ (THTransitionInfoModel *)popTransitionInfoModel
{
   THTransitionInfoModel *tempModel =  [[[self shareManager] transitionInfoStack] lastObject];
    [[[self shareManager] transitionInfoStack] removeLastObject];
    return tempModel ;
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    THTransitionInfoModel *model = [self.class popTransitionInfoModel];
    model.operation = operation ;
    _operation = operation ;
    _fromVC = fromVC ;
    return [[THTransitionAnimationDelegate alloc] initWithModel:model];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if(_operation == UINavigationControllerOperationPop ||
       _operation == UINavigationControllerOperationPush)
    {
        THInteractiveTransition *transition = [_fromVC valueForKey:@"interactiveTransition"] ;
        if ( transition ) {
            return transition.interation ? transition : nil ;
        }
    }
    
    return  nil ;
}

- (NSMutableArray<THTransitionInfoModel *> *)transitionInfoStack
{
    if (!_transitionInfoStack) {
        _transitionInfoStack = [NSMutableArray array];
    }
    return _transitionInfoStack ;
}

@end
