//
//  GameObjectFactory.h
//  BlindWizardApp
//
//  Created by N A on 6/26/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObjectDependencyFactory.h"

@class EnemyViewModel;
@class GridCalculator;

@interface GameObjectFactory : NSObject
- (id) initWithView:(UIView *)view calculator:(GridCalculator *)calculator dependencyFactory:(id<GameObjectDependencyFactory>)factory;
- (EnemyViewModel *) createEnemyWithType:(NSInteger)type atRow:(NSInteger)row column:(NSInteger)column;
@end
