#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "GameBoard+Test.h"

#import "CreateEnemyOutlinesGameAction.h"
#import "RandomGenerator.h"
#import "GameBoard.h"
#import "GameConstants.h"

@interface CreateEnemyOutlinesGameAction (Test)
@property (nonatomic, strong, readonly) GameBoard *gameBoard; //inject
@end

SpecBegin(CreateEnemyOutlinesGameAction)

describe(@"CreateEnemyOutlinesGameAction", ^{
    __block CreateEnemyOutlinesGameAction *sut;
    __block id randomGeneratorMock;
    
    beforeEach(^{
        GameBoard *board = [[GameBoard alloc] initWithRows:5 columns:2];
        randomGeneratorMock = OCMClassMock([RandomGenerator class]);
        sut = [[CreateEnemyOutlinesGameAction alloc] initWithGameBoard:board randomGenerator:randomGeneratorMock];
    });
    
    context(@"when executing", ^{
        it(@"should create objects with negative values at the top most available spot in each column, set them to gameboard, and notify the positive values", ^{
            //context
            NSMutableArray *startData = [@[@3, @1, @1, @0, @2, @0, @0, @0, @0, @0] mutableCopy];
            NSMutableArray *endData = [@[@3, @1, @1, @-1, @2, @0, @-1, @0, @0, @0] mutableCopy];
            NSMutableArray *nextWaveData = [@[@-1, @-1] mutableCopy];
            sut.gameBoard.data = startData;
            OCMStub([randomGeneratorMock generate]).andReturn(1);
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateCreateEnemyOutline object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemyOutline
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"type"]).to.beGreaterThan(0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemyOutline
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                expect([userInfo objectForKey:@"type"]).to.beGreaterThan(0);
                return YES;
            }]];
            
            //because
            [sut execute];
            
            //expect
            expect(startData).to.equal(endData);
            expect(sut.gameBoard.nextWaveData).to.equal(nextWaveData);
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
        it(@"should return NIL", ^{
            //because
            id value = [sut generateNextGameActions];
            
            //expect
            expect(value).to.beNil();
        });
    });
    
    afterEach(^{
        [randomGeneratorMock stopMocking];
    });
});

SpecEnd