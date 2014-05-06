//
//  MAOFlipTransition.m
//  MAOFlipViewController
//
//  Created by Mao Nishi on 2014/05/06.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import "MAOFlipTransition.h"

@implementation MAOFlipTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (UIImageView*)createImageView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [[UIImageView alloc]initWithImage:viewSnapShot];
}

- (UIImageView*)createImageViewUpper:(UIImageView*)view
{
    CGSize snapSize = CGSizeMake(view.frame.size.width, view.frame.size.height / 2);
    UIGraphicsBeginImageContext(snapSize);
    [view.image drawAtPoint:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height / 2).origin];
    UIImage *aboveViewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *aboveSnapView = [[UIImageView alloc]initWithImage:aboveViewSnapShot];
    aboveSnapView.contentMode = UIViewContentModeScaleToFill;
    [aboveSnapView setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height / 2)];
    return aboveSnapView;
}

- (UIImageView*)createImageViewBottom:(UIImageView*)view
{
    CGSize snapSize = CGSizeMake(view.frame.size.width, view.frame.size.height / 2);
    UIGraphicsBeginImageContext(snapSize);
    [view.image drawAtPoint:CGRectMake(0, - (view.frame.size.height / 2), view.frame.size.width, view.frame.size.height / 2).origin];
    UIImage *bottomViewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *bottomSnapView = [[UIImageView alloc]initWithImage:bottomViewSnapShot];
    bottomSnapView.contentMode = UIViewContentModeScaleToFill;
    [bottomSnapView setFrame:CGRectMake(0, view.frame.size.height / 2, view.frame.size.width, view.frame.size.height / 2)];
    return bottomSnapView;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //遷移元のビューコントローラーとビューを取得
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIImageView *fromView = [self createImageView:fromVC.view];
    
    //アニメーションを実行するためのコンテナビューを取得
    UIView *containerView = [transitionContext containerView];
    
    //遷移先のスナップショットを取る
    UIImageView *toSnapshot = [self createImageView:toVC.view];
    
    CGFloat w = CGRectGetWidth(fromView.frame);
    CGFloat h = CGRectGetHeight(fromView.frame) / 2.0f;
    
    UIImageView *fromUpperView = [self createImageViewUpper:fromView];
    UIImageView *fromBottomView = [self createImageViewBottom:fromView];
    
    UIImageView *toUpperView = [self createImageViewUpper:toSnapshot];
    UIImageView *toBottomView = [self createImageViewBottom:toSnapshot];
    
    //上下のスナップショットをコンテナに配置
    [containerView addSubview:fromUpperView];
    [containerView addSubview:fromBottomView];
    
    if (self.presenting) {
        //Pushの動作。上にめくる
        
        //高さ0にしておく
        [toUpperView setFrame:CGRectMake(0, toUpperView.frame.size.height, toUpperView.frame.size.width, 0)];
        
        //遷移先のビューをスナップショットの下に挿入
        [containerView insertSubview:toVC.view belowSubview:fromUpperView];
        
        //めくり先の上のビュー
        [containerView addSubview:toUpperView];
        
        //切れ目がないアニメーション
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                       delay:0
                                     options:0
                                  animations:^{
                                      // 1つ目のKey-frame: スライドアニメーション
                                      //下半分をセッティング
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           fromBottomView.frame = CGRectMake(0, fromBottomView.frame.origin.y, w, 0);
                                       }];
                                      
                                      // 2つ目のKey-frame: 回転アニメーション
                                      [UIView addKeyframeWithRelativeStartTime:0.5
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           toUpperView.frame = CGRectMake(0, 0, w, h);
                                       }];
                                  }
                                  completion:^(BOOL finished){
                                      [fromBottomView removeFromSuperview];//不要になるため削除する
                                      [fromUpperView removeFromSuperview];//遷移元の上半分は不要になるため削除する
                                      
                                      // 画面遷移終了を通知
                                      BOOL completed = ![transitionContext transitionWasCancelled];
                                      [transitionContext completeTransition:completed];
                                  }
         ];
        
    }else{
        //POPの動作。下にめくる。
        
        //高さ設定しておく
        //高さ0にしておく
        [containerView addSubview:toBottomView];
        
        [toBottomView setFrame:CGRectMake(0, h, w, 0)];
        
        //遷移先のビューをスナップショットの下に挿入
        [containerView insertSubview:toVC.view belowSubview:fromUpperView];
        
        //切れ目がないアニメーション
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                       delay:0
                                     options:0
                                  animations:^{
                                      // 1つ目のKey-frame: スライドアニメーション
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           fromUpperView.frame = CGRectMake(0, h, w, 0);
                                       }];
                                      
                                      // 2つ目のKey-frame: 回転アニメーション
                                      [UIView addKeyframeWithRelativeStartTime:0.5
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           toBottomView.frame = CGRectMake(0, h, w, h);
                                       }];
                                  }
                                  completion:^(BOOL finished){
                                      [fromBottomView removeFromSuperview];//遷移元の上半分は不要になるため削除する
                                      [fromUpperView removeFromSuperview];//不要になるため削除する
                                      [toBottomView removeFromSuperview];
                                      
                                      // 画面遷移終了を通知
                                      BOOL completed = ![transitionContext transitionWasCancelled];
                                      [transitionContext completeTransition:completed];
                                  }
         ];
        
    }
    
}

@end
