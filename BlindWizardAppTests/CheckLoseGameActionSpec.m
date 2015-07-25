#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "GameBoard+Test.h"

#import "CheckLoseGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

@interface CheckLoseGameAction (Test)
@property (nonatomic, strong, readonly) GameBoard *gameBoard; //inject
@end

SpecBegin(CheckLoseGameAction)

describe(@"CheckLoseGameAction", ^{
    __block CheckLoseGameAction *sut;
    
    beforeEach(^{
        GameBoard *board = [[GameBoard alloc] initWithRows:3 columns:2];
        board.isActive = YES;
        sut = [[CheckLoseGameAction alloc] initWithGameBoard:board];
    });
    
    context(@"when executing and there is an enemy at the top of a column", ^{
        it(@"should set gameboard to not active", ^{
            //context
            sut.gameBoard.data = [@[@1, @1, @2, @2, @-1, @3] mutableCopy];
            
            //because
            [sut execute];
            
            //expect
            expect(sut.gameBoard.isActive).to.beFalsy();
        });
    });
    
    context(@"when executing and there isn't an enemy at the top of any column", ^{
        it(@"should keep gameboard active", ^{
            //context
            sut.gameBoard.data = [@[@1, @1, @2, @2, @-1, @-1] mutableCopy];
            
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
