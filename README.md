#THTransitionAnimation
###封装自定义push pop 转场动画代理 支持百分比手势代理

使用方法:
- 引入UINavigationController+THTransitionSupportExtension.h头文件,若要使用手势转场,还需要引入THInteractiveTransition.h头文件
- 调用方法如下, 也可以直接看Demo中的ViewController.m文件
```objectivec
//  push动画调用
- (IBAction)pushClk:(id)sender
{
ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
// 转场动画调用 就这一句话 通过transitionAnimationStyle枚举值传入动画类型
[self.navigationController th_pushViewController:vc preAnimationStyle:transitionAnimationStyle duration:0.6 completion:^{
NSLog(@"push 转场执行完毕");
}];
}
// pop动画调用
- (IBAction)popClk:(id)sender
{

[self.navigationController th_popViewControllerPreAnimationStyle:transitionAnimationStyle duration:0.6 completion:^{
NSLog(@"pop 转场执行完毕");
}];
}

// 手势转场使用方法
- (void)settingInteractiveTransitionDelegate
{
_interactiveTransition = [[THInteractiveTransition alloc] init];
//绑定手势方向是对应push 还是pop
[_interactiveTransition bindingTransitionType:THInteractiveTransitionTypePop  withGestureDirection:THInteractiveTransitionGestureDirectionRight];
[_interactiveTransition bindingTransitionType:THInteractiveTransitionTypePush  withGestureDirection:THInteractiveTransitionGestureDirectionLeft];

__weak typeof(self) weakSelf = self ;
//设置手势转场的转场动画样式
_interactiveTransition.popStyle = transitionAnimationStyle ;
//push 到那个控制器 push之前要做些什么其他操作 都写在这里
[_interactiveTransition setPushConifg:^{
__strong typeof(weakSelf) strongSelf = weakSelf ;
ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
if (transitionAnimationStyle == THTransitionPreAnimationStyleLeafPage) {
[strongSelf.navigationController th_pushViewController:vc preAnimationStyle:THTransitionPreAnimationStylePage duration:0.3 completion:^{
NSLog(@" 目前自定义翻页效果的push动画的手势转场有时序bug , 所以禁用");
NSLog(@"push 转场执行完毕");
}];
}else
{
[strongSelf.navigationController th_pushViewController:vc preAnimationStyle:transitionAnimationStyle duration:0.3 completion:^{
NSLog(@"push 转场执行完毕");
}];
}
}];
// 将当前控制器绑定到专场代理中 是个弱引用 放心绑 ...
[_interactiveTransition addPanGestureForViewController:self];

}
```
- 通过传入THTransitionPreAnimationStyle(动画样式枚举值)确定转场动画效果
- 目前实现的THTransitionPreAnimationStyle效果有:       
-  [THTransitionPreAnimationStylePage]  =  @"page(翻页)",
-   [THTransitionPreAnimationStyleRippluEffect] =  @"tipplu(水波)",
-  [THTransitionPreAnimationStyleSuckEffect] =  @"suck(吸收)",
-  [THTransitionPreAnimationStyleCube] =  @"cube(立方体)",
-  [THTransitionPreAnimationStyleOglFlip]  =  @"oglFlip(翻转)",
-  [THTransitionPreAnimationStyleFade]  =  @"fade(渐变)",
-  [THTransitionPreAnimationStyleMoveIn]  =  @"moveIn(移入)",
- [THTransitionPreAnimationStylePush]  =  @"push(推入)",
- [THTransitionPreAnimationStyleReveal]  = @"reveal(揭示)",
-  [THTransitionPreAnimationStyleWaterWaveUp] = @"waterWaveUp(波浪上移)",
-  [THTransitionPreAnimationStyleLeafPage]  = @"leafPage(横向翻页)",
-  [THTransitionPreAnimationStyleExplode ] = @"explode(爆裂)",