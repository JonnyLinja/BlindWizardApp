//
//  EnemyViewModel.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef enum {
    NoAnimation,
    CreateAnimation,
    DestroyAndRemoveAnimation,
    MoveAnimation,
    MoveAndSnapAnimation,
    MoveAndRemoveAnimation
} EnemyAnimationType;

@class UIColor;

@interface EnemyViewModel : NSObject
@property (nonatomic, assign) NSInteger enemyType;
@property (nonatomic, assign) EnemyAnimationType animationType;
@property (nonatomic, assign, readonly) CGPoint movePoint;
@property (nonatomic, assign, readonly) CGPoint snapPoint;
@property (nonatomic, assign, readonly) CGFloat moveDuration;
@property (nonatomic, assign, readonly) UIColor *color;
- (void) runCreateAnimation;
- (void) animateMoveToCGPoint:(CGPoint)point;
- (void) animateMoveToCGPoint:(CGPoint)movePoint thenSnapToCGPoint:(CGPoint)snapPoint;
- (void) animateMoveAndRemoveToCGPoint:(CGPoint)point;
- (void) runDangerAnimation;
- (void) stopDangerAnimation;
- (void) runDestroyAnimation;
@end
