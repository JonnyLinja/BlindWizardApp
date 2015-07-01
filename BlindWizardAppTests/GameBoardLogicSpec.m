#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameBoardLogic.h"

SpecBegin(GameBoardLogic)

describe(@"GameBoardLogic", ^{
    __block GameBoardLogic *sut;
    
    beforeEach(^{
        sut = [[GameBoardLogic alloc] init];
    });
    
    context(@"when ", ^{
        it(@"should ", ^{
            
        });
    });
    
    context(@"when executing a swipe left with an object at the head", ^{
        it(@"should shift the items on row left, set the head of the row to the tail, and notify changes for actual objects", ^{
            //context
            NSInteger row = 0;
            NSMutableArray *startData = [@[@1, @2, @0, @4] mutableCopy];
            NSMutableArray *endData = [@[@2, @0, @4, @1] mutableCopy];
            sut.numRows = 1;
            sut.numColumns = [startData count];
            sut.data = startData;
            id notificationMock = OCMObserverMock();
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
            
            //cleanup
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
    
    context(@"when executing a swipe left without an object at the head", ^{
        it(@"should shift the items on row left, set the head of the row to the tail, and notify the changes for actual objects", ^{
            //context
            NSInteger row = 0;
            NSMutableArray *startData = [@[@0, @2, @0, @4] mutableCopy];
            NSMutableArray *endData = [@[@2, @0, @4, @0] mutableCopy];
            sut.numRows = 1;
            sut.numColumns = [startData count];
            sut.data = startData;
            id notificationMock = OCMObserverMock();
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
            
            //because
            [sut executeShiftLeftOnRow:row];
            
            //expect
            expect(sut.data).to.equal(endData);
            OCMVerifyAll(notificationMock);
            
            //cleanup
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
    
    context(@"when executing a swipe right with an object at the tail", ^{
        it(@"should shift the items on row right, set the tail of the row to the head, and notify changes for actual objects", ^{
            //context
            NSInteger row = 0;
            NSMutableArray *startData = [@[@1, @0, @2, @4] mutableCopy];
            NSMutableArray *endData = [@[@4, @1, @0, @2] mutableCopy];
            sut.numRows = 1;
            sut.numColumns = [startData count];
            sut.data = startData;
            id notificationMock = OCMObserverMock();
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
            
            //cleanup
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
    
    context(@"when executing a swipe right without an object at the tail", ^{
        it(@"should shift the items on row right, set the tail of the row to the head, and notify changes for actual objects", ^{
            //context
            NSInteger row = 0;
            NSMutableArray *startData = [@[@1, @0, @2, @0] mutableCopy];
            NSMutableArray *endData = [@[@0, @1, @0, @2] mutableCopy];
            sut.numRows = 1;
            sut.numColumns = [startData count];
            sut.data = startData;
            id notificationMock = OCMObserverMock();
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
            
            //because
            [sut executeShiftRightOnRow:row];
            
            //expect
            expect(sut.data).to.equal(endData);
            OCMVerifyAll(notificationMock);
            
            //cleanup
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
});

SpecEnd

//actual logic of where things should be on a swipe or a drop or a create
//all the notifications for specific blocks
//losing