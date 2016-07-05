//
//  masterView.h
//  pageTest
//
//  Created by litianhao on 16/5/17.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface masterView : UIView


@property (nonatomic,copy) void(^completionBlock) ();


+ (instancetype)leafAnimationViewWithTopImg:(UIImage *)topImg bottomImg:(UIImage *)bottomImg frame:(CGRect)frame;

- (instancetype)initWithTopImg:(UIImage *)topImg bottomImg:(UIImage *)bottomImg frame:(CGRect)frame;

- (void)changePercent;

- (void)setPagePercent:(CGFloat)pagePercent;



@end
