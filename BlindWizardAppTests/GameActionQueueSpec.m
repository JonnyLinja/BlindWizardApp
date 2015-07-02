#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameActionQueue.h"

SpecBegin(GameActionQueue)

describe(@"GameActionQueue", ^{
    context(@"valid game action checks", ^{
        context(@"when processing a drop game action that has nothing to drop", ^{
            it(@"should ignore the drop game action", ^{
                //scan
            });
        });
        
        context(@"when processing a destroy game action that has nothing to destroy", ^{
            it(@"should ignore the destroy game action", ^{
                //scan
            });
        });
        
        context(@"when processing a swipe left game action that has nothing in the row", ^{
            it(@"should ignore the swipe left game action", ^{
                //scan
            });
        });
        
        context(@"when processing a swipe right game action that has nothing in the row", ^{
            it(@"should ignore the swipe right game action", ^{
                //scan
            });
        });
    });
    
    context(@"auto inserted game actions", ^{
        context(@"when destroy game action has been processed", ^{
            it(@"should insert a drop game action at the head of the queue", ^{
                
            });
        });
        
        context(@"when drop game action has been processed", ^{
            it(@"should insert a destroy game action at the head of the queue", ^{
                
            });
        });
    });
    
    context(@"game commands", ^{
        context(@"when calling next wave", ^{
            it(@"should insert a create game action at the tail of the queue", ^{
                
            });
        });
        
        context(@"when swiping left", ^{
            it(@"should insert a swipe left game action at the tail of the queue", ^{
                
            });
        });
        
        context(@"when swiping right", ^{
            it(@"should insert a swipe right game action at the tail of the queue", ^{
                
            });
        });
    });
});

SpecEnd
