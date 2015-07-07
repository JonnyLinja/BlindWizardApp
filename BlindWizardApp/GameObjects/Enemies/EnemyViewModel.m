//
//  EnemyViewModel.m
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "EnemyViewModel.h"
#import <UIKit/UIKit.h>

@interface EnemyViewModel()
@property (nonatomic, assign) NSInteger enemyType;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGPoint movePoint;
@property (nonatomic, assign) CGPoint snapPoint;
@property (nonatomic, assign) CGFloat moveDuration;
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

- (void) runCreateAnimation {
    self.animationType = CreateAnimation;
}

- (void) animateMoveToCGPoint:(CGPoint)point {
    self.movePoint = point;
    self.animationType = MoveAnimation;
}

- (void) animateMoveToCGPoint:(CGPoint)movePoint thenSnapToCGPoint:(CGPoint)snapPoint {
    self.movePoint = movePoint;
    self.snapPoint = snapPoint;
    self.animationType = MoveAndSnapAnimation;
}

- (void) animateMoveAndRemoveToCGPoint:(CGPoint)point {
    self.movePoint = point;
    self.animationType = MoveAndRemoveAnimation;
}

- (void) runDangerAnimation {
    
}

- (void) stopDangerAnimation {
    
}

- (void) runDestroyAnimation {
    self.animationType = DestroyAndRemoveAnimation;
}

@end
