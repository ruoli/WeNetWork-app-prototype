//
//  ECSlidingViewController.h
//  WeNetwork
//
//  Created by Ruoli Zhou on 05/03/2014.
//  Copyright (c) 2014 Deszie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageWithUIView.h"

extern NSString *const ECSlidingViewUnderRightWillAppear;

extern NSString *const ECSlidingViewUnderLeftWillAppear;

extern NSString *const ECSlidingViewUnderLeftWillDisappear;

extern NSString *const ECSlidingViewUnderRightWillDisappear;

extern NSString *const ECSlidingViewTopDidAnchorLeft;

extern NSString *const ECSlidingViewTopDidAnchorRight;

extern NSString *const ECSlidingViewTopWillReset;

extern NSString *const ECSlidingViewTopDidReset;

typedef enum {
  ECFullWidth,
  ECFixedRevealWidth,
  ECVariableRevealWidth
} ECViewWidthLayout;

typedef enum {
  ECLeft,
  ECRight
} ECSide;

typedef enum {
  ECNone = 0,
  ECTapping = 1 << 0,
  ECPanning = 1 << 1
} ECResetStrategy;

@interface ECSlidingViewController : UIViewController{
  CGPoint startTouchPosition;
  BOOL topViewHasFocus;
}

@property (nonatomic, strong) UIViewController *underLeftViewController;

@property (nonatomic, strong) UIViewController *underRightViewController;

@property (nonatomic, strong) UIViewController *topViewController;

@property (nonatomic, unsafe_unretained) CGFloat anchorLeftPeekAmount;

@property (nonatomic, unsafe_unretained) CGFloat anchorRightPeekAmount;

@property (nonatomic, unsafe_unretained) CGFloat anchorLeftRevealAmount;

@property (nonatomic, unsafe_unretained) CGFloat anchorRightRevealAmount;

@property (nonatomic, unsafe_unretained) BOOL shouldAllowUserInteractionsWhenAnchored;

@property (nonatomic, unsafe_unretained) BOOL shouldAddPanGestureRecognizerToTopViewSnapshot;

@property (nonatomic, unsafe_unretained) ECViewWidthLayout underLeftWidthLayout;

@property (nonatomic, unsafe_unretained) ECViewWidthLayout underRightWidthLayout;

@property (nonatomic, unsafe_unretained) ECResetStrategy resetStrategy;

- (UIPanGestureRecognizer *)panGesture;

- (void)anchorTopViewTo:(ECSide)side;

- (void)anchorTopViewTo:(ECSide)side animations:(void(^)())animations onComplete:(void(^)())complete;

- (void)anchorTopViewOffScreenTo:(ECSide)side;

- (void)anchorTopViewOffScreenTo:(ECSide)side animations:(void(^)())animations onComplete:(void(^)())complete;

- (void)resetTopView;

- (void)resetTopViewWithAnimations:(void(^)())animations onComplete:(void(^)())complete;

- (BOOL)underLeftShowing;

- (BOOL)underRightShowing;

- (BOOL)topViewIsOffScreen;

@end

@interface UIViewController(SlidingViewExtension)
- (ECSlidingViewController *)slidingViewController;
@end