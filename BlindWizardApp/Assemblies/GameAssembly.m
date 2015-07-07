//
//  GameAssembly.m
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAssembly.h"
#import "GeneralAssembly.h"

#import "Game.h"
#import "GameBoard.h"
#import "GameFlow.h"

@implementation GameAssembly

- (Game *) game {
    return [TyphoonDefinition withClass:[Game class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithDependencyFactory:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self];
            //GameFlow needs to be manually injected after board is created
        }];
    }];
}

- (GameBoard *) gameBoardWithRows:(NSInteger)rows columns:(NSInteger)columns {
    return [TyphoonDefinition withClass:[GameBoard class]];
}

- (GameFlow *) gameFlowWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[GameFlow class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:queue:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:[self.generalAssembly queue]];
        }];
    }];
}

- (id<GameAction>) callNextWaveGameActionWithBoard:(GameBoard *)board {
    return nil;
}

- (id<GameAction>) checkLoseGameActionWithBoard:(GameBoard *)board {
    return nil;
}

- (id<GameAction>) shiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSInteger)row {
    return nil;
}

- (id<GameAction>) shiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSInteger)row {
    return nil;
}

- (id<GameAction>) destroyEnemyGroupsGameActionWithBoard:(GameBoard *)board {
    return nil;
}

- (id<GameAction>) dropEnemiesDownGameActionWithBoard:(GameBoard *)board {
    return nil;
}

@end
