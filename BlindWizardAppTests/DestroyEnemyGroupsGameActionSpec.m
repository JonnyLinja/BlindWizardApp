#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "DestroyEnemyGroupsGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

SpecBegin(DestroyEnemyGroupsGameAction)

describe(@"DestroyEnemyGroupsGameAction", ^{
    __block DestroyEnemyGroupsGameAction *sut;
    __block id gameBoardMock;
    __block id factoryMock;
    
    beforeEach(^{
        sut = [[DestroyEnemyGroupsGameAction alloc] init];
        gameBoardMock = OCMClassMock([GameBoard class]);
        sut.gameBoard = gameBoardMock;
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut.factory = factoryMock;
    });
    
    context(@"when generating next game action", ^{
        it(@"should create a drop game action", ^{
            //context
            OCMExpect([factoryMock createDropEnemiesDownGameActionWithBoard:gameBoardMock]).andReturn(sut);
            
            //because
            [sut generateNextGameActions];
            
            //expect
            OCMVerifyAll(factoryMock);
        });
    });
    
    afterEach(^{
        [gameBoardMock stopMocking];
    });
});

SpecEnd