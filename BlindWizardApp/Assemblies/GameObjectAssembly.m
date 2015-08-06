//
//  GameObjectAssembly.m
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameObjectAssembly.h"
#import "TyphoonConfigPostProcessor.h"
#import "TyphoonDefinition+Infrastructure.h"

#import "EnemyView.h"
#import "EnemyViewModel.h"
#import "EnemyOutlineView.h"
#import "EnemyOutlineViewModel.h"
#import "GameObjectFactory.h"

@implementation GameObjectAssembly

- (id)configurer {
    return [TyphoonDefinition configDefinitionWithName:@"GameConfig.plist"];
}

- (EnemyView *) enemyViewWithViewModel:(EnemyViewModel *)viewModel {
    return [TyphoonDefinition withClass:[EnemyView class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithViewModel:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:viewModel];
        }];
    }];
}

- (EnemyViewModel *) enemyViewModelWithType:(NSNumber *)type configuration:(NSDictionary *)config {
    return [TyphoonDefinition withClass:[EnemyViewModel class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithType:animationDurations:configuration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:type];
            [initializer injectParameterWith:TyphoonConfig(@"Animations")];
            [initializer injectParameterWith:config];
        }];
    }];
}

- (EnemyOutlineView *) enemyOutlineViewWithViewModel:(EnemyOutlineViewModel *)viewModel {
    return [TyphoonDefinition withClass:[EnemyOutlineView class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithViewModel:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:viewModel];
        }];
    }];
}

- (EnemyOutlineViewModel *) enemyOutlineViewModelWithType:(NSNumber *)type configuration:(NSDictionary *)config {
    return [TyphoonDefinition withClass:[EnemyOutlineViewModel class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithType:animationDurations:configuration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:type];
            [initializer injectParameterWith:TyphoonConfig(@"Animations")];
            [initializer injectParameterWith:config];
        }];
    }];
}

- (GameObjectFactory *) gameObjectFactoryWithView:(UIView *)view gridCalculator:(GridCalculator *)calculator {
    return [TyphoonDefinition withClass:[GameObjectFactory class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithView:calculator:dependencyFactory:config:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:view];
            [initializer injectParameterWith:calculator];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:TyphoonConfig(@"Enemies")];
        }];
    }];
}

@end
