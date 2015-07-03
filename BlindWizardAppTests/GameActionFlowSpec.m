#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameActionFlow.h"

SpecBegin(GameActionFlow)

describe(@"GameActionFlow", ^{
    __block GameActionFlow *sut;
    
    beforeEach(^{
        sut = [[GameActionFlow alloc] init];
    });
    
    context(@"input commands", ^{
        context(@"when starting the game", ^{
            it(@"should push the command on the queue", ^{
                
            });
        });
        
        context(@"when calling the next wave", ^{
            it(@"should push the command on the queue", ^{
                
            });
        });
        
        context(@"when swiping left", ^{
            it(@"should push the command on the queue", ^{
                
            });
        });
        
        context(@"when swiping right", ^{
            it(@"should push the command on the queue", ^{
                
            });
        });
    });
    
    context(@"game actions", ^{
        context(@"when the queue gets a new item", ^{
            it(@"should attempt to run a game action", ^{
                
            });
        });
        
        context(@"when the sut becomes ready", ^{
            it(@"should attempt to run a game action", ^{
                
            });
        });
        
        context(@"when attempting to run a game action and the sut is ready and there is an item in the queue", ^{
            it(@"should pop a it off the queue, set not ready for the duration of the game action, and notify", ^{
                
            });
        });
    });
});

SpecEnd
