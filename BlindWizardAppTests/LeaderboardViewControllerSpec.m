#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "UIViewController+TestSegue.h"
#import "NSObject+MTKTest.h"

#import "LeaderboardViewController.h"
#import "LeaderboardViewModel.h"

SpecBegin(LeaderboardViewController)

describe(@"LeaderboardViewController", ^{
    __block LeaderboardViewController *sut;
    __block UIStoryboard *storyboard;
    
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    beforeEach(^{
        sut = [storyboard instantiateViewControllerWithIdentifier:@"LeaderboardViewController"];
    });
    
    context(@"when loaded", ^{
        it(@"should have a close button", ^{
            //because
            [sut view];

            //expect
            expect(sut.closeButton).toNot.beNil();
        });
        
        it(@"should have a label that displays the top 10 scores", ^{
            //context
            NSString *scores = @"foobar";
            id viewModelMock = OCMClassMock([LeaderboardViewModel class]);
            sut.viewModel = viewModelMock;
            OCMStub([viewModelMock listOfTopScores]).andReturn(scores);
            [sut view];

            //because
            [sut notifyKeyPath:@"viewModel.listOfTopScores" setTo:scores];

            //expect
            expect(sut.displayLabel.text).to.equal(scores);
            
            //cleanup
            [viewModelMock stopMocking];
        });
    });
    
    context(@"when user taps the close button", ^{
        it(@"should unwind to the title screen", ^{
            //context
            [sut view];
            
            //because
            [sut.closeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            //expect
            expect(sut.segueIdentifier).to.equal(@"UnwindFromLeaderboardToTitleViewController");
        });
    });
});

SpecEnd