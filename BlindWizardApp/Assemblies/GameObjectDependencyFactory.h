//
//  GameObjectDependencyFactory.h
//  BlindWizardApp
//
//  Created by N A on 7/7/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

@class EnemyView;
@class EnemyViewModel;

@class EnemyOutlineView;
@class EnemyOutlineViewModel;

@protocol GameObjectDependencyFactory <NSObject>
- (EnemyView *) enemyViewWithViewModel:(EnemyViewModel *)viewModel;
- (EnemyViewModel *) enemyViewModelWithType:(NSNumber *)type configuration:(NSDictionary *)config;
- (EnemyOutlineView *) enemyOutlineViewWithViewModel:(EnemyOutlineViewModel *)viewModel;
- (EnemyOutlineViewModel *) enemyOutlineViewModelWithType:(NSNumber *)type configuration:(NSDictionary *)config;
@end