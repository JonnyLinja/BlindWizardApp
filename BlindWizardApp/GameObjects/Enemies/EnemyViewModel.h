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
    SnapAndMoveAnimation,
    MoveAndRemoveAnimation
} EnemyAnimationType;

@class UIColor;

@interface EnemyViewModel : NSObject
- (id) initWithType:(NSInteger)enemyType moveDuration:(CGFloat)moveDuration configuration:(NSDictionary *)configuration;
@property (nonatomic, assign, readonly) NSInteger enemyType;
@property (nonatomic, assign, readonly) CGPoint movePoint;
@property (nonatomic, assign, readonly) CGPoint snapPoint;
@property (nonatomic, assign, readonly) CGFloat moveDuration;
@property (nonatomic, strong, readonly) UIColor *color;
@property (nonatomic, assign) EnemyAnimationType animationType;
@property (nonatomic, strong, readonly) NSString *face;
- (void) runNeutralAnimation;
- (void) runCreateAnimation;
- (void) animateMoveToCGPoint:(CGPoint)point;
- (void) snapToCGPoint:(CGPoint)snapPoint thenAnimateMoveToCGPoint:(CGPoint)movePoint;
- (void) animateMoveAndRemoveToCGPoint:(CGPoint)point;
- (void) runDangerAnimation;
- (void) stopDangerAnimation;
- (void) runDestroyAnimation;
@end
