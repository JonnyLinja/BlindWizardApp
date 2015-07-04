#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "Game.h"
#import "GameDependencyFactory.h"
#import "GameBoard.h"

@interface Game (Testing)
@property (nonatomic, strong) GameBoard *board;
@end

SpecBegin(Game)

describe(@"Game", ^{
    __block Game *sut;
    __block id factory;
    
    beforeEach(^{
        sut = [[Game alloc] init];
        factory = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut.factory = factory;
    });
    
    context(@"commands", ^{
        context(@"when starting the game", ^{
            //TODO: figure out how to load initial blocks on the new board
            it(@"should create a new board and set the game to in progress", ^{
                //context
                NSInteger rows = 5;
                NSInteger columns = 5;
                id boardMock = OCMClassMock([GameBoard class]);
                OCMStub([factory createGameBoardWithRows:rows columns:columns]).andReturn(boardMock);
                
                //because
                [sut commandStartGameWithRows:rows columns:columns];
                
                //expect
                expect(sut.board).toNot.beNil();
                expect(sut.gameInProgress).to.beTruthy();
                
                //cleanup
                [boardMock stopMocking];
            });
        });
        /*
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
        */
    });
    
    afterEach(^{
        [factory stopMocking];
    });
});

SpecEnd

//TODO: refactor so it uses a dependency factory, startGame gets passed in rows/cols, as it has to create the dependencies AFTER creation of the view itself so size can be calculated
//TODO: score
//TODO: losing