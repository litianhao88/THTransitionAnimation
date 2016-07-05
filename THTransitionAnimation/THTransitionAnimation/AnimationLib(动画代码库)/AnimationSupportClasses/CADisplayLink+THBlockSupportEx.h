//
//  CADisplayLink+THBlockSupportEx.h
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/21.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CADisplayLink (THBlockSupportEx)


+ (CADisplayLink *)displayLinkWithBlock:(void(^)(CADisplayLink *currentDisplayLink))blockToAction ;

@end
