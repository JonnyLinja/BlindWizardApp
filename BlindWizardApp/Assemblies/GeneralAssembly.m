//
//  GeneralAssembly.m
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GeneralAssembly.h"
#import "TyphoonConfigPostProcessor.h"
#import "TyphoonDefinition+Infrastructure.h"
#import <UIKit/UIKit.h>

#import "Queue.h"
#import "RandomGenerator.h"
#import "GridCalculator.h"
#import "GridStorage.h"
#import "GridStorageKeyGenerator.h"

@implementation GeneralAssembly

- (id)configurer {
    return [TyphoonDefinition configDefinitionWithName:@"GameConfig.plist"];
}

- (Queue *) queue {
    return [TyphoonDefinition withClass:[Queue class]];
}

- (RandomGenerator *) randomGenerator {
    //TODO: figure out how to do this with typhoon config
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"GameConfig" ofType:@"plist"];
    NSDictionary *gameConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
    NSArray *enemies = [gameConfig objectForKey:@"Enemies"];
    NSNumber *max = @(enemies.count);
    
    return [TyphoonDefinition withClass:[RandomGenerator class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithMinimum:maximum:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@1];
            [initializer injectParameterWith:max];
            //GameFlow needs to be manually injected after board is created
        }];
    }];
}

- (GridCalculator *) gridCalculatorWithSize:(CGSize)size {
    return [TyphoonDefinition withClass:[GridCalculator class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithSize:elementWidth:elementHeight:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[NSValue valueWithCGSize:size]];
            [initializer injectParameterWith:TyphoonConfig(@"EnemyWidth")];
            [initializer injectParameterWith:TyphoonConfig(@"EnemyHeight")];
        }];
    }];
}

- (GridStorage *) gridStorage {
    return nil;
}

- (GridStorageKeyGenerator *) gridStoryKeyGenerator {
    return [TyphoonDefinition withClass:[GridStorageKeyGenerator class]];
}

@end
