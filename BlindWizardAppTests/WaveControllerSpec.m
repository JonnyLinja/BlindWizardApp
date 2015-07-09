#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "WaveController.h"
#import "Game.h"
#import "GameConstants.h"

@interface WaveController (Test)
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat delay;
@end

SpecBegin(WaveController)

describe(@"WaveController", ^{
    __block WaveController *sut;
    __block id gameMock;
    __block id timerMock;
    
    beforeEach(^{
        gameMock = OCMClassMock([Game class]);
        sut = [[WaveController alloc] initWithInitialDelay:10 multiplier:0.9 Game:gameMock];
        timerMock = OCMClassMock([NSTimer class]);
    });
    
    context(@"when the game starts", ^{
        it(@"should start the timer", ^{
            //context
            OCMStub(ClassMethod([timerMock scheduledTimerWithTimeInterval:10 target:[OCMArg any] selector:[OCMArg anySelector] userInfo:[OCMArg any] repeats:NO])).andReturn(timerMock);

            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@YES];
            
            //expect
            expect(sut.timer).to.equal(timerMock);
        });
    });
    
    context(@"when the game ends", ^{
        it(@"should stop the timer", ^{
            //context
            sut.timer = timerMock;
            
            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@NO];
            
            //expect
            OCMVerify([timerMock invalidate]);
            expect(sut.timer).to.beNil();
        });
    });
    
    pending(@"when manually calling the next wave", ^{
        it(@"should invalidate the timer", ^{
            //context
            sut.timer = timerMock;
            
            //because
            [sut commandCallNextWave];
            
            //expect
            OCMVerify([timerMock invalidate]);
        });
        
        it(@"should call the next wave", ^{
            //because
            [sut commandCallNextWave];
            
            //expect
            OCMVerify([gameMock commandCallNextWave]);
        });
        
        it(@"should update the count", ^{
            //because
            [sut commandCallNextWave];
            
            //expect
            expect(sut.count).to.equal(1);
        });
        
        it(@"should apply the timer multiplier to the duration", ^{
            //because
            [sut commandCallNextWave];
            
            //expect
            expect(sut.delay).to.equal(9);
        });
    });
    
    pending(@"when a wave is created", ^{
        it(@"should decrement the number of creates", ^{
            //context
            sut.count = 3;
            
            //because
            [[NSNotificationCenter defaultCenter] postNotificationName:GameActionCallNextWaveComplete object:nil];
            
            //expect
            expect(sut.count).to.equal(2);
        });
    });
    
    pending(@"when there are no waves to be called", ^{
        it(@"should start the timer with the duration", ^{
            //context
            sut.count = 1;
            OCMStub(ClassMethod([timerMock scheduledTimerWithTimeInterval:sut.delay target:[OCMArg any] selector:[OCMArg anySelector] userInfo:[OCMArg any] repeats:@NO])).andReturn(timerMock);

            //because
            [[NSNotificationCenter defaultCenter] postNotificationName:GameActionCallNextWaveComplete object:nil];

            //expect
            expect(sut.timer).to.equal(timerMock);
        });
    });
    
    context(@"when the timer fires", ^{
        it(@"should manually call the next wave", ^{
            //context
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@YES];
            
            //because
            [sut.timer fire];
            
            //expect
            OCMVerify([gameMock commandCallNextWave]);
        });
    });
    
    afterEach(^{
        [gameMock stopMocking];
        [timerMock stopMocking];
    });
});

SpecEnd