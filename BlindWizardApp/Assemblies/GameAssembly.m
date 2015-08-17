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
#import "LoadInitialEnemiesGameAction.h"
#import "CallNextWaveGameAction.h"
#import "CreateEnemyOutlinesGameAction.h"
#import "CheckLoseGameAction.h"
#import "ShiftEnemiesLeftGameAction.h"
#import "ShiftEnemiesRightGameAction.h"
#import "DropEnemiesDownGameAction.h"
#import "DestroyEnemyGroupsGameAction.h"
#import "CheckDangerousGameAction.h"
#import "DelayGameAction.h"
#import "RepositionEnemyOutlinesGameAction.h"
#import "WaveController.h"
#import "ScoreCalculator.h"

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

- (LoadInitialEnemiesGameAction *) loadInitialEnemiesGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[LoadInitialEnemiesGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:factory:randomGenerator:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:[self.generalAssembly randomGenerator]];
        }];
    }];
}

- (CallNextWaveGameAction *) callNextWaveGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[CallNextWaveGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:factory:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
        }];
    }];
}

- (CreateEnemyOutlinesGameAction *) createEnemyOutlinesGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[CreateEnemyOutlinesGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:randomGenerator:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
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
            [initializer injectParameterWith:TyphoonConfig(@"ShiftGameActionDuration")];
        }];
    }];
}

- (ShiftEnemiesRightGameAction *) shiftEnemiesRightGameActionWithBoard:(GameBoard *)board row:(NSNumber *)row {
    return [TyphoonDefinition withClass:[ShiftEnemiesRightGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithRow:gameBoard:factory:duration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:row];
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:TyphoonConfig(@"ShiftGameActionDuration")];
        }];
    }];
}

- (DestroyEnemyGroupsGameAction *) destroyEnemyGroupsGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[DestroyEnemyGroupsGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:factory:scoreCalculator:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:[self scoreCalculator]];
        }];
    }];
}

- (DropEnemiesDownGameAction *) dropEnemiesDownGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[DropEnemiesDownGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:factory:duration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:self];
            [initializer injectParameterWith:TyphoonConfig(@"DropGameActionDuration")];
        }];
    }];
}

- (CheckDangerousGameAction *) checkDangerousGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[CheckDangerousGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
        }];
    }];
}

- (DelayGameAction *)delayGameActionWithDuration:(NSNumber *)duration {
    return [TyphoonDefinition withClass:[DelayGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithDuration:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:duration];
        }];
    }];
}

- (RepositionEnemyOutlinesGameAction *) repositionEnemyOutlinesGameActionWithBoard:(GameBoard *)board {
    return [TyphoonDefinition withClass:[RepositionEnemyOutlinesGameAction class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithGameBoard:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:board];
        }];
    }];
}

- (WaveController *) waveControllerWithBoard:(GameBoard *)board flow:(GameFlow *)flow {
    return [TyphoonDefinition withClass:[WaveController class] configuration:^(TyphoonDefinition* definition) {
        [definition useInitializer:@selector(initWithInitialDelay:multiplier:gameBoard:gameFlow:dependencyFactory:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:TyphoonConfig(@"StartingWaveTimer")];
            [initializer injectParameterWith:TyphoonConfig(@"WaveTimerMultiplier")];
            [initializer injectParameterWith:board];
            [initializer injectParameterWith:flow];
            [initializer injectParameterWith:self];
        }];
    }];
}

- (ScoreCalculator *) scoreCalculator {
    return [TyphoonDefinition withClass:[ScoreCalculator class]];
}

@end
