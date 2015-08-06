//
//  GameObjectFactory.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameObjectDependencyFactory;
@class EnemyViewModel;
@class EnemyOutlineViewModel;
@class GridCalculator;

@interface GameObjectFactory : NSObject
- (id) initWithView:(UIView *)view calculator:(GridCalculator *)calculator dependencyFactory:(id<GameObjectDependencyFactory>)factory config:(NSArray *)config;
- (EnemyViewModel *) createEnemyWithType:(NSInteger)type atRow:(NSInteger)row column:(NSInteger)column;
- (EnemyOutlineViewModel *) createEnemyOutlineWithType:(NSInteger)type atRow:(NSInteger)row column:(NSInteger)column;

@end
