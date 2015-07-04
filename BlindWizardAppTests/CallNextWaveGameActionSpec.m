#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "CallNextWaveGameAction.h"
#import "RandomGenerator.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

SpecBegin(CallNextWaveGameAction)

describe(@"CallNextWaveGameAction", ^{
    __block CallNextWaveGameAction *sut;
    __block id gameBoardMock;
    __block id randomGeneratorMock;
    __block id factoryMock;
    
    beforeEach(^{
        sut = [[CallNextWaveGameAction alloc] init];
        gameBoardMock = OCMClassMock([GameBoard class]);
        sut.gameBoard = gameBoardMock;
        randomGeneratorMock = OCMClassMock([RandomGenerator class]);
        sut.randomGenerator = randomGeneratorMock;
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut.factory = factoryMock;
    });
    
    context(@"when executing", ^{
        it(@"should create objects at the top most available spot in each column", ^{
            //context
            NSMutableArray *startData = [@[@3, @1, @1, @0, @2, @0, @0, @0, @0, @0] mutableCopy];
            NSMutableArray *endData = [@[@3, @1, @1, @1, @2, @0, @1, @0, @0, @0] mutableCopy];
            OCMStub([gameBoardMock numRows]).andReturn(5);
            OCMStub([gameBoardMock numColumns]).andReturn(2);
            OCMStub([gameBoardMock data]).andReturn(startData);
            OCMStub([randomGeneratorMock generate]).andReturn(1);
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateCreateEnemy object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            
            //because
            [sut execute];
            
            //expect
            expect(startData).to.equal(endData);
            OCMVerifyAll(notificationMock);
            
            //cleanup
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
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
        it(@"should create a destroy game action", ^{
            //because
            [sut generateNextGameAction];
            
            //expect
            OCMVerify([factoryMock createDestroyEnemyGroupsGameActionWithBoard:gameBoardMock]);
        });
    });
    
    afterEach(^{
        [gameBoardMock stopMocking];
        [randomGeneratorMock stopMocking];
    });
});

SpecEnd