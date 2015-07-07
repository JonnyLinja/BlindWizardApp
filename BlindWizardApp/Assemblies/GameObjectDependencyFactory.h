//
//  GameObjectDependencyFactory.h
//  BlindWizardApp
//
//  Created by N A on 7/7/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

@class EnemyView;
@class EnemyViewModel;

@protocol GameObjectDependencyFactory <NSObject>
- (EnemyView *) enemyViewWithViewModel:(EnemyViewModel *)viewModel;
- (EnemyViewModel *) enemyViewModelWithType:(NSInteger)type configuration:(NSDictionary *)config;
@end