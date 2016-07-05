//
//  ViewController.m
//  THTransitionAnimation
//
//  Created by litianhao on 16/5/16.
//  Copyright © 2016年 litianhao. All rights reserved.
//

#import "ViewController.h"

// 使用手势转场 引入这个头文件
#import "THInteractiveTransition.h"
// 使用push pop动画 引入这个头文件
#import "UINavigationController+THTransitionSupportExtension.h"

static NSUInteger indexer = 0 ;
static THTransitionPreAnimationStyle transitionAnimationStyle ;

@interface ViewController () <UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic)  UIButton *titleSelectStyleBtn;

@property (nonatomic,strong) THInteractiveTransition *interactiveTransition;

@property (nonatomic,strong) UITableView *styleSelectTable;

@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitleSelectTypeBtn];
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:[NSString stringWithFormat:@"huoying%02zd", (indexer++)%23]].CGImage) ;
    
    [self settingInteractiveTransitionDelegate];
}

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


- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius ;
    _titleSelectStyleBtn.clipsToBounds = YES ;
    _titleSelectStyleBtn.layer.cornerRadius = _cornerRadius ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sizeof(animationKeyMap) / sizeof(animationKeyMap[0]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellId = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *overLayView = [[UIView alloc] init];
        [cell insertSubview:overLayView belowSubview:cell.contentView];
        overLayView.layer.masksToBounds = YES ;
        overLayView.layer.cornerRadius = 8 ;
        
        overLayView.tag = 1000;
    }
    return cell ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIView *overLayView = [cell viewWithTag:1000];
    
    cell.textLabel.text =   animationChineseTitleMap[indexPath.row] ;

    overLayView.backgroundColor = [UIColor orangeColor];
    overLayView.frame = cell.bounds ;
    cell.textLabel.textColor = [UIColor whiteColor];

    [UIView animateWithDuration:0.7 animations:^{
        
        if (indexPath.row !=  transitionAnimationStyle ) {
            overLayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        }else
        {
            cell.textLabel.textColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
        }
        
        CGRect frameOverLay = overLayView.frame ;
        frameOverLay.size.width -= 30;
        frameOverLay.size.height -= 10;
        overLayView.frame = frameOverLay ;
        overLayView.center = CGPointMake(cell.bounds.size.width/2, cell.bounds.size.height/2) ;
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    transitionAnimationStyle = indexPath.row ;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self selectAnimationStyleClk:_titleSelectStyleBtn];
}


- (UITableView *)styleSelectTable
{
    if (!_styleSelectTable) {
        _styleSelectTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 100, 64, 200, 0)];
        [self.view addSubview:_styleSelectTable];
        _styleSelectTable.delegate = self ;
        _styleSelectTable.dataSource = self ;

        _styleSelectTable.bounces = NO;
        _styleSelectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _styleSelectTable.backgroundColor = [UIColor clearColor];
        _styleSelectTable.showsHorizontalScrollIndicator = NO;
        _styleSelectTable.showsVerticalScrollIndicator = NO;
    }
    return _styleSelectTable ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44;
}

- (void)selectAnimationStyleClk:(UIButton *)sender
{
    sender.selected = !sender.selected ;
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.styleSelectTable.frame ;
            frame.size.height = MIN(self.view.bounds.size.height - 30, 44 * 6)  ;
            self.styleSelectTable.frame  = frame;
            [self.styleSelectTable reloadData];
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.styleSelectTable.frame ;
            frame.size.height = 0;
            self.styleSelectTable.frame  = frame;
        }];
    }
    [sender setTitle:animationChineseTitleMap[transitionAnimationStyle] forState:UIControlStateNormal];
    
    CGSize size =  [sender.currentTitle boundingRectWithSize:CGSizeMake(200, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} context:nil].size;
    size.width += 10 ;
    size.height += 8;
    CGRect frame =  _titleSelectStyleBtn.frame ;
    frame.size = size ;
    sender.frame = frame ;
}

- (void)configTitleSelectTypeBtn
{
    
    UIButton *titleBtn = [[UIButton alloc] init];
    _titleSelectStyleBtn = titleBtn ;
    [_titleSelectStyleBtn addTarget:self action:@selector(selectAnimationStyleClk:) forControlEvents:UIControlEventTouchUpInside];
    
    [_titleSelectStyleBtn setTitle:animationChineseTitleMap[transitionAnimationStyle] forState:UIControlStateNormal];
    [_titleSelectStyleBtn setTitle:@"select animation style" forState:UIControlStateSelected];
    [_titleSelectStyleBtn showsTouchWhenHighlighted];
    [_titleSelectStyleBtn setTitleColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    _titleSelectStyleBtn.clipsToBounds = YES ;
    _titleSelectStyleBtn.layer.cornerRadius = _cornerRadius;
    [_titleSelectStyleBtn setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
    [_titleSelectStyleBtn setBackgroundColor:[UIColor purpleColor]];
    //    _titleSelectStyleBtn.layer.cornerRadius = 10;
    //    _titleSelectStyleBtn.clipsToBounds = YES ;
    CGSize size =  [_titleSelectStyleBtn sizeThatFits:CGSizeMake(200, 30)];
    CGRect frame =  _titleSelectStyleBtn.frame ;
    frame.size = size ;
    _titleSelectStyleBtn.frame = frame ;
    
    self.navigationItem.titleView = _titleSelectStyleBtn;

}


- (void)dealloc
{
    NSLog(@"销毁 VC");
    indexer -- ;
}

@end
