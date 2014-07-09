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
            
            NSLog(@"Gesture began...");
            
            CGPoint nowPoint = [gesture locationInView:self.view];
            CGFloat boundary = CGRectGetMidY(self.view.frame);
            CGPoint velocity = [gesture velocityInView:self.view];
            
            BOOL isDownwards = (velocity.y > 0);
            
            if (isDownwards) {
                NSLog(@"Downwards...");
            } else {
                NSLog(@"Upwards...");
            }
            
            
            NSLog(@"Point: %@ | Boundary: %@", NSStringFromCGPoint(nowPoint), @(boundary));
            
            if (boundary < nowPoint.y) {
                if (isDownwards) break;
                self.isPushMode = YES;
                [self.delegate interactionPushBeganAtPoint:nowPoint];
            } else {
                if (!isDownwards) break;
                self.isPushMode = NO;
                [self.delegate interactionPopBeganAtPoint:nowPoint];
            }
            
            NSLog(@"MODE: %@", self.isPushMode ? @"PUSH" : @"POP");
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            
            CGRect viewRect = self.view.bounds;
            CGPoint translation = [gesture translationInView:self.view];
            CGFloat percent = translation.y / viewRect.size.height;
            percent = fabsf(percent);
            percent = MIN(1.0, MAX(0.0, percent));
            [self updateInteractiveTransition:percent];
            
            //NSLog(@"Gesture changed...");
            //NSLog(@"Translation: %@ | Percent: %@", NSStringFromCGPoint(translation), @(percent));
            
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
            if (self.isPushMode){
                if (boundary > nowPoint.y) {
                    [self finishInteractiveTransition];
                } else {
                    [self cancelInteractiveTransition];
                }
            } else {
                if (boundary < nowPoint.y) {
                    [self finishInteractiveTransition];
                    
                    [self.delegate completePopInteraction];
                }else{
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
