#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "UIViewController+TestSegue.h"

#import "LeaderboardViewController.h"

SpecBegin(LeaderboardViewController)

describe(@"LeaderboardViewController", ^{
    __block LeaderboardViewController *sut;
    __block UIStoryboard *storyboard;
    
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    beforeEach(^{
        sut = [storyboard instantiateViewControllerWithIdentifier:@"LeaderboardViewController"];
        [sut view];
    });
    
    context(@"when loaded", ^{
        it(@"should have a close button", ^{
            expect(sut.closeButton).toNot.beNil();
        });
        
        pending(@"should have a label that displays the top 10 scores", ^{
            
        });
    });
    
    context(@"when user taps the close button", ^{
        it(@"should unwind to the title screen", ^{
            //because
            [sut.closeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            //expect
            expect(sut.segueIdentifier).to.equal(@"UnwindToTitleViewController");
        });
    });
});

SpecEnd