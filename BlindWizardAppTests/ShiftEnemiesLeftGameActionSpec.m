#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

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
        sut = [[ShiftEnemiesLeftGameAction alloc] init];
        gameBoardMock = OCMClassMock([GameBoard class]);
        sut.gameBoard = gameBoardMock;
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut.factory = factoryMock;
    });
    
    pending(@"when executing", ^{
        it(@"should create objects at the top most available spot in each column", ^{
            //context
            NSMutableArray *startData = [@[@0, @3, @0, @0, @1, @2, @0, @4] mutableCopy];
            NSMutableArray *endData = [@[@3, @0, @0, @0, @2, @0, @4, @1] mutableCopy];
            OCMStub([gameBoardMock numRows]).andReturn(5);
            OCMStub([gameBoardMock numColumns]).andReturn(2);
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
    
    pending(@"when checking isValid", ^{
        it(@"should return YES", ^{
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });
    
    //TODO: get duration from somewhere, like a config file or a constants file
    context(@"when checking duration", ^{
        it(@"should return > 0", ^{
            //because
            CGFloat duration = [sut duration];
            
            //expect
            expect(duration).to.beGreaterThan(0);
        });
    });
    
    context(@"when generating next game action", ^{
        it(@"should create a destroy game action", ^{
            //context
            OCMStub([factoryMock createDropEnemiesDownGameActionWithBoard:gameBoardMock]).andReturn(sut);
            OCMStub([factoryMock createDestroyEnemyGroupsGameActionWithBoard:gameBoardMock]).andReturn(sut);
            
            //because
            [sut generateNextGameActions];
            
            //expect
            OCMVerify([factoryMock createDropEnemiesDownGameActionWithBoard:gameBoardMock]);
            OCMVerify([factoryMock createDestroyEnemyGroupsGameActionWithBoard:gameBoardMock]);
        });
    });
    
    afterEach(^{
        [gameBoardMock stopMocking];
    });
});

SpecEnd