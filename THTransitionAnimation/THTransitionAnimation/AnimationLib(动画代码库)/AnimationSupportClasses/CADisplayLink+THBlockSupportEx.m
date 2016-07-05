//
//  CADisplayLink+THBlockSupportEx.m
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/21.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "CADisplayLink+THBlockSupportEx.h"


@interface THTargetObject : NSObject

@property (nonatomic,weak) CADisplayLink *targetOwner;

+ (instancetype)targetWithBlockToAction:(void (^)(CADisplayLink *currentDisplayLink))blockToAction;

- (void)p_actionWithBlock;

@end

@interface THTargetObject ()

@property (nonatomic,copy) void(^blockToAction)(CADisplayLink *currentDisplayLink);

@end

@implementation THTargetObject


+ (instancetype)targetWithBlockToAction:(void (^)(CADisplayLink *currentDisplayLink))blockToAction
{
    THTargetObject *tempObj = [[self alloc] init];
    tempObj.blockToAction = blockToAction ;
    return tempObj;
}

- (void)dealloc
{
    NSLog(@"target dealloc");
}

- (void)p_actionWithBlock
{
    if (self.blockToAction) {
        self.blockToAction(_targetOwner);
    }
}

@end

@implementation CADisplayLink (THBlockSupportEx)

+ (CADisplayLink *)displayLinkWithBlock:(void (^)(CADisplayLink *currentDisplayLink))blockToAction
{
    if (blockToAction) {
        THTargetObject *tempObj = [THTargetObject targetWithBlockToAction:blockToAction] ;
      CADisplayLink *displayLink =   [self displayLinkWithTarget:tempObj selector:@selector(p_actionWithBlock)] ;
        tempObj.targetOwner = displayLink ;
        return  displayLink;
    }
    return nil;
}

- (void)dealloc
{
    NSLog(@"display link dealloc");
}

@end
