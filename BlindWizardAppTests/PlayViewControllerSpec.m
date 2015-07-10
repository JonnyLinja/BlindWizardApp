#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "UIViewController+TestSegue.h"
#import "NSObject+MTKTest.h"

#import "PlayViewController.h"
#import "PlayViewModel.h"
#import "GridCalculatorFactory.h"
#import "GridCalculator.h"
#import "BoardViewController.h"

@interface PlayViewController ()
- (void) injectDependencies;
- (void) startGame;
@end

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
            BoardViewController *vc = [BoardViewController new];
            OCMStub([storyboardMock instantiateViewControllerWithIdentifier:@"BoardViewController"]).andReturn(vc);
            
            //because
            [sut view];
            
            //expect
            OCMVerify([storyboardMock instantiateViewControllerWithIdentifier:@"BoardViewController"]);
            expect(sut.segueDestinationViewController).to.equal(vc);
            expect(sut.boardView).toNot.beNil();
            
            //cleanup
            [storyboardMock stopMocking];
        });
        
        it(@"should have a hidden play again button", ^{
            //because
            [sut view];
            
            //expect
            expect(sut.playAgainButton).toNot.beNil();
            expect(sut.playAgainButton.hidden).to.beTruthy();
        });
    });
    
    context(@"after ui elements loaded", ^{
        __block id playViewModelMock;
        
        beforeEach(^{
            playViewModelMock = OCMClassMock([PlayViewModel class]);
            sut.viewModel = playViewModelMock;
            [sut view];
        });
        
        context(@"when loaded", ^{
            it(@"should start the game", ^{
                //context
                OCMExpect([playViewModelMock startGame]);
                
                //because
                [sut viewDidAppear:YES];
                
                //expect - hack delayed since GCD in VDA
                OCMVerifyAllWithDelay(playViewModelMock, 0.1);
            });
            
            //ugly, but need to have a delayed injection
            it(@"should load the grid calculator dependency on the view model", ^{
                //context
                id calculatorMock = OCMClassMock([GridCalculator class]);
                id calculatorFactoryMock = OCMProtocolMock(@protocol(GridCalculatorFactory));
                OCMStub([calculatorFactoryMock gridCalculatorWithWidth:[OCMArg any] height:[OCMArg any]]).andReturn(calculatorMock);
                sut.factory = calculatorFactoryMock;
                
                //because
                [sut viewDidAppear:YES];
                
                //expect
                OCMVerify([calculatorFactoryMock gridCalculatorWithWidth:[OCMArg any] height:[OCMArg any]]);
                OCMVerify([playViewModelMock setCalculator:calculatorMock]);
                
                //cleanup
                [calculatorMock stopMocking];
            });
        });
        
        context(@"when user taps the close button", ^{
            it(@"should unwind to the title screen", ^{
                //because
                [sut.closeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                
                //expect
                expect(sut.segueIdentifier).to.equal(@"UnwindFromPlayToTitleViewController");
            });
        });
        
        context(@"when user taps the next wave button", ^{
            it(@"should create the next wave", ^{
                //because
                [sut.nextWaveButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                
                //expect
                OCMVerify([playViewModelMock callNextWave]);
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
        
        context(@"when game is over", ^{
            it(@"should show the play again button", ^{
                //context
                [sut startGame];
                
                //because
                [sut notifyKeyPath:@"viewModel.gameInProgress" setTo:@NO];
                
                //expect
                expect(sut.playAgainButton.hidden).after(1).to.beFalsy();
            });
        });
        
        context(@"when game is playing", ^{
            it(@"should hide the play again button", ^{
                //context
                [sut startGame];

                //because
                [sut notifyKeyPath:@"viewModel.gameInProgress" setTo:@YES];
                
                //expect
                expect(sut.playAgainButton.hidden).after(1).to.beTruthy();
            });
        });
        
        context(@"when the board visibility changes", ^{
            it(@"should change the alpha of the view", ^{
                //context
                CGFloat alpha = 0.5;
                
                //because
                [sut notifyKeyPath:@"viewModel.boardVisibility" setTo:@(alpha)];
                
                //expect
                expect(sut.boardView.alpha).to.equal(alpha);
            });
        });
        
        afterEach(^{
            [playViewModelMock stopMocking];
        });
    });
    
    //pulled out since calling [sut view] after setting the mock makes it always pass
    context(@"when the player taps on play again", ^{
        it(@"should start the game", ^{
            //context
            [sut view];
            id playViewModelMock = OCMClassMock([PlayViewModel class]);
            sut.viewModel = playViewModelMock;
            
            //because
            [sut.playAgainButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            //expect
            OCMVerify([playViewModelMock startGame]);
            
            //cleanup
            [playViewModelMock stopMocking];
        });
    });
});

SpecEnd

//TODO: run VDA only once test,  can't figure it out. StrictMocks technically work but due to KVO it fails on every map / bind as well, really no seemingly good way to write it