#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "GameAction.h"
#import "GameFlow.h"
#import "Queue.h"
#import "GameConstants.h"

@interface GameFlow (Test)
@property (nonatomic, assign) BOOL isReady;
@end

SpecBegin(GameFlow)

describe(@"GameFlow", ^{
    __block GameFlow *sut;
    __block id queueMock;
    
    beforeEach(^{
        sut = [[GameFlow alloc] init];
        queueMock = OCMClassMock([Queue class]);
        sut.queue = queueMock;
    });
    
    context(@"when adding a game action", ^{
        it(@"should add it to the end of the array", ^{
            //context
            id gameActionMock = OCMProtocolMock(@protocol(GameAction));
            
            //because
            [sut addGameAction:gameActionMock];
            
            //expect
            OCMVerify([queueMock add:gameActionMock]);
            
            //cleanup
            [gameActionMock stopMocking];
        });
    });
    
    context(@"when there is a valid game action and the sut is ready", ^{
        it(@"should set not ready for the duration of the game action, execute the game action, insert the next game actions at the head of the queue, and notify", ^{
            //context
            CGFloat duration = 0.1;
            sut.isReady = YES;
            __block BOOL runOnce = NO;
            NSObject *obj1 = [NSObject new];
            NSObject *obj2 = [NSObject new];
            NSArray* array = @[obj1, obj2];
            id gameActionMock = OCMProtocolMock(@protocol(GameAction));
            OCMStub([gameActionMock isValid]).andReturn(YES);
            OCMStub([gameActionMock duration]).andReturn(duration);
            OCMStub([gameActionMock generateNextGameActions]).andReturn(array);
            OCMExpect([queueMock hasObject]).andDo(^(NSInvocation *invocation) {
                BOOL returnVal = !runOnce;
                runOnce = YES;
               [invocation setReturnValue:&returnVal];
            });
            OCMExpect([queueMock pop]).andReturn(gameActionMock);
            OCMExpect([queueMock push:obj2]);
            OCMExpect([queueMock push:obj1]);
            [queueMock setExpectationOrderMatters:YES];
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameActionComplete object:nil];
            [[notificationMock expect] notificationWithName:GameActionComplete object:nil];

            //because
            [sut notifyKeyPath:@"queue.hasObject" setTo:@YES];
            
            //expect
            OCMVerify([gameActionMock execute]);
            OCMVerify([gameActionMock duration]);
            OCMVerify([gameActionMock generateNextGameActions]);
            OCMVerifyAll(queueMock);
            expect(sut.isReady).to.beFalsy();
            waitUntil(^(DoneCallback done) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    expect(sut.isReady).to.beTruthy();
                    done();
                });
            });
            OCMVerifyAll(notificationMock);
            
            //cleanup
            [gameActionMock stopMocking];
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
    
    context(@"when the sut becomes ready and there is a valid game action", ^{
        it(@"should set not ready for the duration of the game action, execute the game action, insert the next game actions at the head of the queue, and notify", ^{
            //context
            CGFloat duration = 0.1;
            sut.isReady = YES;
            __block BOOL runOnce = NO;
            id gameActionMock = OCMProtocolMock(@protocol(GameAction));
            OCMStub([gameActionMock isValid]).andReturn(YES);
            OCMStub([gameActionMock duration]).andReturn(duration);
            OCMStub([gameActionMock generateNextGameActions]).andReturn(@[gameActionMock]);
            OCMStub([queueMock pop]).andReturn(gameActionMock);
            OCMStub([queueMock hasObject]).andDo(^(NSInvocation *invocation) {
                BOOL returnVal = !runOnce;
                runOnce = YES;
                [invocation setReturnValue:&returnVal];
            });
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameActionComplete object:nil];
            [[notificationMock expect] notificationWithName:GameActionComplete object:nil];

            //because
            [sut notifyKeyPath:@"isReady" setTo:@YES];

            //expect
            OCMVerify([queueMock hasObject]);
            OCMVerify([queueMock pop]);
            OCMVerify([gameActionMock execute]);
            OCMVerify([gameActionMock duration]);
            OCMVerify([gameActionMock generateNextGameActions]);
            OCMVerify([queueMock push:gameActionMock]);
            expect(sut.isReady).to.beFalsy();
            waitUntil(^(DoneCallback done) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    expect(sut.isReady).to.beTruthy();
                    done();
                });
            });
            OCMVerifyAll(notificationMock);
            
            //cleanup
            [gameActionMock stopMocking];
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
    
    context(@"when there is an invalid game action and the sut is ready", ^{
        it(@"should set to ready", ^{
            //context
            sut.isReady = YES;
            __block BOOL runOnce = NO;
            id gameActionMock = OCMProtocolMock(@protocol(GameAction));
            OCMStub([gameActionMock isValid]).andReturn(NO);
            OCMStub([queueMock pop]).andReturn(gameActionMock);
            OCMStub([queueMock hasObject]).andDo(^(NSInvocation *invocation) {
                BOOL returnVal = !runOnce;
                runOnce = YES;
                [invocation setReturnValue:&returnVal];
            });
            
            //because
            [sut notifyKeyPath:@"queue.hasObject" setTo:@YES];
            
            //expect
            OCMVerify([queueMock hasObject]);
            OCMVerify([queueMock pop]);
            expect(sut.isReady).to.beTruthy();
            
            //cleanup
            [gameActionMock stopMocking];
        });
    });
    
    context(@"when the sut becomes ready and there is an invalid game action", ^{
        it(@"should set to ready", ^{
            //context
            sut.isReady = YES;
            __block BOOL runOnce = NO;
            id gameActionMock = OCMProtocolMock(@protocol(GameAction));
            OCMStub([gameActionMock isValid]).andReturn(NO);
            OCMStub([queueMock pop]).andReturn(gameActionMock);
            OCMStub([queueMock hasObject]).andDo(^(NSInvocation *invocation) {
                BOOL returnVal = !runOnce;
                runOnce = YES;
                [invocation setReturnValue:&returnVal];
            });
            
            //because
            [sut notifyKeyPath:@"isReady" setTo:@YES];
            
            //expect
            OCMVerify([queueMock hasObject]);
            OCMVerify([queueMock pop]);
            expect(sut.isReady).to.beTruthy();
            
            //cleanup
            [gameActionMock stopMocking];
        });
    });
    
    afterEach(^{
        [queueMock stopMocking];
    });
});

SpecEnd
