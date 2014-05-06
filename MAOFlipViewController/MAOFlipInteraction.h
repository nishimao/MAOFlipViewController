//
//  MAOFlipInteraction.h
//  MAOFlipViewController
//
//  Created by Mao Nishi on 2014/05/06.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipInteactionDelegate <NSObject>
- (void)interactionPushBeganAtPoint:(CGPoint)point;
- (void)interactionPopBeganAtPoint:(CGPoint)point;
- (void)completePopInteraction;
@end

@interface MAOFlipInteraction : UIPercentDrivenInteractiveTransition
@property (nonatomic, weak) id<FlipInteactionDelegate> delegate;
@property (nonatomic) UIView *view;
@property (nonatomic) BOOL isPushMode;
@end
