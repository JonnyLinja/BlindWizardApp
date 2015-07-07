//
//  GameObjectAssemby.m
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameObjectAssemby.h"
#import "EnemyView.h"
#import "EnemyViewModel.h"
#import "GameObjectFactory.h"

@implementation GameObjectAssemby

- (EnemyView *) enemyViewWithViewModel:(EnemyViewModel *)viewModel {
    return [TyphoonDefinition withClass:[EnemyView class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithViewModel:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:viewModel];
        }];
    }];
}

- (EnemyViewModel *) enemyViewModelWithType:(NSInteger)type configuration:(NSDictionary *)config {
    return [TyphoonDefinition withClass:[EnemyViewModel class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithType:configuration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@(type)];
            [initializer injectParameterWith:config];
        }];
    }];
}

- (GameObjectFactory *) gameObjectFactoryWithView:(UIView *)view gridCalculator:(GridCalculator *)calculator {
    return [TyphoonDefinition withClass:[GameObjectFactory class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithView:calculator:dependencyFactory:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:view];
            [initializer injectParameterWith:calculator];
            [initializer injectParameterWith:self];
        }];
    }];
}

@end
