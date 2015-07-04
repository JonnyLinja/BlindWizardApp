#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "DestroyEnemyGroupsGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

SpecBegin(DestroyEnemyGroupsGameAction)

describe(@"DestroyEnemyGroupsGameAction", ^{
    __block DestroyEnemyGroupsGameAction *sut;
    __block id gameBoardMock;
    __block id factoryMock;
    
    beforeEach(^{
        sut = [[DestroyEnemyGroupsGameAction alloc] init];
        gameBoardMock = OCMClassMock([GameBoard class]);
        sut.gameBoard = gameBoardMock;
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut.factory = factoryMock;
    });
    
    pending(@"when executing", ^{
        it(@"should destroy all objects of similar type that are in rows or columns of 3+", ^{
            //context
            NSMutableArray *startData = [@[@1, @0, @2, @0, @0, @1, @2, @2, @3, @0, @1, @3, @3, @3, @3, @2, @2, @2, @3, @0, @1, @1, @0, @3, @1] mutableCopy];
            NSMutableArray *endData = [@[@0, @0, @2, @0, @0, @0, @2, @2, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0, @0, @1] mutableCopy];
            OCMStub([gameBoardMock numRows]).andReturn(5);
            OCMStub([gameBoardMock numColumns]).andReturn(5);
            OCMStub([gameBoardMock data]).andReturn(startData);
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateDestroyEnemy object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@4);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@4);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
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
    
    context(@"when generating next game action", ^{
        it(@"should create a drop game action", ^{
            //context
            OCMExpect([factoryMock createDropEnemiesDownGameActionWithBoard:gameBoardMock]).andReturn(sut);
            
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