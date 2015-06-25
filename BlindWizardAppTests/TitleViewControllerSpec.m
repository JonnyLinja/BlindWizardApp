#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "UIViewController+TestSegue.h"

#import "TitleViewController.h"

SpecBegin(TitleViewController)

describe(@"TitleViewController", ^{
    __block TitleViewController *sut;
    __block UIStoryboard *storyboard;
    
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    beforeEach(^{
        sut = [storyboard instantiateViewControllerWithIdentifier:@"TitleViewController"];
        [sut view];
    });

    context(@"when loaded", ^{
        it(@"should have a play button", ^{
            expect(sut.playButton).toNot.beNil();
        });
        
        it(@"should have a leaderboard button", ^{
            expect(sut.leaderboardButton).toNot.beNil();
        });
    });
    
    context(@"when the player taps on the play button", ^{
        it(@"should load the game", ^{
            //context
            id storyboardMock = OCMPartialMock(storyboard);
            UIViewController *vc = [UIViewController new];
            OCMStub([storyboardMock instantiateViewControllerWithIdentifier:@"PlayViewController"]).andReturn(vc);
            
            //because
            [sut.playButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            //expect
            OCMVerify([storyboardMock instantiateViewControllerWithIdentifier:@"PlayViewController"]);
            expect(sut.segueDestinationViewController).to.equal(vc);
            
            //cleanup
            [storyboardMock stopMocking];
        });
    });
    
    context(@"when the player taps on the leaderboard button", ^{
        it(@"should load the leaderboard screen", ^{
            //context
            id storyboardMock = OCMPartialMock(storyboard);
            UIViewController *vc = [UIViewController new];
            OCMStub([storyboardMock instantiateViewControllerWithIdentifier:@"LeaderboardViewController"]).andReturn(vc);
            
            //because
            [sut.leaderboardButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            //expect
            OCMVerify([storyboardMock instantiateViewControllerWithIdentifier:@"LeaderboardViewController"]);
            expect(sut.segueDestinationViewController).to.equal(vc);
            
            //cleanup
            [storyboardMock stopMocking];
        });
    });
});

SpecEnd