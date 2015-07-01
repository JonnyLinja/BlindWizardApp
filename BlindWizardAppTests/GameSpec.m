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
    
    context(@"when starting the game", ^{
        pending(@"should load initial blocks", ^{
            //because
            [sut startGame];
        });
        
        pending(@"should set the game to the starting state", ^{
            //because
            [sut startGame];
            
            //expect
            expect(sut.gameInProgress).to.beTruthy();
        });
    });
    
    context(@"when calling the next wave", ^{
        it(@"should add the command to the queue", ^{
            //should it also attempt to process the next command?
        });
    });
    
    context(@"when swiping left", ^{
        it(@"should add the command to the queue", ^{
            //should it also attempt to process the next command?
        });
    });
    
    context(@"when swiping right", ^{
        it(@"should add the command to the queue", ^{
            //should it also attempt to process the next command?
        });
    });
    
    context(@"when processing next command", ^{
        it(@"should ", ^{
            
        });
    });
    
    //when there is a command in the queue, it should process it?
    //when a command is successfully processed, it should notify game action completion?
    //when a command is successfully processed, it should process the next command after a possible delay?
    
    //who should have the delay check? Game.h or the processor itself?!?!?! INTERESTING
    //is it possible to have the delay be a behavior of the processor?
    //i don't think so...the command order object thingy should really only have the next one up
    //but it could maybe wrapped by the timer itself?
    //nah that sounds dumb
});

SpecEnd

//buffering commands, swipe and next wave specifically
//ordering commands, like drop -> destroy -> drop -> destroy
//game action notifications

//timing, waiting before processing the next command as necessary

//score