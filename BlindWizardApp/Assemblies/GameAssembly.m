//
//  GameAssembly.m
//  BlindWizardApp
//
//  Created by N A on 7/6/15.
//  Copyright (c) 2015 Adronitis. All rights reserved.
//

#import "GameAssembly.h"
#import "GeneralAssembly.h"
#import "TyphoonConfigPostProcessor.h"
#import "TyphoonDefinition+Infrastructure.h"

#import "Game.h"
#import "GameBoard.h"
#import "GameFlow.h"
#import "CallNextWaveGameAction.h"
#import "CheckLoseGameAction.h"
#import "ShiftEnemiesLeftGameAction.h"
#import "ShiftEnemiesRightGameAction.h"
#import "DropEnemiesDownGameAction.h"
#import "DestroyEnemyGroupsGameAction.h"
#import "WaveController.h"

@implementation GameAssembly

- (id)configurer {
    return [TyphoonDefinition configDefinitionWithName:@"GameConfig.plist"];
}

- (Game *) game {
    return [TyphoonDefinition withClass:[Game class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithDependencyFactory:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self];
            //GameFlow needs to be manually injected after board is created
        }];
    }];
}

- (GameBoard *) gameBoardWithRows:(NSNumber *)rows columns:(NSNumber *)columns {
    return [TyphoonDefinition withClass:[GameBoard class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithRows:columns:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:rows];
            [initializer injectParameterWith:columns];
        }];
    }];

}

- (GameFlow *) gameFlowWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[GameFlow class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:queue:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:[self.generalAssembly queue]];
        }];
    }];
}

- (CallNextWaveGameAction *) callNextWaveGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[CallNextWaveGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:factory:randomGenerator:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:[self.generalAssembly randomGenerator]];
        }];
    }];
}

- (CheckLoseGameAction *) checkLoseGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[CheckLoseGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
        }];
    }];
}

- (ShiftEnemiesLeftGameAction *) shiftEnemiesLeftGameActionWithBoard:(GameBoard *)board row:(NSNumber *)row {
    return [TyphoonDefinition withClass:[ShiftEnemiesLeftGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithRow:gameBoard:factory:duration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:row];
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:TyphoonConfig(@"MoveAnimationDuration")];
        }];
    }];
}

- (ShiftEnemiesRightGameAction *) shiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSNumber *)row {
    return [TyphoonDefinition withClass:[ShiftEnemiesRightGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithRow:gameBoard:factory:duration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:row];
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:TyphoonConfig(@"MoveAnimationDuration")];
        }];
    }];
}

- (DestroyEnemyGroupsGameAction *) destroyEnemyGroupsGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[DestroyEnemyGroupsGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:factory:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
        }];
    }];
}

- (DropEnemiesDownGameAction *) dropEnemiesDownGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[DropEnemiesDownGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:factory:duration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:TyphoonConfig(@"MoveAnimationDuration")];
        }];
    }];
}

- (WaveController *) waveControllerWithGame:(Game *)game {
    return [TyphoonDefinition withClass:[WaveController class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithInitialDelay:multiplier:Game:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonConfig(@"StartingWaveTimer")];
            [initializer injectParameterWith:TyphoonConfig(@"WaveTimerMultiplier")];
            [initializer injectParameterWith:game];
        }];
    }];
}

@end
