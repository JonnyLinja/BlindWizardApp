//
//  GameObjectAssembly.h
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "TyphoonAssembly.h"
#import "GameObjectDependencyFactory.h"
#import "GameObjectFactoryFactory.h"

@class GameObjectFactory;
@class EnemyView;
@class EnemyViewModel;
@class UIView;

@interface GameObjectAssembly : TyphoonAssembly <GameObjectDependencyFactory, GameObjectFactoryFactory>
- (EnemyView *) enemyViewWithViewModel:(EnemyViewModel *)viewModel;
- (EnemyViewModel *) enemyViewModelWithType:(NSInteger)type configuration:(NSDictionary *)config;
- (GameObjectFactory *) gameObjectFactoryWithView:(UIView *)view gridCalculator:(GridCalculator *)calculator;
@end
