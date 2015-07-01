#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "Game.h"
#import "GameBoardLogic.h"

SpecBegin(Game)

describe(@"Game", ^{
    __block Game *sut;
    __block id gameBoardLogicMock;
    
    beforeEach(^{
        sut = [[Game alloc] init];
        gameBoardLogicMock = OCMClassMock([GameBoardLogic class]);
        sut.gameBoardLogic = gameBoardLogicMock;
    });
    
    context(@"when ", ^{
        it(@"should ", ^{
            
        });
    });
});

SpecEnd

//actual logic of where things should be on a swipe or a drop or a create
//buffering commands, swipe and next wave specifically
//ordering commands, like drop -> destroy -> drop -> destroy
//all the notifications for specific blocks
//game action notifications