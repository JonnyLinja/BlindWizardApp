#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "Game.h"
#import "GameDependencyFactory.h"
#import "GameBoard.h"
#import "GameFlow.h"
#import "WaveController.h"
#import "LoadInitialEnemiesGameAction.h"
#import "ShiftEnemiesLeftGameAction.h"
#import "ShiftEnemiesRightGameAction.h"

@interface Game (Testing)
@property (nonatomic, strong, readonly) GameBoard *board;
@property (nonatomic, strong, readonly) GameFlow *flow;
@property (nonatomic, strong, readonly) WaveController *waveController;
@end

SpecBegin(Game)

describe(@"Game", ^{
    __block Game *sut;
    __block id factoryMock;
    __block id flowMock;
    __block id boardMock;
    __block id waveMock;
    
    beforeEach(^{
        flowMock = OCMClassMock([GameFlow class]);
        boardMock = OCMClassMock([GameBoard class]);
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        waveMock = OCMClassMock([WaveController class]);
        OCMStub([factoryMock gameBoardWithRows:@5 columns:@5]).andReturn(boardMock);
        OCMStub([factoryMock gameFlowWithBoard:boardMock]).andReturn(flowMock);
        OCMStub([factoryMock waveControllerWithBoard:boardMock flow:flowMock]).andReturn(waveMock);

        
        sut = [[Game alloc] initWithDependencyFactory:factoryMock];
    });
    
    context(@"when starting the game", ^{
        it(@"should create a new board, new flow, wave controller, and set the game to in progress", ^{
            //because
            [sut commandStartGameWithRows:5 columns:5];
            [sut notifyKeyPath:@"board.isActive" setTo:@YES];
            
            //expect
            expect(sut.board).to.equal(boardMock);
            expect(sut.flow).to.equal(flowMock);
            expect(sut.waveController).to.equal(waveMock);
            expect(sut.gameInProgress).to.beTruthy();
        });
        
        it(@"should load initial enemies", ^{
            id gameActionMock = OCMClassMock([LoadInitialEnemiesGameAction class]);
            OCMStub([factoryMock loadInitialEnemiesGameActionWithBoard:boardMock]).andReturn(gameActionMock);
            
            //because
            [sut commandStartGameWithRows:5 columns:5];
            [sut notifyKeyPath:@"board.isActive" setTo:@YES];
            
            //expect
            OCMVerify([flowMock addGameAction:gameActionMock]);
            
            //cleanup
            [gameActionMock stopMocking];
        });
    });
    
    context(@"after starting game", ^{
        beforeEach(^{
            [sut commandStartGameWithRows:5 columns:5];
        });
        
        context(@"when board score changes", ^{
            it(@"should update the score", ^{
                //context
                NSInteger score = 5;
                
                //because
                [sut notifyKeyPath:@"board.score" setTo:@(score)];
                
                //expect
                expect(sut.score).to.equal(score);
            });
        });
        
        context(@"when board active status changes", ^{
            it(@"should update game in progress", ^{
                //context
                BOOL status = YES;
                
                //because
                [sut notifyKeyPath:@"board.isActive" setTo:@(status)];
                
                //expect
                expect(sut.gameInProgress).to.equal(@(status));
            });
        });
        
        context(@"when calling the next wave", ^{
            it(@"should forward the call", ^{
                //context
                
                //because
                [sut commandCallNextWave];
                
                //expect
                OCMVerify([waveMock commandCallNextWave]);
            });
        });
        
        context(@"when swiping left", ^{
            it(@"should add the command to the flow", ^{
                //context
                NSInteger row = 5;
                id gameActionMock = OCMClassMock([ShiftEnemiesLeftGameAction class]);
                OCMStub([factoryMock shiftEnemiesLeftGameActionWithBoard:boardMock row:@(row)]).andReturn(gameActionMock);
                
                //because
                [sut commandSwipeLeftOnRow:row];
                
                //expect
                OCMVerify([factoryMock shiftEnemiesLeftGameActionWithBoard:boardMock row:@(row)]);
                OCMVerify([flowMock addGameAction:gameActionMock]);
                
                //cleanup
                [gameActionMock stopMocking];
            });
        });
        
        context(@"when swiping right", ^{
            it(@"should add the command to the flow", ^{
                //context
                NSInteger row = 5;
                id gameActionMock = OCMClassMock([ShiftEnemiesRightGameAction class]);
                OCMStub([factoryMock shiftEnemiesRightGameActionWithBoard:boardMock row:@(row)]).andReturn(gameActionMock);
                
                //because
                [sut commandSwipeRightOnRow:row];
                
                //expect
                OCMVerify([factoryMock shiftEnemiesRightGameActionWithBoard:boardMock row:@(row)]);
                OCMVerify([flowMock addGameAction:gameActionMock]);
                
                //cleanup
                [gameActionMock stopMocking];
            });
        });
    });
    
    //TODO: figure out how to test dealloc, this should work in theory but it isn't
    pending(@"when deallocating", ^{
        it(@"should set the board to not active", ^{
            __weak Game *weakSut;
            @autoreleasepool {
                Game *strongSut = [[Game alloc] initWithDependencyFactory:factoryMock];
                [strongSut commandStartGameWithRows:5 columns:5];
                weakSut = strongSut;
                
                OCMVerify([boardMock setIsActive:NO]);
            }
        });
    });
    
    afterEach(^{
        [factoryMock stopMocking];
        [flowMock stopMocking];
        [boardMock stopMocking];
        [waveMock stopMocking];
    });
});

SpecEnd
