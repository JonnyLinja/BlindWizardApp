#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "GameBoard+Test.h"

#import "CallNextWaveGameAction.h"
#import "RandomGenerator.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

@interface CallNextWaveGameAction (Test)
@property (nonatomic, strong, readonly) GameBoard *gameBoard; //inject
@end

SpecBegin(CallNextWaveGameAction)

describe(@"CallNextWaveGameAction", ^{
    __block CallNextWaveGameAction *sut;
    __block id factoryMock;
    
    beforeEach(^{
        GameBoard *board = [[GameBoard alloc] initWithRows:5 columns:2];
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut = [[CallNextWaveGameAction alloc] initWithGameBoard:board factory:factoryMock];
    });
    
    context(@"when executing", ^{
        it(@"should flip the negatives to positives at the top most available spot in each column and notify", ^{
            //context
            NSMutableArray *startData = [@[@3, @1, @1, @-2, @2, @0, @-1, @0, @0, @0] mutableCopy];
            NSMutableArray *endData = [@[@3, @1, @1, @2, @2, @0, @1, @0, @0, @0] mutableCopy];
            sut.gameBoard.data = startData;
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateCreateEnemy object:sut];
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameActionCallNextWaveComplete object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"type"]).to.equal(1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                expect([userInfo objectForKey:@"type"]).to.equal(2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameActionCallNextWaveComplete object:sut];
            
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
        it(@"should create a check dangerous, check lose, and a destroy game action", ^{
            //context
            OCMExpect([factoryMock createEnemyOutlinesGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            OCMExpect([factoryMock checkDangerousGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            OCMExpect([factoryMock checkLoseGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            OCMExpect([factoryMock destroyEnemyGroupsGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            
            //because
            [sut generateNextGameActions];
            
            //expect
            OCMVerifyAll(factoryMock);
        });
    });
});

SpecEnd
