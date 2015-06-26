#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "BoardViewModel.h"
#import "Game.h"

SpecBegin(BoardViewModel)

describe(@"BoardViewModel", ^{
    __block BoardViewModel *sut;
    __block id gameMock;
    
    beforeEach(^{
        sut = [[BoardViewModel alloc] init];
        gameMock = OCMClassMock([Game class]);
        sut.game = gameMock;
    });
    
    context(@"when initialized", ^{
        it(@"should listen for ", ^{ //notification stuff?
            
        });
    });
    
    context(@"when swiping left", ^{
        it(@"should swipe the row to the left", ^{
            
        });
    });
    
    context(@"when swiping right", ^{
        it(@"should swipe the row to the right", ^{
            
        });
    });
    
    //notification stuff?
    
    context(@"when ", ^{
        it(@"should ", ^{
            
        });
    });

});

SpecEnd