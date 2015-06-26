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
    
    context(@"when game score changes", ^{
        it(@"should convert score to a displayable string", ^{
            //because
            [sut notifyKeyPath:@"game.score" setTo:@9001];
            
            //expect
            expect(sut.score).to.equal(@"9001 points");
        });
    });
    
    context(@"when trying to create the next wave", ^{
        it(@"should create the next wave", ^{
            //because
            [sut callNextWave];
            
            //expect
            OCMVerify([gameMock callNextWave]);
        });
    });
    
    //notification stuff?
    context(@"when game ends", ^{
        it(@"should create the next wave", ^{
        });
    });
    
    afterEach(^{
        [gameMock stopMocking];
    });
});

SpecEnd