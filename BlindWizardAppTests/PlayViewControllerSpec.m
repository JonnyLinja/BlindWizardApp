#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "UIViewController+TestSegue.h"
#import "NSObject+MTKTest.h"

#import "PlayViewController.h"
#import "PlayViewModel.h"

SpecBegin(PlayViewController)

describe(@"PlayViewController", ^{
    __block PlayViewController *sut;
    __block UIStoryboard *storyboard;
    
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    beforeEach(^{
        sut = [storyboard instantiateViewControllerWithIdentifier:@"PlayViewController"];
    });
    
    context(@"when loaded", ^{
        it(@"should have a close button", ^{
            //because
            [sut view];
            
            //expect
            expect(sut.closeButton).toNot.beNil();
        });
        
        it(@"should have a score label", ^{
            //because
            [sut view];
            
            //expect
            expect(sut.scoreLabel).toNot.beNil();
        });
        
        it(@"should have a next wave button", ^{
            //because
            [sut view];
            
            //expect
            expect(sut.nextWaveButton).toNot.beNil();
        });
        
        it(@"should have a loaded board", ^{
            //context
            id storyboardMock = OCMPartialMock(storyboard);
            UIViewController *vc = [UIViewController new];
            OCMStub([storyboardMock instantiateViewControllerWithIdentifier:@"BoardViewController"]).andReturn(vc);
            
            //because
            [sut view];
            
            //expect
            OCMVerify([storyboardMock instantiateViewControllerWithIdentifier:@"BoardViewController"]);
            expect(sut.segueDestinationViewController).to.equal(vc);
            
            //cleanup
            [storyboardMock stopMocking];
        });
    });
    
    context(@"after loaded", ^{
        __block id playViewModelMock;

        beforeEach(^{
            playViewModelMock = OCMClassMock([PlayViewModel class]);
            sut.viewModel = playViewModelMock;
            [sut view];
        });
        
        context(@"when user taps the next wave button", ^{
            it(@"should create the next wave", ^{
                //because
                [sut.nextWaveButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                
                //expect
                OCMVerify([playViewModelMock nextWave]);
            });
        });
        
        context(@"when game score changes", ^{
            it(@"should display new score", ^{
                //context
                NSString *score = @"9001 points";
                
                //because
                [sut notifyKeyPath:@"viewModel.score" setTo:score];
                
                //expect
                expect(sut.scoreLabel.text).to.equal(score);
            });
        });
        
        afterEach(^{
            [playViewModelMock stopMocking];
        });
    });
});

SpecEnd