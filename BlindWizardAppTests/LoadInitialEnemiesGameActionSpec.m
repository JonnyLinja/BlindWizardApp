#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "LoadInitialEnemiesGameAction.h"
#import "GameBoard.h"
#import "RandomGenerator.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

@interface LoadInitialEnemiesGameAction (Test)
@property (nonatomic, strong, readonly) GameBoard *gameBoard; //inject
@end

SpecBegin(LoadInitialEnemiesGameAction)

describe(@"LoadInitialEnemiesGameAction", ^{
    __block LoadInitialEnemiesGameAction *sut;
    __block id randomGeneratorMock;
    __block id factoryMock;

    beforeAll(^{
        GameBoard *board = [[GameBoard alloc] initWithRows:3 columns:4];
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        randomGeneratorMock = OCMClassMock([RandomGenerator class]);
        sut = [[LoadInitialEnemiesGameAction alloc] initWithGameBoard:board factory:factoryMock randomGenerator:randomGeneratorMock];
    });
    
    context(@"when executing", ^{
        it(@"should preload the gameboard with 3 rows, guaranteeing the first 2, and the rest randomized", ^{
            //context
            NSMutableArray *endData = [@[@1, @3, @2, @7, @3, @1, @2, @7, @1, @3, @1, @7] mutableCopy];
            OCMStub([randomGeneratorMock generate]).andReturn(7);
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateCreateEnemy object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"type"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                expect([userInfo objectForKey:@"type"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                expect([userInfo objectForKey:@"type"]).to.equal(@2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                expect([userInfo objectForKey:@"type"]).to.equal(@7);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"type"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                expect([userInfo objectForKey:@"type"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                expect([userInfo objectForKey:@"type"]).to.equal(@2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                expect([userInfo objectForKey:@"type"]).to.equal(@7);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"type"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                expect([userInfo objectForKey:@"type"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                expect([userInfo objectForKey:@"type"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateCreateEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                expect([userInfo objectForKey:@"type"]).to.equal(@7);
                return YES;
            }]];
            
            //because
            [sut execute];
            
            //expect
            expect(sut.gameBoard.data).to.equal(endData);
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
            //context
            OCMExpect([factoryMock createEnemyOutlinesGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            OCMExpect([factoryMock destroyEnemyGroupsGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            
            //because
            [sut generateNextGameActions];
            
            //expect
            OCMVerifyAll(factoryMock);
        });
    });
    
    afterEach(^{
        [randomGeneratorMock stopMocking];
    });
});

SpecEnd