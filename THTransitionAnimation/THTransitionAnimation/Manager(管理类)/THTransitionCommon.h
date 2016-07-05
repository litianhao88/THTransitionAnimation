//
//  THTransitionCommon.h
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#ifdef __OBJC__

#ifndef __THTransitionAnimation__H__
#define __THTransitionAnimation__H__
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,THTransitionPreAnimationStyle )
{
    THTransitionPreAnimationStylePage = 0 ,
    THTransitionPreAnimationStyleRippluEffect,
    THTransitionPreAnimationStyleSuckEffect,
    THTransitionPreAnimationStyleCube,
    THTransitionPreAnimationStyleOglFlip,
    THTransitionPreAnimationStyleFade,
    THTransitionPreAnimationStyleMoveIn,
    THTransitionPreAnimationStylePush,
    THTransitionPreAnimationStyleReveal,
    
    THTransitionPreAnimationStyleWaterWaveUp,
    THTransitionPreAnimationStyleLeafPage,
    THTransitionPreAnimationStyleExplode,
};

UIKIT_EXTERN NSString *animationKeyMap[12] ;
UIKIT_EXTERN NSString *animationChineseTitleMap[12] ;

#endif


#endif
