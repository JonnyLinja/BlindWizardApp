#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "GameBoard+Test.h"

#import "ShiftEnemiesRightGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

@interface ShiftEnemiesRightGameAction (Test)
@property (nonatomic, assign) NSInteger row;
@end

SpecBegin(ShiftEnemiesRightGameAction)

describe(@"ShiftEnemiesRightGameAction", ^{
    __block ShiftEnemiesRightGameAction *sut;
    __block id gameBoardMock;
    __block id factoryMock;
    __block CGFloat duration;
    
    beforeEach(^{
        gameBoardMock = OCMClassMock([GameBoard class]);
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        duration = 5;
        sut = [[ShiftEnemiesRightGameAction alloc] initWithRow:-1 gameBoard:gameBoardMock factory:factoryMock duration:duration];
    });
    
    context(@"when executing", ^{
        it(@"should shift the items on row right, set the tail of the row to the head, and notify changes for actual objects", ^{
            //context
            NSMutableArray *startData = [@[@0, @3, @-1, @0, @1, @0, @2, @4, @-1, @3, @-1, @-2] mutableCopy];
            NSMutableArray *endData = [@[@0, @0, @3, @0, @4, @1, @0, @2, @-1, @0, @3, @-2] mutableCopy];
            OCMStub([gameBoardMock numRows]).andReturn(3);
            OCMStub([gameBoardMock numColumns]).andReturn(4);
            OCMStub([gameBoardMock data]).andReturn(startData);
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateShiftEnemyRight object:sut];
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateMoveEnemyToRowHead object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateShiftEnemyRight
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(0));
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateShiftEnemyRight
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateShiftEnemyRight
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateShiftEnemyRight
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateMoveEnemyToRowHead
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            
            //because
            sut.row = 0;
            [sut execute];
            sut.row = 1;
            [sut execute];
            sut.row = 2;
            [sut execute];
            
            //expect
            expect(startData).to.equal(endData);
            OCMVerifyAll(notificationMock);
            
            //cleanup
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
    
    context(@"when checking duration", ^{
        it(@"should return 0", ^{
            expect(sut.duration).to.equal(0);
        });
    });
    
    context(@"when the row has at least one enemy", ^{
        it(@"should be valid", ^{
            //context
            NSMutableArray *data = [@[@-1, @0, @1, @1] mutableCopy];
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
            NSMutableArray *data = [@[@-1, @0, @1, @1] mutableCopy];
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
            OCMExpect([factoryMock repositionEnemyOutlinesGameActionWithBoard:gameBoardMock]).andReturn(sut);
            OCMExpect([factoryMock delayGameActionWithDuration:@(duration)]).andReturn(sut);
            OCMExpect([factoryMock destroyEnemyGroupsGameActionWithBoard:gameBoardMock]).andReturn(sut);
            OCMExpect([factoryMock dropEnemiesDownGameActionWithBoard:gameBoardMock]).andReturn(sut);
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