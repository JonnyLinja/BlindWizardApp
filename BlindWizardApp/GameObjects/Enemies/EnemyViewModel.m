//
//  EnemyViewModel.m
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "EnemyViewModel.h"
#import <UIKit/UIKit.h>

@interface EnemyViewModel ()
@property (nonatomic, assign) NSInteger enemyType;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGPoint movePoint;
@property (nonatomic, assign) CGPoint snapPoint;
@property (nonatomic, assign) CGFloat moveDuration;
@property (nonatomic, strong) NSString *face;
@property (nonatomic, assign) BOOL dangerous;
@property (nonatomic, assign) NSInteger score;
@end

@implementation EnemyViewModel

- (id) initWithType:(NSInteger)enemyType moveDuration:(CGFloat)moveDuration configuration:(NSDictionary *)configuration {
    self = [super init];
    if(!self) return nil;
    
    self.enemyType = enemyType;
    self.moveDuration = moveDuration;
    
    NSString *hexColor = [configuration objectForKey:@"Color"];
    self.color = [self colorFromHexString:hexColor];
    
    return self;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void) updateFace {
    switch (self.animationType) {
        case NoAnimation:
        case CreateAnimation:
            if(self.dangerous) {
                self.face = @"*෴*";
            }else {
                self.face = @"'‸'";
            }
            break;
        case MoveAnimation:
        case MoveAndRemoveAnimation:
        case SnapAndMoveAnimation:
            self.face = @"ᵔ.ᵔ";
            break;
        case DestroyAndRemoveAnimation:
            self.face = [NSString stringWithFormat:@"%li", self.score];
            break;
        default:
            break;
    }
}

- (void) runNeutralAnimation {
    [self updateFace];
}

- (void) runCreateAnimation {
    self.animationType = CreateAnimation;
    [self updateFace];
}

- (void) animateMoveToCGPoint:(CGPoint)point {
    self.movePoint = point;
    self.animationType = MoveAnimation;
    [self updateFace];
    
    //TODO: find a way around this hack
    //hack since KVO system doesn't fire if setting to save value sadly
    //dispatch after hack since not sure how to test setting of the type rapidly
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.animationType = NoAnimation;
    });
}

- (void) snapToCGPoint:(CGPoint)snapPoint thenAnimateMoveToCGPoint:(CGPoint)movePoint {
    self.movePoint = movePoint;
    self.snapPoint = snapPoint;
    self.animationType = SnapAndMoveAnimation;
    [self updateFace];
    
    //TODO: find a way around this hack
    //hack since KVO system doesn't fire if setting to save value sadly
    //dispatch after hack since not sure how to test setting of the type rapidly
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.animationType = NoAnimation;
    });
}

- (void) animateMoveAndRemoveToCGPoint:(CGPoint)point {
    self.movePoint = point;
    self.animationType = MoveAndRemoveAnimation;
    [self updateFace];
}

- (void) runDangerAnimation {
    self.dangerous = YES;
    [self updateFace];
}

- (void) stopDangerAnimation {
    self.dangerous = NO;
    [self updateFace];
}

- (void) runDestroyAnimationWithScore:(NSInteger)score {
    self.score = score;
    self.animationType = DestroyAndRemoveAnimation;
    [self updateFace];
}

@end
