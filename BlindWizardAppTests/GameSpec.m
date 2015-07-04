#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "Game.h"
#import "GameConstants.h"
#import "GameActionFlow.h"
#import "GameBoardLogic.h"

SpecBegin(Game)

describe(@"Game", ^{
    __block Game *sut;
    __block id gameBoardLogicMock;
    __block id gameActionFlowMock;
    
    beforeEach(^{
        sut = [[Game alloc] init];
        gameActionFlowMock = OCMClassMock([GameActionFlow class]);
        sut.gameActionFlow = gameActionFlowMock;
        gameBoardLogicMock = OCMClassMock([GameBoardLogic class]);
        sut.gameBoardLogic = gameBoardLogicMock;
    });
    
    context(@"commands", ^{
        //TODO: start game
        context(@"when starting the game", ^{
            pending(@"should load initial blocks", ^{
                //because
                [sut commandStartGame];
            });
            
            pending(@"should set the game to the starting state", ^{
                //because
                [sut commandStartGame];
                
                //expect
                expect(sut.gameInProgress).to.beTruthy();
            });
        });
        
        context(@"when calling the next wave", ^{
            it(@"should add the command to the flow", ^{
                //because
                [sut commandCallNextWave];
                
                //expect
                OCMVerify([gameActionFlowMock commandCallNextWave]);
            });
        });
        
        context(@"when swiping left", ^{
            it(@"should add the command to the flow", ^{
                //context
                NSInteger row = 1;
                
                //because
                [sut commandSwipeLeftOnRow:row];
                
                //expect
                OCMVerify([gameActionFlowMock commandSwipeLeftOnRow:row]);
            });
        });
        
        context(@"when swiping right", ^{
            it(@"should add the command to the flow", ^{
                //context
                NSInteger row = 1;
                
                //because
                [sut commandSwipeRightOnRow:row];
                
                //expect
                OCMVerify([gameActionFlowMock commandSwipeRightOnRow:row]);
            });
        });
    });
    
    //UGH beginning the question necessity of game.h, as in theory can have gameboardlogic just listen directly for game actions, like it's an unnecessary object almost
    //but maybe ok because he'll end up with the data
    //for scanner purposes and shit
    //and score might change things?
    context(@"game actions", ^{
        context(@"when there is a call next wave game action", ^{
            it(@"should execute it", ^{
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameActionCallNextWave object:nil];
                
                //expect
                OCMVerify([gameBoardLogicMock executeGameActionCallNextWave]);
            });
        });
        
        context(@"when there is a shift enemies left game action", ^{
            it(@"should execute it", ^{
                //context
                NSInteger row = 1;
                NSDictionary *userInfo = @{@"row" : @(row)};

                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameActionShiftEnemiesLeft object:nil userInfo:userInfo];
                
                //expect
                OCMVerify([gameBoardLogicMock executeGameActionShiftEnemiesLeftOnRow:row]);
            });
        });
        
        context(@"when there is a shift enemies right game action", ^{
            it(@"should execute it", ^{
                //context
                NSInteger row = 1;
                NSDictionary *userInfo = @{@"row" : @(row)};
                
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameActionShiftEnemiesRight object:nil userInfo:userInfo];
                
                //expect
                OCMVerify([gameBoardLogicMock executeGameActionShiftEnemiesRightOnRow:row]);
            });
        });
        
        context(@"when there is a destroy enemies game action", ^{
            it(@"should execute it", ^{
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameActionDestroyEnemyGroups object:nil];
                
                //expect
                OCMVerify([gameBoardLogicMock executeGameActionDestroyEnemyGroups]);
            });
        });
        
        context(@"when there is a drop enemies game action", ^{
            it(@"should execute it", ^{
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameActionDropEnemiesDown object:nil];
                
                //expect
                OCMVerify([gameBoardLogicMock executeGameActionDropEnemiesDown]);
            });
        });
    });
    
    afterEach(^{
        [gameActionFlowMock stopMocking];
        [gameBoardLogicMock stopMocking];
    });
});

SpecEnd

//TODO: refactor so it uses a dependency factory, startGame gets passed in rows/cols, as it has to create the dependencies AFTER creation of the view itself so size can be calculated
//TODO: score
//TODO: danger
//TODO: pacify
//TODO: losing