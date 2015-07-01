#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameBoardLogic.h"
#import "RandomGenerator.h"

SpecBegin(GameBoardLogic)

describe(@"GameBoardLogic", ^{
    __block GameBoardLogic *sut;
    __block id notificationMock;
    
    beforeEach(^{
        sut = [[GameBoardLogic alloc] init];
        notificationMock = OCMObserverMock();
    });
    
    context(@"when executing a swipe left", ^{
        it(@"should shift the items on row left, set the head of the row to the tail, and notify changes for actual objects", ^{
            //context
            NSInteger row = 1;
            NSMutableArray *startData = [@[@0, @0, @0, @0, @1, @2, @0, @4] mutableCopy];
            NSMutableArray *endData = [@[@0, @0, @0, @0, @2, @0, @4, @1] mutableCopy];
            sut.numRows = 2;
            sut.numColumns = [startData count] / sut.numRows;
            sut.data = startData;
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[GameBoardLogic ShiftLeftNotificationName] object:sut];
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[GameBoardLogic MoveToRowTailNotificationName] object:sut];
            [[notificationMock expect] notificationWithName:[GameBoardLogic ShiftLeftNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(row));
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic ShiftLeftNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(row));
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic MoveToRowTailNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(row));
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            
            //because
            [sut executeShiftLeftOnRow:row];
            
            //expect
            expect(sut.data).to.equal(endData);
            OCMVerifyAll(notificationMock);
        });
    });
    
    context(@"when executing a swipe right", ^{
        it(@"should shift the items on row right, set the tail of the row to the head, and notify changes for actual objects", ^{
            //context
            NSInteger row = 1;
            NSMutableArray *startData = [@[@0, @0, @0, @0, @1, @0, @2, @4] mutableCopy];
            NSMutableArray *endData = [@[@0, @0, @0, @0, @4, @1, @0, @2] mutableCopy];
            sut.numRows = 2;
            sut.numColumns = [startData count] / sut.numRows;
            sut.data = startData;
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[GameBoardLogic ShiftRightNotificationName] object:sut];
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[GameBoardLogic MoveToRowHeadNotificationName] object:sut];
            [[notificationMock expect] notificationWithName:[GameBoardLogic ShiftRightNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(row));
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic ShiftRightNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(row));
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic MoveToRowHeadNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(row));
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            
            //because
            [sut executeShiftRightOnRow:row];
            
            //expect
            expect(sut.data).to.equal(endData);
            OCMVerifyAll(notificationMock);
        });
    });
    
    context(@"when executing a drop", ^{
        it(@"should drop everything down so there's no 0s at the bottom of the column and notify changes for actual objects", ^{
            //context
            NSInteger column = 0;
            NSMutableArray *startData = [@[@0, @1, @3, @0, @1, @0, @0, @0, @2, @0] mutableCopy];
            NSMutableArray *endData = [@[@3, @1, @1, @0, @2, @0, @0, @0, @0, @0] mutableCopy];
            sut.numRows = 5;
            sut.numColumns = 2;
            sut.data = startData;
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[GameBoardLogic DropNotificationName] object:sut];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DropNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@(column));
                expect([userInfo objectForKey:@"fromRow"]).to.equal(@1);
                expect([userInfo objectForKey:@"toRow"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DropNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@(column));
                expect([userInfo objectForKey:@"fromRow"]).to.equal(@2);
                expect([userInfo objectForKey:@"toRow"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DropNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@(column));
                expect([userInfo objectForKey:@"fromRow"]).to.equal(@4);
                expect([userInfo objectForKey:@"toRow"]).to.equal(@2);
                return YES;
            }]];
            
            //because
            [sut executeDrop];
            
            //expect
            expect(sut.data).to.equal(endData);
            OCMVerifyAll(notificationMock);
        });
    });
    
    context(@"when executing a create", ^{
        it(@"should create objects at the top most available spot in each column", ^{
            //context
            id randomGeneratorMock = OCMClassMock([RandomGenerator class]);
            sut.randomGenerator = randomGeneratorMock;
            sut.numRows = 5;
            sut.numColumns = 2;
            NSMutableArray *startData = [@[@3, @1, @1, @0, @2, @0, @0, @0, @0, @0] mutableCopy];
            NSMutableArray *endData = [@[@3, @1, @1, @1, @2, @0, @1, @0, @0, @0] mutableCopy];
            sut.data = startData;
            OCMStub([randomGeneratorMock generateRandomType]).andReturn(1);
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[GameBoardLogic CreateNotificationName] object:sut];
            [[notificationMock expect] notificationWithName:[GameBoardLogic CreateNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic CreateNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            
            //because
            [sut executeCreate];
            
            //expect
            expect(sut.data).to.equal(endData);
            OCMVerifyAll(notificationMock);
        });
    });
    
    context(@"when executing a destroy", ^{
        it(@"should destroy all objects of similar type that are in rows or columns of 3+", ^{
            //context
            sut.numRows = 5;
            sut.numColumns = 5;
            NSMutableArray *startData = [@[@1, @0, @2, @0, @0, @1, @2, @2, @3, @0, @1, @3, @3, @3, @3, @2, @2, @2, @3, @0, @1, @1, @0, @3, @1] mutableCopy];
            NSMutableArray *endData = [@[@0, @0, @2, @0, @0, @0, @2, @2, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0, @0, @1] mutableCopy];
            sut.data = startData;
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[GameBoardLogic DestroyNotificationName] object:sut];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@4);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[GameBoardLogic DestroyNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@4);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];

            //because
            [sut executeDestroy];
            
            //expect
            expect(sut.data).to.equal(endData);
            OCMVerifyAll(notificationMock);
        });
    });
    
    afterEach(^{
        [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
    });
    
    //TODO: danger
    //TODO: pacify
    //TODO: losing
});

SpecEnd
