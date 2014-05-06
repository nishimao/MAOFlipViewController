//
//  MAOFlipInteraction.m
//  MAOFlipViewController
//
//  Created by Mao Nishi on 2014/05/06.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import "MAOFlipInteraction.h"
#import "MAOPanGestureRecognizer.h"

@implementation MAOFlipInteraction

- (void)setView:(UIView *)view
{
    _view = view;
    for (UIPanGestureRecognizer *r in view.gestureRecognizers) {
        if ([r isKindOfClass:[MAOPanGestureRecognizer class]]) {
            [view removeGestureRecognizer:r];
        }
    }
    UIPanGestureRecognizer *gesture =
    [[MAOPanGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(handlePan:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            // ジェスチャーを検出したらデリゲートを通じて画面遷移を開始する
            CGPoint nowPoint = [gesture locationInView:self.view];
            CGFloat boundary = (self.view.frame.origin.y + (self.view.frame.size.height / 2));
            if (boundary < nowPoint.y) {
                self.isPushMode = YES;
                [self.delegate interactionPushBeganAtPoint:nowPoint];
            }else{
                self.isPushMode = NO;
                [self.delegate interactionPopBeganAtPoint:nowPoint];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            // ジェスチャーの更新に合わせて画面遷移の進捗を更新する
            CGRect viewRect = self.view.bounds;
            CGPoint translation = [gesture translationInView:self.view];
            CGFloat percent = translation.y / viewRect.size.height;
            percent = fabsf(percent);
            percent = MIN(1.0, MAX(0.0, percent));
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGPoint nowPoint = [gesture locationInView:self.view];
            CGFloat boundary = (self.view.frame.origin.y + (self.view.frame.size.height / 2));
            if (self.isPushMode){//下から上にスワイプして進むモード
                if (boundary > nowPoint.y) {//現在の指の位置が上半分
                    [self finishInteractiveTransition];
                }else{
                    // 下方向に動かしていたらキャンセルとみなす
                    [self cancelInteractiveTransition];
                }
            }else{//上から下にスワイプして戻るモード
                if (boundary < nowPoint.y) {//現在の指の位置が上半分
                    [self finishInteractiveTransition];
                    
                    //呼び出し元にへ通知
                    [self.delegate completePopInteraction];
                }else{
                    // 上方向に動かしていたらキャンセルとみなす
                    [self cancelInteractiveTransition];
                }
            }
            break;
        }
        default:
            break;
    }
}

@end
