//
//  EnemyOutlineViewModel.h
//  BlindWizardApp
//
//  Created by N A on 8/5/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NoOutlineAnimation,
    CreateOutlineAnimation,
    DestroyAndRemoveOutlineAnimation
} EnemyOutlineAnimationType;

@class UIColor;

@interface EnemyOutlineViewModel : NSObject
- (id) initWithType:(NSInteger)enemyType animationDurations:(NSDictionary *)animationDurations configuration:(NSDictionary *)configuration;
@property (nonatomic, strong, readonly) UIColor *color;
@property (nonatomic, assign) EnemyOutlineAnimationType animationType;
- (void) runCreateAnimation;
- (void) runDestroyAnimation;
@end
