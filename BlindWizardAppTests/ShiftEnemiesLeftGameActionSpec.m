#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "GameBoard+Test.h"

#import "ShiftEnemiesLeftGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

SpecBegin(ShiftEnemiesLeftGameAction)

describe(@"ShiftEnemiesLeftGameAction", ^{
    __block ShiftEnemiesLeftGameAction *sut;
    __block id gameBoardMock;
    __block id factoryMock;
    
    beforeEach(^{
        gameBoardMock = OCMClassMock([GameBoard class]);
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut = [[ShiftEnemiesLeftGameAction alloc] initWithGameBoard:gameBoardMock factory:factoryMock];
    });
    
    context(@"when executing", ^{
        it(@"should shift the items on row left, set the head of the row to the tail, and notify changes for actual objects", ^{
            //context
            NSMutableArray *startData = [@[@0, @3, @0, @0, @1, @2, @0, @4] mutableCopy];
            NSMutableArray *endData = [@[@3, @0, @0, @0, @2, @0, @4, @1] mutableCopy];
            OCMStub([gameBoardMock numRows]).andReturn(2);
            OCMStub([gameBoardMock numColumns]).andReturn(4);
            OCMStub([gameBoardMock data]).andReturn(startData);
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateShiftEnemyLeft object:sut];
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateMoveEnemyToRowTail object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateShiftEnemyLeft
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateShiftEnemyLeft
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateShiftEnemyLeft
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateMoveEnemyToRowTail
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            
            //because
            sut.row = 0;
            [sut execute];
            sut.row = 1;
            [sut execute];
            
            //expect
            expect(startData).to.equal(endData);
            OCMVerifyAll(notificationMock);
            
            //cleanup
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
    
    context(@"when the row has at least one enemy", ^{
        it(@"should be valid", ^{
            //context
            NSMutableArray *data = [@[@0, @0, @1, @1] mutableCopy];
            OCMStub([gameBoardMock numRows]).andReturn(2);
            OCMStub([gameBoardMock numColumns]).andReturn(2);
            OCMStub([gameBoardMock data]).andReturn(data);
            sut.row = 1;
            
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });
    
    context(@"when the row has no enemies", ^{
        it(@"should be invalid", ^{
            //context
            NSMutableArray *data = [@[@0, @0, @1, @1] mutableCopy];
            OCMStub([gameBoardMock numRows]).andReturn(2);
            OCMStub([gameBoardMock numColumns]).andReturn(2);
            OCMStub([gameBoardMock data]).andReturn(data);
            sut.row = 0;

            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beFalsy();
        });
    });
    
    context(@"when generating next game action", ^{
        it(@"should create a drop and a destroy game action", ^{
            //context
            OCMExpect([factoryMock dropEnemiesDownGameActionWithBoard:gameBoardMock]).andReturn(sut);
            OCMExpect([factoryMock destroyEnemyGroupsGameActionWithBoard:gameBoardMock]).andReturn(sut);
            [factoryMock setExpectationOrderMatters:YES];

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