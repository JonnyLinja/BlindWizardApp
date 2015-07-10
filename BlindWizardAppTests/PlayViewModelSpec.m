#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "PlayViewModel.h"
#import "Game.h"
#import "GridCalculator.h"
#import "TopScores.h"

SpecBegin(PlayViewModel)

describe(@"PlayViewModel", ^{
    __block PlayViewModel *sut;
    __block id gameMock;
    
    beforeEach(^{
        sut = [[PlayViewModel alloc] init];
        gameMock = OCMClassMock([Game class]);
        sut.game = gameMock;
    });
    
    context(@"when trying to start the game", ^{
        it(@"should calculate the number of rows/columns and start the game with it", ^{
            //context
            NSInteger rows = 5;
            NSInteger columns = 5;
            id calculatorMock = OCMClassMock([GridCalculator class]);
            sut.calculator = calculatorMock;
            OCMStub([calculatorMock numRows]).andReturn(rows);
            OCMStub([calculatorMock numColumns]).andReturn(columns);
            
            //because
            [sut startGame];
            
            //expect
            OCMVerify([gameMock commandStartGameWithRows:rows columns:columns]);
            
            //cleanup
            [calculatorMock stopMocking];
        });
    });
    
    context(@"when game score changes", ^{
        it(@"should convert score to a displayable string", ^{
            //because
            [sut notifyKeyPath:@"game.score" setTo:@9001];
            
            //expect
            expect(sut.score).to.equal(@"9001 points");
        });
    });
    
    context(@"when trying to call the next wave", ^{
        it(@"should call the next wave", ^{
            //because
            [sut callNextWave];
            
            //expect
            OCMVerify([gameMock commandCallNextWave]);
        });
    });
    
    context(@"when game is over", ^{
        it(@"should set game in progress to NO", ^{
            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@NO];
            
            //expect
            expect(sut.gameInProgress).to.beFalsy();
        });
        
        it(@"should lower board visibility", ^{
            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@NO];
            
            //expect
            expect(sut.boardVisibility).to.beLessThan(1);
        });
        
        it(@"should add the score to top scores", ^{
            //context
            id scoreMock = OCMClassMock([TopScores class]);
            sut.topScores = scoreMock;
            OCMStub([(Game*)gameMock score]).andReturn(5);
            
            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@NO];
            
            //expect
            OCMVerify([scoreMock addScore:5]);
            
            //cleanup
            [scoreMock stopMocking];
        });
    });
    
    context(@"when game is playing", ^{
        it(@"should set game in progress to YES", ^{
            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@YES];
            
            //expect
            expect(sut.gameInProgress).to.beTruthy();
        });
        
        it(@"should make the board visibile", ^{
            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@YES];
            
            //expect
            expect(sut.boardVisibility).to.equal(1);
        });
    });
    
    afterEach(^{
        [gameMock stopMocking];
    });
});

SpecEnd