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
@property (nonatomic, assign) CGFloat shiftAnimationDuration;
@property (nonatomic, assign) CGFloat dropAnimationDuration;
@property (nonatomic, assign) CGFloat dangerAnimationDuration;
@property (nonatomic, assign) CGFloat createAnimationDuration;
@property (nonatomic, assign) CGFloat destroyAnimationDuration;
@property (nonatomic, strong) NSString *face;
@property (nonatomic, assign) BOOL dangerous;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) BOOL shouldFlicker;
@end

@implementation EnemyViewModel

- (id) initWithType:(NSInteger)enemyType animationDurations:(NSDictionary *)animationDurations configuration:(NSDictionary *)configuration {
    self = [super init];
    if(!self) return nil;
    
    self.enemyType = enemyType;
    
    self.shiftAnimationDuration = [[animationDurations objectForKey:@"ShiftAnimationDuration"] floatValue];
    self.dropAnimationDuration = [[animationDurations objectForKey:@"DropAnimationDuration"] floatValue];
    self.dangerAnimationDuration = [[animationDurations objectForKey:@"DangerAnimationDuration"] floatValue];
    self.createAnimationDuration = [[animationDurations objectForKey:@"CreateAnimationDuration"] floatValue];
    self.destroyAnimationDuration = [[animationDurations objectForKey:@"DestroyAnimationDuration"] floatValue];

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
        case DropAnimation:
            self.face = @"‾᷅⚰‾᷄";
            break;
        case MoveAnimation:
        case MoveAndRemoveAnimation:
        case SnapAndMoveAnimation:
            self.face = @"ᵔ.ᵔ";
            break;
        case DestroyAndRemoveAnimation:
            self.face = [NSString stringWithFormat:@"%zd", self.score];
            break;
        default:
            break;
    }
}

- (void) runNeutralAnimation {
    self.animationType = NoAnimation;
    [self updateFace];
}

- (void) runCreateAnimation {
    self.animationType = CreateAnimation;
    [self updateFace];
}

- (void) animateMoveToCGPoint:(CGPoint)point {
    self.movePoint = point;
    self.animationType = NoAnimation; //hack as the KVO framework doesn't run on anim type being set to the same value - not under test
    self.animationType = MoveAnimation;
    [self updateFace];
}

- (void) animateDropToCGPoint:(CGPoint)point {
    self.movePoint = point;
    self.animationType = NoAnimation; //hack as the KVO framework doesn't run on anim type being set to the same value - not under test
    self.animationType = DropAnimation;
    [self updateFace];
}

- (void) snapToCGPoint:(CGPoint)snapPoint thenAnimateMoveToCGPoint:(CGPoint)movePoint {
    self.movePoint = movePoint;
    self.snapPoint = snapPoint;
    self.animationType = NoAnimation; //hack as the KVO framework doesn't run on anim type being set to the same value - not under test
    self.animationType = SnapAndMoveAnimation;
    [self updateFace];
}

- (void) animateMoveAndRemoveToCGPoint:(CGPoint)point {
    self.movePoint = point;
    self.animationType = MoveAndRemoveAnimation;
    [self updateFace];
}

- (void) runDangerAnimation {
    self.dangerous = YES;
    [self updateFace];
    self.shouldFlicker = YES;
}

- (void) stopDangerAnimation {
    self.dangerous = NO;
    [self updateFace];
    self.shouldFlicker = NO;
}

- (void) runDestroyAnimationWithScore:(NSInteger)score {
    self.score = score;
    self.animationType = DestroyAndRemoveAnimation;
    [self updateFace];
}

@end
