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
    return 0.35f;
}

- (UIView *)createUpperHalf:(UIView *)view
{
    CGRect snapRect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height / 2);
    UIView *topHalf = [view resizableSnapshotViewFromRect:snapRect afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    topHalf.userInteractionEnabled = NO;
    return topHalf;
}

- (UIView *)createBottomHalf:(UIView *)view
{
    CGRect snapRect = CGRectMake(0, CGRectGetMidY(view.frame), view.frame.size.width, view.frame.size.height / 2);
    UIView *bottomHalf = [view resizableSnapshotViewFromRect:snapRect afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    CGRect newFrame = CGRectOffset(bottomHalf.frame, 0, bottomHalf.bounds.size.height);
    bottomHalf.frame = newFrame;
    bottomHalf.userInteractionEnabled = NO;
    return bottomHalf;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //遷移元のビューコントローラーとビューを取得
    UIViewController *sourceVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *destinationVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    UIView *sourceView = sourceVC.view;
    UIView *destinationView = destinationVC.view;
    
    UIView *sourceSnapshot = [sourceView snapshotViewAfterScreenUpdates:NO];
    
    //アニメーションを実行するためのコンテナビューを取得
    UIView *containerView = [transitionContext containerView];
    
    //遷移先のスナップショットを取る
    UIView *destinationSnapshot = [destinationView snapshotViewAfterScreenUpdates:YES];
    
    CGFloat w = CGRectGetWidth(sourceSnapshot.frame);
    CGFloat h = CGRectGetHeight(sourceSnapshot.frame) / 2.0f;
    
    UIView *sourceUpperView = [self createUpperHalf:sourceSnapshot];
    UIView *sourceBottomView = [self createBottomHalf:sourceSnapshot];
    
    UIView *destinationUpperView = [self createUpperHalf:destinationSnapshot];
    UIView *destinationBottomView = [self createBottomHalf:destinationSnapshot];
    
    CGFloat minShadow = 0.0f;
    CGFloat maxShadow = 0.7f;
    
    UIView *sourceUpperShadow = [[UIView alloc] initWithFrame:sourceUpperView.frame];
    sourceUpperShadow.backgroundColor = [UIColor blackColor];
    
    UIView *sourceBottomShadow = [[UIView alloc] initWithFrame:sourceBottomView.frame];
    sourceBottomShadow.backgroundColor = [UIColor blackColor];
    
    UIView *destinationUpperShadow = [[UIView alloc] initWithFrame:destinationUpperView.frame];
    destinationUpperShadow.backgroundColor = [UIColor blackColor];
    
    UIView *destinationBottomShadow = [[UIView alloc] initWithFrame:destinationBottomView.frame];
    destinationBottomShadow.backgroundColor = [UIColor blackColor];
    
    
    
    //上下のスナップショットをコンテナに配置
    [containerView addSubview:sourceUpperView];
    [containerView addSubview:sourceBottomView];
    
    
    
    if (self.presenting) {
        //Pushの動作。上にめくる
        
        //高さ0にしておく
        [destinationUpperView setFrame:CGRectMake(0, destinationUpperView.frame.size.height,
                                                  destinationUpperView.frame.size.width, 0)];
        
        //遷移先のビューをスナップショットの下に挿入
        [containerView insertSubview:destinationVC.view belowSubview:sourceUpperView];
        
        //めくり先の上のビュー
        [containerView addSubview:destinationUpperView];
        
        
        // Add shadows
        destinationUpperShadow.frame = destinationUpperView.frame;
        
        sourceUpperShadow.alpha = minShadow;
        sourceBottomShadow.alpha = minShadow;
        destinationUpperShadow.alpha = minShadow;
        destinationBottomShadow.alpha = maxShadow;
        
        [containerView insertSubview:sourceUpperShadow aboveSubview:sourceUpperView];
        [containerView insertSubview:sourceBottomShadow aboveSubview:sourceBottomView];
        [containerView insertSubview:destinationUpperShadow aboveSubview:destinationUpperView];
        [containerView insertSubview:destinationBottomShadow belowSubview:sourceBottomView];
        
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
                                           sourceBottomView.frame = CGRectMake(0, sourceBottomView.frame.origin.y, w, 0);
                                           sourceBottomShadow.frame = sourceBottomView.frame;
                                           sourceBottomShadow.alpha = maxShadow * 0.5;
                                           destinationUpperShadow.alpha = maxShadow * 0.5;
                                           destinationBottomShadow.alpha = minShadow;
                                       }];
                                      
                                      // 2つ目のKey-frame: 回転アニメーション
                                      [UIView addKeyframeWithRelativeStartTime:0.5
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           destinationUpperView.frame = CGRectMake(0, 0, w, h);
                                           destinationUpperShadow.frame = destinationUpperView.frame;
                                           destinationUpperShadow.alpha = minShadow;
                                           sourceUpperShadow.alpha = maxShadow;
                                       }];
                                  }
                                  completion:^(BOOL finished){
                                      [sourceBottomView removeFromSuperview];//不要になるため削除する
                                      [sourceUpperView removeFromSuperview];//遷移元の上半分は不要になるため削除する
                                      [destinationUpperView removeFromSuperview];
                                      [destinationBottomView removeFromSuperview];
                                      
                                      // Remove shadows
                                      [sourceUpperShadow removeFromSuperview];
                                      [sourceBottomShadow removeFromSuperview];
                                      [destinationUpperShadow removeFromSuperview];
                                      [destinationBottomShadow removeFromSuperview];
                                      
                                      // 画面遷移終了を通知
                                      BOOL completed = ![transitionContext transitionWasCancelled];
                                      [transitionContext completeTransition:completed];
                                  }
         ];
        
    }else{
        //POPの動作。下にめくる。
        
        //高さ設定しておく
        //高さ0にしておく
        [containerView addSubview:destinationBottomView];
        
        [destinationBottomView setFrame:CGRectMake(0, h, w, 0)];
        
        //遷移先のビューをスナップショットの下に挿入
        [containerView insertSubview:destinationVC.view belowSubview:sourceUpperView];
        
        // Add shadows
        destinationBottomShadow.frame = destinationBottomView.frame;
        
        sourceUpperShadow.alpha = minShadow;
        sourceBottomShadow.alpha = minShadow;
        destinationUpperShadow.alpha = maxShadow;
        destinationBottomShadow.alpha = minShadow;
        
        [containerView insertSubview:sourceUpperShadow aboveSubview:sourceUpperView];
        [containerView insertSubview:sourceBottomShadow aboveSubview:sourceBottomView];
        [containerView insertSubview:destinationUpperShadow belowSubview:sourceUpperView];
        [containerView insertSubview:destinationBottomShadow aboveSubview:destinationBottomView];
        
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
                                           sourceUpperView.frame = CGRectMake(0, h, w, 0);
                                           sourceUpperShadow.frame = sourceUpperView.frame;
                                           sourceUpperShadow.alpha = maxShadow * 0.5f;
                                           destinationBottomShadow.alpha = maxShadow * 0.5f;
                                           destinationUpperShadow.alpha = minShadow;
                                       }];
                                      
                                      // 2つ目のKey-frame: 回転アニメーション
                                      [UIView addKeyframeWithRelativeStartTime:0.5
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           destinationBottomView.frame = CGRectMake(0, h, w, h);
                                           destinationBottomShadow.frame = destinationBottomView.frame;
                                           destinationBottomShadow.alpha = minShadow;
                                           sourceUpperShadow.alpha = maxShadow;
                                           sourceBottomShadow.alpha = maxShadow;
                                       }];
                                  }
                                  completion:^(BOOL finished){
                                      [sourceBottomView removeFromSuperview];//遷移元の上半分は不要になるため削除する
                                      [sourceUpperView removeFromSuperview];//不要になるため削除する
                                      [destinationUpperView removeFromSuperview];
                                      [destinationBottomView removeFromSuperview];
                                      
                                      
                                      // Remove shadows
                                      [sourceUpperShadow removeFromSuperview];
                                      [sourceBottomShadow removeFromSuperview];
                                      [destinationUpperShadow removeFromSuperview];
                                      [destinationBottomShadow removeFromSuperview];
                                      
                                      // 画面遷移終了を通知
                                      BOOL completed = ![transitionContext transitionWasCancelled];
                                      [transitionContext completeTransition:completed];
                                  }
         ];
        
    }
    
}

@end
