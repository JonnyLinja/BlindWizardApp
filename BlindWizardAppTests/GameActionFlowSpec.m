#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "GameAction.h"
#import "GameActionFlow.h"
#import "Queue.h"

@interface GameActionFlow (Test)
@property (nonatomic, assign) BOOL isReady;
@end

SpecBegin(GameActionFlow)

describe(@"GameActionFlow", ^{
    __block GameActionFlow *sut;
    __block id queueMock;
    
    beforeEach(^{
        sut = [[GameActionFlow alloc] init];
        queueMock = OCMClassMock([Queue class]);
        sut.queue = queueMock;
    });
    
    context(@"when adding a game action", ^{
        it(@"should add it to the end of the array", ^{
            
        });
    });
    
    context(@"when there is a valid game action and the sut is ready", ^{
        it(@"should set not ready for the duration of the game action, execute the game action, and insert a game action at the head of the queue", ^{
            //context
            CGFloat duration = 0.1;
            sut.isReady = YES;
            __block BOOL runOnce = NO;
            id gameActionMock = OCMProtocolMock(@protocol(GameAction));
            OCMStub([gameActionMock isValid]).andReturn(YES);
            OCMStub([gameActionMock duration]).andReturn(duration);
            OCMStub([gameActionMock generateNextGameAction]).andReturn(gameActionMock);
            OCMStub([queueMock pop]).andReturn(gameActionMock);
            OCMStub([queueMock hasObject]).andDo(^(NSInvocation *invocation) {
                BOOL returnVal = !runOnce;
                runOnce = YES;
               [invocation setReturnValue:&returnVal];
            });

            //because
            [sut notifyKeyPath:@"queue.hasObject" setTo:@YES];
            
            //expect
            OCMVerify([queueMock pop]);
            OCMVerify([gameActionMock execute]);
            OCMVerify([gameActionMock generateNextGameAction]);
            OCMVerify([queueMock push:gameActionMock]);
            expect(sut.isReady).to.beFalsy();
            waitUntil(^(DoneCallback done) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    expect(sut.isReady).to.beTruthy();
                    done();
                });
            });
        });
    });
    
    context(@"when the sut becomes ready and there is a valid game action", ^{
        it(@"should set not ready for the duration of the game action and execute the game action", ^{
            
        });
    });
    
    context(@"when the sut becomes ready and there is an invalid game action", ^{
        it(@"should set to ready", ^{
            
        });
    });
    
    context(@"when there is an invalid game action and the sut is ready", ^{
        it(@"should set to ready", ^{
            
        });
    });
    
    afterEach(^{
        [queueMock stopMocking];
    });
});

/*
describe(@"GameActionFlow", ^{
    __block GameActionFlow *sut;
    __block id gameActionQueueMock;
    __block id gameActionValidatorMock;
    
    beforeEach(^{
        sut = [[GameActionFlow alloc] init];
        gameActionQueueMock = OCMClassMock([GameActionQueue class]);
        sut.gameActionQueue = gameActionQueueMock;
        gameActionValidatorMock = OCMClassMock([GameActionValidator class]);
        sut.gameActionValidator = gameActionValidatorMock;
    });
    
    context(@"input commands", ^{
        //TODO: start game, though not sure it is necessary in GameActionFlow
        pending(@"when starting the game", ^{
            it(@"should push the command on the queue", ^{
            });
        });
        
        context(@"when calling the next wave", ^{
            it(@"should push the command on the queue", ^{
                //because
                [sut commandCallNextWave];
                
                //expect
                OCMVerify([gameActionQueueMock pushCommandCallNextWave]);
            });
        });
        
        context(@"when swiping left", ^{
            it(@"should push the command on the queue", ^{
                //context
                NSInteger row = 1;
                
                //because
                [sut commandSwipeLeftOnRow:row];
                
                //expect
                OCMVerify([gameActionQueueMock pushCommandSwipeLeftOnRow:row]);
            });
        });
        
        context(@"when swiping right", ^{
            it(@"should push the command on the queue", ^{
                //context
                NSInteger row = 1;
                
                //because
                [sut commandSwipeRightOnRow:row];
                
                //expect
                OCMVerify([gameActionQueueMock pushCommandSwipeRightOnRow:row]);
            });
        });
    });
    
    context(@"game actions", ^{
        context(@"when there is a new valid game action and the sut is ready", ^{
            it(@"should set not ready for the duration of the game action and notify", ^{
                //context
                CGFloat duration = 0.1;
                id gameActionMock = OCMClassMock([GameAction class]);
                OCMStub([gameActionMock duration]).andReturn(duration);
                OCMStub([gameActionQueueMock hasGameAction]).andReturn(YES);
                OCMStub([gameActionQueueMock pop]).andReturn(gameActionMock);
                OCMStub([gameActionValidatorMock isGameActionValid:gameActionMock]).andReturn(YES);
                
                //because
                [sut notifyKeyPath:@"gameActionQueue.hasGameAction" setTo:@YES];
                
                //expect
                expect(sut.isReady).to.beFalsy();
                OCMVerifyAll(notificationMock);
                waitUntil(^(DoneCallback done) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        expect(sut.isReady).to.beTruthy();
                        done();
                    });
                });
                
                //cleanup
                [gameActionMock stopMocking];
                [notificationMock stopMocking];
            });
        });
        
        context(@"when the sut becomes ready and there is a valid game action", ^{
            it(@"should set not ready for the duration of the game action and notify", ^{
                
            });
        });
    });
    
    afterEach(^{
        [gameActionQueueMock stopMocking];
    });
});
*/
//TODO: start game, initial game action
//TODO: complete game action - or do I prefer having the object listen to all the game actions instead?!

SpecEnd
