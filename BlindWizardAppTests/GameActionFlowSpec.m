#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameActionFlow.h"

SpecBegin(GameActionFlow)

describe(@"GameActionFlow", ^{
    context(@"input commands", ^{
        context(@"when starting the game", ^{
            it(@"should push the command on the queue and attempt to set the current game action", ^{
                
            });
        });
        
        context(@"when calling the next wave", ^{
            it(@"should push the command on the queue and attempt to set the current game action", ^{
                
            });
        });
        
        context(@"when swiping left", ^{
            it(@"should push the command on the queue and attempt to set the current game action", ^{
                
            });
        });
        
        context(@"when swping right", ^{
            it(@"should push the command on the queue and attempt to set the current game action", ^{
                
            });
        });
    });
    
    context(@"game actions", ^{
        context(@"when there is a game action in the queue and the sut is ready", ^{
            it(@"should pop a game action off the queue, set it as the current game action, and set the sut to not ready for the duration of the game action", ^{
                
            });
        });
    });
});

SpecEnd
