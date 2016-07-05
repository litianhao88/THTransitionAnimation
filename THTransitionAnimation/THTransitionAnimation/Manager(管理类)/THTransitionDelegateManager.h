//
//  THTransitionDelegateManager.h
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THTransitionInfoModel ;

@interface THTransitionDelegateManager : NSObject<UINavigationControllerDelegate , UIViewControllerTransitioningDelegate>

+ (instancetype)shareManager;
+ (THTransitionInfoModel *)popTransitionInfoModel;
+ (void)pushTransitionInfoModel:(THTransitionInfoModel *)transitionInfoModel;

@end
