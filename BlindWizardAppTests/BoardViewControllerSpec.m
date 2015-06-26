#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "BoardViewController.h"
#import "BoardViewModel.h"

SpecBegin(BoardViewController)

describe(@"BoardViewController", ^{
    __block BoardViewController *sut;
    __block UIStoryboard *storyboard;
    __block id boardViewModelMock;
    
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    beforeEach(^{
        sut = [storyboard instantiateViewControllerWithIdentifier:@"BoardViewController"];
        boardViewModelMock = OCMClassMock([BoardViewModel class]);
        sut.viewModel = boardViewModelMock;
        [sut view];
    });
    
    context(@"when loaded", ^{
        //unable to confirm uigesturerecognizers are connected, can really only confirm they exist
        it(@"should listen for left swipes", ^{
            expect(sut.leftSwipeGestureRecognizer).toNot.beNil();
            expect(sut.leftSwipeGestureRecognizer.view).to.equal(sut.view);
        });
        
        //unable to confirm uigesturerecognizers are connected, can really only confirm they exist
        it(@"should listen for right swipes", ^{
            expect(sut.rightSwipeGestureRecognizer).toNot.beNil();
            expect(sut.rightSwipeGestureRecognizer.view).to.equal(sut.view);
        });
        
        //not sure how to do this yet, or if it even belongs in the VC, leave for later
        pending(@"should display initial blocks", ^{
            
        });
    });
    
    context(@"when swiping left", ^{
        it(@"should swipe the objects to the left", ^{
            //context
            CGPoint point = CGPointMake(10, 10);
            __block id swipeMock = OCMClassMock([UISwipeGestureRecognizer class]);
            OCMStub([swipeMock locationInView:sut.view]).andReturn(point);

            //because
            [sut swipedLeft:swipeMock];
            
            //expect
            OCMVerify([swipeMock locationInView:sut.view]);
            OCMVerify([boardViewModelMock swipeLeftFromPoint:point]);
        });
    });
    
    context(@"when swiping right", ^{
        it(@"should swipe the objects to the right", ^{
            //context
            CGPoint point = CGPointMake(10, 10);
            __block id swipeMock = OCMClassMock([UISwipeGestureRecognizer class]);
            OCMStub([swipeMock locationInView:sut.view]).andReturn(point);
            
            //because
            [sut swipedRight:swipeMock];
            
            //expect
            OCMVerify([swipeMock locationInView:sut.view]);
            OCMVerify([boardViewModelMock swipeRightFromPoint:point]);
        });
    });
    
    afterEach(^{
        [boardViewModelMock stopMocking];
    });
});

SpecEnd