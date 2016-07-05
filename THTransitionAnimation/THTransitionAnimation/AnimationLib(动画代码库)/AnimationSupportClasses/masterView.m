//
//  masterView.m
//  pageTest
//
//  Created by litianhao on 16/5/17.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "masterView.h"

#import "CADisplayLink+THBlockSupportEx.h"

@interface masterView ()

@property (readonly) CALayer *topPage, *topPageOverlay, *topPageReverse,
*topPageReverseImage, *topPageReverseOverlay, *bottomPage;
@property (readonly) CAGradientLayer *topPageShadow, *topPageReverseShading,
*bottomPageShadow;
@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) CGFloat leafEdge;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) CGPoint touchBeganPoint;
@property (nonatomic, assign) CGRect nextPageRect, prevPageRect;
@property (nonatomic, assign) BOOL touchIsActive, interactionLocked;

@property (nonatomic,strong) UIImage *topImg;
@property (nonatomic,strong) UIImage *bottomImg;

@end

@implementation masterView

- (void)initCommon {
    self.clipsToBounds = YES;
    
    //背景图层
    _topPage = [[CALayer alloc] init];
    _topPage.masksToBounds = YES;
    _topPage.contentsGravity = kCAGravityLeft;
    _topPage.contents =  (__bridge id _Nullable)_topImg.CGImage;
    
    _topPage.backgroundColor = [[UIColor whiteColor] CGColor];
    
    //切换时背景阴影图层
    _topPageOverlay = [[CALayer alloc] init];
    _topPageOverlay.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
    
    //翻页时 边缘的阴影渐变层
    _topPageShadow = [[CAGradientLayer alloc] init];
    _topPageShadow.colors = [NSArray arrayWithObjects:
                             (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],
                             (id)[[UIColor whiteColor] CGColor],
                             nil];
    _topPageShadow.startPoint = CGPointMake(1 , 0.5);
    _topPageShadow.endPoint = CGPointMake(0,0.5);
    
    //翻页时 反面背景图层
    _topPageReverse = [[CALayer alloc] init];
    _topPageReverse.backgroundColor = [[UIColor whiteColor] CGColor];
    _topPageReverse.masksToBounds = YES;
    
    //翻页时 反面图片层
    _topPageReverseImage = [[CALayer alloc] init];
    _topPageReverseImage.masksToBounds = YES;
    _topPageReverseImage.contentsGravity = kCAGravityRight;
    _topPageReverseImage.contents =  (__bridge id _Nullable)_topImg.CGImage;

    
    //翻页时 反面遮盖层
    _topPageReverseOverlay = [[CALayer alloc] init];
    _topPageReverseOverlay.backgroundColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.8] CGColor];
    
    //翻页时 反面阴影条
    _topPageReverseShading = [[CAGradientLayer alloc] init];
    _topPageReverseShading.colors = [NSArray arrayWithObjects:
                                     (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],
                                     (id)[[UIColor clearColor] CGColor],
                                     nil];
    _topPageReverseShading.startPoint = CGPointMake(1,0.5);
    _topPageReverseShading.endPoint = CGPointMake(0,0.5);
    
    //翻页时 下面一页背景图层
    _bottomPage = [[CALayer alloc] init];
    _bottomPage.backgroundColor = [[UIColor clearColor] CGColor];
//    _bottomPage.contents = (__bridge id _Nullable)_bottomImg.CGImage;
    _bottomPage.masksToBounds = YES;
    
    //翻页时 下面一层阴影图层
    _bottomPageShadow = [[CAGradientLayer alloc] init];
    _bottomPageShadow.colors = [NSArray arrayWithObjects:
                                (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],
                                (id)[[UIColor clearColor] CGColor],
                                nil];
    _bottomPageShadow.startPoint = CGPointMake(0,0.5);
    _bottomPageShadow.endPoint = CGPointMake(1,0.5);
    
    [_topPage addSublayer:_topPageShadow];
    [_topPage addSublayer:_topPageOverlay];
    [_topPageReverse addSublayer:_topPageReverseImage];
    [_topPageReverse addSublayer:_topPageReverseOverlay];
    [_topPageReverse addSublayer:_topPageReverseShading];
    [_bottomPage addSublayer:_bottomPageShadow];
    [self.layer addSublayer:_bottomPage];
    [self.layer addSublayer:_topPage];
    [self.layer addSublayer:_topPageReverse];
    
    self.leafEdge = 1;

}

+ (instancetype)leafAnimationViewWithTopImg:(UIImage *)topImg bottomImg:(UIImage *)bottomImg frame:(CGRect)frame
{
    return  [[self alloc] initWithTopImg:topImg bottomImg:bottomImg frame:frame];
}

- (instancetype)initWithTopImg:(UIImage *)topImg bottomImg:(UIImage *)bottomImg frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _topImg = topImg ;
        _bottomImg = bottomImg ;
        [self initCommon];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initCommon];
    }
    return self;
}

- (void)setLayerFrames {
    self.topPage.frame = CGRectMake(self.layer.bounds.origin.x,
                                    self.layer.bounds.origin.y,
                                    self.leafEdge * self.bounds.size.width,
                                    self.layer.bounds.size.height);
    self.topPageReverse.frame = CGRectMake(self.layer.bounds.origin.x + (2*self.leafEdge-1) * self.bounds.size.width,
                                           self.layer.bounds.origin.y,
                                           (1-self.leafEdge) * self.bounds.size.width,
                                           self.layer.bounds.size.height);
    self.bottomPage.frame = self.layer.bounds;
    self.topPageShadow.frame = CGRectMake(self.topPageReverse.frame.origin.x - 40,
                                          0,
                                          40,
                                          self.bottomPage.bounds.size.height);
    self.topPageReverseImage.frame = self.topPageReverse.bounds;
    self.topPageReverseImage.transform = CATransform3DMakeScale(-1, 1, 1);
    self.topPageReverseOverlay.frame = self.topPageReverse.bounds;
    self.topPageReverseShading.frame = CGRectMake(self.topPageReverse.bounds.size.width - 50,
                                                  0, 
                                                  50 + 1, 
                                                  self.topPageReverse.bounds.size.height);
    self.bottomPageShadow.frame = CGRectMake(self.leafEdge * self.bounds.size.width,
                                             0, 
                                             40, 
                                             self.bottomPage.bounds.size.height);
    self.topPageOverlay.frame = self.topPage.bounds;
}

// 测试竖直方向翻页

//- (void)setLayerFrames {
//    self.topPage.frame = CGRectMake(self.layer.bounds.origin.x,
//                                    self.layer.bounds.origin.y,
//                                     self.bounds.size.width,
//                                    self.leafEdge *self.layer.bounds.size.height);
//    self.topPageReverse.frame = CGRectMake(self.layer.bounds.origin.x ,
//                                           self.layer.bounds.origin.y + (2*self.leafEdge-1) * self.bounds.size.height,
//                                           self.bounds.size.width,
//                                          (1-self.leafEdge) *  self.layer.bounds.size.height);
//    self.bottomPage.frame = self.layer.bounds;
//    self.topPageShadow.frame = CGRectMake(0,
//                                          self.topPageReverse.frame.origin.y - 40,
//                                           self.bottomPage.bounds.size.width,
//                                         40);
//    self.topPageReverseImage.frame = self.topPageReverse.bounds;
//    self.topPageReverseImage.transform = CATransform3DMakeScale(-1, 1, 1);
//    self.topPageReverseOverlay.frame = self.topPageReverse.bounds;
//    self.topPageReverseShading.frame = CGRectMake( 0 ,
//                                                  self.topPageReverse.bounds.size.height - 50,
//                                                   self.topPageReverse.bounds.size.width,
//                                                51 );
//    self.bottomPageShadow.frame = CGRectMake( 0 ,
//                                             self.leafEdge * self.bounds.size.height * 2,
//                                             self.bottomPage.bounds.size.width,
//                                             40);
//    self.topPageOverlay.frame = self.topPage.bounds;
//}


- (void)setLeafEdge:(CGFloat)aLeafEdge {
    _leafEdge = aLeafEdge;
    self.topPageShadow.opacity = MIN(1.0, 4*(1-self.leafEdge));
    self.bottomPageShadow.opacity = MIN(1.0, 4*self.leafEdge);
    self.topPageOverlay.opacity = MIN(1.0, 4*(1-self.leafEdge));
    [self setLayerFrames];
}

- (void)changePercent
{
    __weak typeof(self) weakSelf = self ;

    if (self.leafEdge > 0) {
        [[CADisplayLink displayLinkWithBlock:^(CADisplayLink *displayLink){
            [CATransaction setDisableActions:YES];
            __strong typeof(weakSelf) strongSelf = weakSelf ;
                strongSelf.leafEdge -= 0.04;
                if (strongSelf.leafEdge <= -0.2) {
                    [displayLink invalidate];
                        if (strongSelf.completionBlock) {
                            strongSelf.completionBlock();
                        }
                }
    }] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
   else
    {
        [[CADisplayLink displayLinkWithBlock:^(CADisplayLink *displayLink){
            __strong typeof(weakSelf) strongSelf = weakSelf ;
            [CATransaction setDisableActions:YES];

            strongSelf.leafEdge += 0.04;
            if (strongSelf.leafEdge >= 1.3) {
                
                [displayLink invalidate];
                    if (strongSelf.completionBlock) {
                        strongSelf.completionBlock();
                    }
  
            }

        }] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}


- (void)setPagePercent:(CGFloat)pagePercent
{
    if (pagePercent > 1) {
        pagePercent = 1;
    }else if (pagePercent < 0)
    {
        pagePercent =  0 ;
    }
 
    self.leafEdge = pagePercent;

}

- (void)dealloc
{
    NSLog(@"masterView dealloc");
}

@end
