#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "CheckLoseGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

SpecBegin(CheckLoseGameAction)

describe(@"CheckLoseGameAction", ^{
    __block CheckLoseGameAction *sut;
    __block id factoryMock;
    
    beforeEach(^{
        sut = [[CheckLoseGameAction alloc] init];
        sut.gameBoard = [GameBoard new];
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut.factory = factoryMock;
    });
    
    context(@"when executing and there is an enemy at the top of a column", ^{
        it(@"should set gameboard to not active", ^{
            //context
            sut.gameBoard.isActive = YES;
            sut.gameBoard.data = [@[@1, @1, @2, @2, @0, @3] mutableCopy];
            sut.gameBoard.numRows = 3;
            sut.gameBoard.numColumns = 2;
            
            //because
            [sut execute];
            
            //expect
            expect(sut.gameBoard.isActive).to.beFalsy();
        });
    });
    
    context(@"when executing and there is an enemy at the top of a column", ^{
        it(@"should keep gameboard active", ^{
            //context
            sut.gameBoard.isActive = YES;
            sut.gameBoard.data = [@[@1, @1, @2, @2, @0, @0] mutableCopy];
            sut.gameBoard.numRows = 3;
            sut.gameBoard.numColumns = 2;
            
            //because
            [sut execute];
            
            //expect
            expect(sut.gameBoard.isActive).to.beTruthy();
        });
    });
    
    context(@"when checking isValid", ^{
        it(@"should return YES", ^{
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });
    
    context(@"when generating next game action", ^{
        it(@"should return NIL", ^{
            //because
            id value = [sut generateNextGameActions];
            
            //expect
            expect(value).to.beNil();
        });
    });
});

SpecEnd
