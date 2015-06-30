#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "Game.h"

SpecBegin(Game)

describe(@"Game", ^{
    __block Game *sut;
    
    beforeEach(^{
        sut = [[Game alloc] init];
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
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[Game ShiftLeftNotificationName] object:sut];
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[Game MoveToRowTailNotificationName] object:sut];
            [[notificationMock expect] notificationWithName:[Game ShiftLeftNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(row));
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[Game ShiftLeftNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(row));
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[Game MoveToRowTailNotificationName]
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
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[Game ShiftLeftNotificationName] object:sut];
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:[Game MoveToRowTailNotificationName] object:sut];
            [[notificationMock expect] notificationWithName:[Game ShiftLeftNotificationName]
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@(row));
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:[Game ShiftLeftNotificationName]
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
});

SpecEnd

//actual logic of where things should be on a swipe or a drop or a create
//buffering commands, swipe and next wave specifically
//ordering commands, like drop -> destroy -> drop -> destroy
//all the notifications for specific blocks
//game action notifications