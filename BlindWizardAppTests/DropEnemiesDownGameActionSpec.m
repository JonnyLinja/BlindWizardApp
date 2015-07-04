#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "DropEnemiesDownGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

SpecBegin(DropEnemiesDownGameAction)

describe(@"DropEnemiesDownGameAction", ^{
    __block DropEnemiesDownGameAction *sut;
    __block id gameBoardMock;
    __block id factoryMock;
    
    beforeEach(^{
        sut = [[DropEnemiesDownGameAction alloc] init];
        gameBoardMock = OCMClassMock([GameBoard class]);
        sut.gameBoard = gameBoardMock;
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut.factory = factoryMock;
    });
    
    context(@"when executing", ^{
        it(@"should drop everything down so there's no 0s at the bottom of the column and notify changes for actual objects", ^{
        });
    });
    
    context(@"when at least one column has a 0 under a 1+", ^{
        it(@"should be valid", ^{
        });
    });
    
    context(@"when there are no columns with a 0 under a 1+", ^{
        it(@"should be invalid", ^{
        });
    });
    
    //TODO: get duration from somewhere, like a config file or a constants file
    context(@"when checking duration", ^{
        it(@"should return > 0", ^{
            //because
            CGFloat duration = [sut duration];
            
            //expect
            expect(duration).to.beGreaterThan(0);
        });
    });
    
    context(@"when generating next game action", ^{
        it(@"should create a destroy game action", ^{
            //context
            OCMExpect([factoryMock createDestroyEnemyGroupsGameActionWithBoard:gameBoardMock]).andReturn(sut);
            
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