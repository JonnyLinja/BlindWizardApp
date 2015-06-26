#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "PlayViewModel.h"
#import "Game.h"

#import "NSObject+MTKTest.h"

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
        it(@"should start the game", ^{
            //because
            [sut startGame];
            
            //expect
            OCMVerify([gameMock startGame]);
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
            OCMVerify([gameMock callNextWave]);
        });
    });
    
    context(@"when game is over", ^{
        it(@"should set game in progress to NO", ^{
            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@NO];
            
            //expect
            expect(sut.gameInProgress).to.beFalsy();
        });
    });
    
    context(@"when game is playing", ^{
        it(@"should set game in progress to YES", ^{
            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@YES];
            
            //expect
            expect(sut.gameInProgress).to.beTruthy();
        });
    });
    
    afterEach(^{
        [gameMock stopMocking];
    });
});

SpecEnd