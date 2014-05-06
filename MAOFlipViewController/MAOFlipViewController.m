//
//  MAOFlipViewController.m
//  MAOFlipViewController
//
//  Created by Mao Nishi on 2014/05/06.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import "MAOFlipViewController.h"
#import "MAOFlipInteraction.h"
#import "MAOFlipTransition.h"

@interface MAOFlipViewController ()<FlipInteactionDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
@property (nonatomic) UINavigationController *flipNavigationController;
@property (nonatomic) MAOFlipInteraction *flipInteraction;
@property (nonatomic) MAOFlipTransition *flipTransition;
@end

@implementation MAOFlipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIViewController *c = [self.delegate flipViewController:self contentIndex:0];
    if (c) {
        
        //ジェスチャーイベント設定
        self.flipInteraction = MAOFlipInteraction.new;
        self.flipInteraction.delegate = self;
        [self.flipInteraction setView:c.view];
        self.flipNavigationController = [[UINavigationController alloc]initWithRootViewController:c];
        self.flipNavigationController.delegate = self;
        [self.flipNavigationController.navigationBar setHidden:YES];
        
        [self addChildViewController:self.flipNavigationController];
        self.flipNavigationController.view.frame = self.view.frame;
        [self.view addSubview:self.flipNavigationController.view];
        
        [self.flipNavigationController didMoveToParentViewController:self];
    }
}

#pragma mark - FlipInteractionDelegate
//画面遷移開始
- (void)interactionPushBeganAtPoint:(CGPoint)point
{
    UIViewController *c = [self nextViewController];
    if (!c) {
        return;
    }
    [self.flipInteraction setView:c.view];//インタラクション対象viewの設定。遷移先のview
    [self.flipNavigationController pushViewController:c animated:YES];
}
- (void)interactionPopBeganAtPoint:(CGPoint)point
{
    [self.flipNavigationController popViewControllerAnimated:YES];
}

- (UIViewController*)nextViewController
{
    //既に存在している場合は一つ次のviewController取り出し
    NSInteger targetIndex = self.flipNavigationController.viewControllers.count;
    
    //予定枚数を超えている場合はなし
    if ([self.delegate numberOfFlipViewControllerContents] <= targetIndex) {
        return nil;
    }
    
    UIViewController *c = [self.delegate flipViewController:self contentIndex:(targetIndex)];
    return c;
}

- (void)completePopInteraction
{
    //インタラクション対象のviewを設定する
    UIViewController *c = [self.flipNavigationController.viewControllers lastObject];
    [self.flipInteraction setView:c.view];
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return self.flipInteraction;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:
(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    self.flipTransition = [[MAOFlipTransition alloc]init];
    if (operation == UINavigationControllerOperationPush) {
        self.flipTransition.presenting = YES;
    }else{
        self.flipTransition.presenting = NO;
    }
    return self.flipTransition;
}

@end