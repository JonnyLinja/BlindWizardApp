#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "WaveController.h"
#import "GameDependencyFactory.h"
#import "GameBoard.h"
#import "GameFlow.h"
#import "GameConstants.h"
#import "CallNextWaveGameAction.h"

@interface WaveController (Test)
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat delay;
@end

SpecBegin(WaveController)

describe(@"WaveController", ^{
    __block WaveController *sut;
    __block id boardMock;
    __block id flowMock;
    __block id factoryMock;
    __block id timerMock;
    __block id actionMock;
    
    beforeEach(^{
        flowMock = OCMClassMock([GameBoard class]);
        flowMock = OCMClassMock([GameFlow class]);
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        actionMock = OCMClassMock([CallNextWaveGameAction class]);
        OCMStub([factoryMock callNextWaveGameActionWithBoard:boardMock]).andReturn(actionMock);
        sut = [[WaveController alloc] initWithInitialDelay:10 multiplier:0.9 gameBoard:boardMock gameFlow:flowMock dependencyFactory:factoryMock];
        timerMock = OCMClassMock([NSTimer class]);
    });
    
    context(@"when the game starts", ^{
        it(@"should start the timer", ^{
            //context
            OCMStub(ClassMethod([timerMock scheduledTimerWithTimeInterval:10 target:[OCMArg any] selector:[OCMArg anySelector] userInfo:[OCMArg any] repeats:NO])).andReturn(timerMock);

            //because
            [sut notifyKeyPath:@"board.isActive" setTo:@YES];
            
            //expect
            expect(sut.timer).to.equal(timerMock);
        });
    });
    
    context(@"when the game ends", ^{
        it(@"should stop the timer", ^{
            //context
            sut.timer = timerMock;
            
            //because
            [sut notifyKeyPath:@"board.isActive" setTo:@NO];
            
            //expect
            OCMVerify([timerMock invalidate]);
            expect(sut.timer).to.beNil();
        });
    });
    
    context(@"when manually calling the next wave", ^{
        it(@"should invalidate the timer", ^{
            //context
            sut.timer = timerMock;
            
            //because
            [sut commandCallNextWave];
            
            //expect
            OCMVerify([timerMock invalidate]);
            expect(sut.timer).to.beNil();
        });
        
        it(@"should apply the timer multiplier to the delay", ^{
            //because
            [sut commandCallNextWave];
            
            //expect
            expect(sut.delay).to.equal(9);
        });
        
        it(@"should call the next wave", ^{
            //because
            [sut commandCallNextWave];
            
            //expect
            OCMVerify([flowMock addGameAction:actionMock]);
        });
        
        it(@"should update the count", ^{
            //because
            [sut commandCallNextWave];
            
            //expect
            expect(sut.count).to.equal(1);
        });
    });
    
    context(@"when a wave is created", ^{
        it(@"should decrement the number of creates", ^{
            //context
            sut.count = 3;
            
            //because
            [[NSNotificationCenter defaultCenter] postNotificationName:GameActionCallNextWaveComplete object:nil];
            
            //expect
            expect(sut.count).to.equal(2);
        });
    });
    
    context(@"when there are no waves to be called", ^{
        it(@"should start the timer with the delay", ^{
            //context
            sut.count = 1;
            OCMStub(ClassMethod([timerMock scheduledTimerWithTimeInterval:sut.delay target:[OCMArg any] selector:[OCMArg anySelector] userInfo:[OCMArg any] repeats:NO])).andReturn(timerMock);

            //because
            [[NSNotificationCenter defaultCenter] postNotificationName:GameActionCallNextWaveComplete object:nil];

            //expect
            expect(sut.count).to.equal(0);
            expect(sut.timer).to.equal(timerMock);
        });
    });
    
    context(@"when the timer fires", ^{
        //note: order matters, count must increment first, just not sure how to force it
        it(@"should increment count", ^{
            //context
            sut.count = 2;
            [sut notifyKeyPath:@"board.isActive" setTo:@YES];
            
            //because
            [sut.timer fire];
            
            //expect
            expect(sut.count).to.equal(3);
        });
        
        it(@"should apply the timer multiplier to the delay", ^{
            //context
            [sut notifyKeyPath:@"board.isActive" setTo:@YES];

            //because
            [sut.timer fire];
            
            //expect
            expect(sut.delay).to.equal(9);
        });

        it(@"should manually call the next wave", ^{
            //context
            [sut notifyKeyPath:@"board.isActive" setTo:@YES];
            
            //because
            [sut.timer fire];
            
            //expect
            OCMVerify([flowMock addGameAction:actionMock]);
        });
    });
    
    afterEach(^{
        [boardMock stopMocking];
        [flowMock stopMocking];
        [timerMock stopMocking];
        [actionMock stopMocking];
    });
});

SpecEnd