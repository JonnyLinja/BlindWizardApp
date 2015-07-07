//
//  GeneralAssembly.m
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GeneralAssembly.h"
#import "TyphoonDefinition+Infrastructure.h"

#import "Queue.h"
#import "RandomGenerator.h"
#import "GridStorage.h"

@implementation GeneralAssembly

- (id)configurer {
    return [TyphoonDefinition configDefinitionWithName:@"GameConfig.plist"];
}

- (Queue *) queue {
    return [TyphoonDefinition withClass:[Queue class]];
}

- (RandomGenerator *) randomGenerator {
    //TODO: grab data from config file
    return [TyphoonDefinition withClass:[RandomGenerator class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithMinimum:maximum:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@1];
            [initializer injectParameterWith:@5];
            //GameFlow needs to be manually injected after board is created
        }];
    }];
}

- (GridStorage *) gridStorage {
    return nil;
}

@end
