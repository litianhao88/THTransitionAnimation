//
//  THTransitionAnimationDelegate.h
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THTransitionInfoModel ;

@interface THTransitionAnimationDelegate : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) THTransitionInfoModel *transitionInfoModel;


- (instancetype)initWithModel:(THTransitionInfoModel *)transitionModel;

@end
