//
//  THInteractiveTransition.m
//  THTransitionAnimation
//
//  Created by litianhao on 16/7/5.
//  Copyright © 2016年 litianhao. All rights reserved.
//


#import "THInteractiveTransition.h"

#import "UINavigationController+THTransitionSupportExtension.h"

@interface THInteractiveTransition ()

@property (nonatomic, weak) UIViewController *vc;
/**手势方向*/
@property (nonatomic, assign) THInteractiveTransitionGestureDirection direction;
/**手势类型*/
@property (nonatomic, assign) THInteractiveTransitionType type;

@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,strong) NSMutableDictionary *typeAndDirectionMap;

@property (nonatomic,weak) CADisplayLink *displayLink;

@end

@implementation THInteractiveTransition

+ (instancetype)interactiveTransitionWithTransitionType:(THInteractiveTransitionType)type GestureDirection:(THInteractiveTransitionGestureDirection)direction{
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(THInteractiveTransitionType)type GestureDirection:(THInteractiveTransitionGestureDirection)direction{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    
    static UIGestureRecognizerState preState ;
    CGPoint panOffSet = [panGesture translationInView:panGesture.view] ;
    if ( UIGestureRecognizerStateChanged == panGesture.state &&
        UIGestureRecognizerStateBegan == preState) {
        [self.typeAndDirectionMap enumerateKeysAndObjectsUsingBlock:^(NSNumber  *_Nonnull key, NSNumber  *_Nonnull obj, BOOL * _Nonnull stop) {
            THInteractiveTransitionGestureDirection directioner = [key integerValue];
            switch (directioner) {
                case THInteractiveTransitionGestureDirectionRight:
                    if (panOffSet.x > 0) {
                        self.direction = THInteractiveTransitionGestureDirectionRight ;
                        *stop = YES ;
                    }
                    break;
                case THInteractiveTransitionGestureDirectionLeft:
                    if (panOffSet.x < 0) {
                        self.direction = THInteractiveTransitionGestureDirectionLeft ;
                        *stop = YES ;
                    }
                    break;
                case THInteractiveTransitionGestureDirectionUp:
                    if (panOffSet.y < 0) {
                        self.direction = THInteractiveTransitionGestureDirectionUp ;
                        _type = [obj integerValue];
                        *stop = YES ;
                    }
                    break;
                case THInteractiveTransitionGestureDirectionDown:
                    if (panOffSet.y > 0) {
                        self.direction = THInteractiveTransitionGestureDirectionDown ;
                        *stop = YES ;
                    }
                    break;
            }
        }];
    }
    
    //手势百分比
    CGFloat persent = 0;
    switch (_direction) {
        case THInteractiveTransitionGestureDirectionLeft:{
            CGFloat transitionX = -panOffSet.x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case THInteractiveTransitionGestureDirectionRight:{
            CGFloat transitionX = panOffSet.x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case THInteractiveTransitionGestureDirectionUp:{
            CGFloat transitionY = -panOffSet.y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case THInteractiveTransitionGestureDirectionDown:{
            CGFloat transitionY = panOffSet.y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateChanged:{
            if (preState == UIGestureRecognizerStateBegan) {
                self.interation = YES;
                [self startGesture];
                break;
            }
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:persent];
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            self.interation = NO;
            _progress = persent ;
            CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePresent)];
            _displayLink = display ;
            [display addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            break;
        }
        default:
            break;
    }
    
    preState = panGesture.state ;
    
}

- (void)updatePresent
{
    if (_progress >= 0.5) {
        _progress += 0.05;
        if (_progress >1) {
            [self finishInteractiveTransition];
            [_displayLink invalidate];
            
            _type = -1 ;
            _direction = -1 ;
            _progress = 1 ;
        }else
        {
            [self updateInteractiveTransition: _progress];
            
        }
    }else
    {
        _progress -= 0.01;
        
        if (_progress <= 0) {
            [self updateInteractiveTransition: 0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeToView" object:nil];
            [self cancelInteractiveTransition];
            
            [_displayLink invalidate];
            
            _type = -1 ;
            _direction = -1 ;
            _progress = 0 ;
        }else
        {
            [self updateInteractiveTransition: _progress];
            
        }
        
    }
}

- (void)startGesture{
    switch (_type) {
        case THInteractiveTransitionTypePresent:{
            if (_presentConifg) {
                _presentConifg();
            }
        }
            break;
            
        case THInteractiveTransitionTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        case THInteractiveTransitionTypePush:{
            if (_pushConifg) {
                _pushConifg();
            }
        }
            break;
        case THInteractiveTransitionTypePop:
            [_vc.navigationController th_popViewControllerPreAnimationStyle:_popStyle duration:0.3 completion:nil];
            break;
    }
}

- (void)bindingTransitionType:(THInteractiveTransitionType)type withGestureDirection:(THInteractiveTransitionGestureDirection)direction
{

    [self.typeAndDirectionMap setObject:@(type) forKey:@(direction)];
}

- (NSMutableDictionary *)typeAndDirectionMap
{
    if (!_typeAndDirectionMap) {
        _typeAndDirectionMap = [NSMutableDictionary dictionary];
    }
    
    return  _typeAndDirectionMap ;
}

- (void)setDirection:(THInteractiveTransitionGestureDirection)direction
{
    _direction = direction ;
    _type = [self.typeAndDirectionMap[@(direction)] integerValue];
}

@end