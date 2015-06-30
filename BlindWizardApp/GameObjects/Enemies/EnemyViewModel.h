//
//  EnemyViewModel.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface EnemyViewModel : NSObject
@property (nonatomic, readonly) NSInteger enemyType;
- (void) runCreateAnimation;
- (void) animateMoveToCGPoint:(CGPoint)point;
- (void) animateMoveToCGPoint:(CGPoint)movePoint thenSnapToCGPoint:(CGPoint)snapPoint;
- (void) animateMoveToCGPoint:(CGPoint)point removeAfter:(BOOL)remove;
- (void) runDangerAnimation;
- (void) stopDangerAnimation;
- (void) runDestroyAnimation;
@end
