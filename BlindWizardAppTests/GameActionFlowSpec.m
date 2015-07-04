#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "GameConstants.h"
#import "CallNextWaveGameAction.h"
#import "GameActionFlow.h"
#import "GameActionQueue.h"
#import "GameActionValidator.h"

SpecBegin(GameActionFlow)

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
        //TODO: how do I test the duration aspect? i have it mocked but...
        //the async specta stuff assumes completion blocks it seems, and im supposed to pass DONE to the because line
        //but I want to use dispatch_after! there is no because block for me to use
        //I have no friggin clue how to test it sigh
        pending(@"when there is a new valid game action and the sut is ready", ^{
            it(@"should set not ready for the duration of the game action and notify", ^{
                //context
                CGFloat duration = 0.1;
                id gameActionMock = OCMClassMock([CallNextWaveGameAction class]);
                OCMStub([gameActionMock duration]).andReturn(duration);
                OCMStub([gameActionQueueMock hasGameAction]).andReturn(YES);
                OCMStub([gameActionQueueMock pop]).andReturn(gameActionMock);
                OCMStub([gameActionValidatorMock isGameActionValid:gameActionMock]).andReturn(YES);
                id notificationMock = OCMObserverMock();
                [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameActionCallNextWave object:sut];
                [[notificationMock expect] notificationWithName:GameActionCallNextWave object:sut];
                
                //because
                [sut notifyKeyPath:@"gameActionQueue.hasGameAction" setTo:@YES];
                
                //expect
                expect(sut.isReady).to.beFalsy();
                OCMVerifyAll(notificationMock);
                
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

//TODO: start game, initial game action
//TODO: complete game action - or do I prefer having the object listen to all the game actions instead?!

SpecEnd
