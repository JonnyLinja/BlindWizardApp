#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "BoardViewController.h"
#import "BoardViewModel.h"
#import "GridCalculator.h"
#import "GridCalculatorFactory.h"
#import "GameObjectFactory.h"
#import "GameObjectFactoryFactory.h"

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
        //ugly, but need to have a delayed injection
        it(@"should load the grid calculator and object factory dependency on the view model", ^{
            //context
            id calculatorMock = OCMClassMock([GridCalculator class]);
            id calculatorFactoryMock = OCMProtocolMock(@protocol(GridCalculatorFactory));
            OCMStub([calculatorFactoryMock gridCalculatorWithWidth:[OCMArg any] height:[OCMArg any]]).andReturn(calculatorMock);
            sut.calculatorFactory = calculatorFactoryMock;
            id gameObjectFactoryMock = OCMClassMock([GameObjectFactory class]);
            id gameObjectFactoryFactoryMock = OCMProtocolMock(@protocol(GameObjectFactoryFactory));
            OCMStub([gameObjectFactoryFactoryMock gameObjectFactoryWithView:sut.view gridCalculator:calculatorMock]).andReturn(gameObjectFactoryMock);
            sut.gameObjectFactoryFactory = gameObjectFactoryFactoryMock;
            
            //because
            [sut viewDidAppear:YES];
            
            //expect
            OCMVerify([boardViewModelMock setGridCalculator:calculatorMock]);
            OCMVerify([boardViewModelMock setFactory:gameObjectFactoryMock]);

            //cleanup
            [calculatorMock stopMocking];
            [gameObjectFactoryMock stopMocking];
        });
        
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
    });
    
    context(@"when view model becomes active", ^{
        it(@"should remove all subviews", ^{
            //context
            [sut.view addSubview:[UIView new]];
            
            //because
            [sut notifyKeyPath:@"viewModel.isActive" setTo:@YES];
            
            //expect
            expect(sut.view.subviews).to.beEmpty();
        });
    });
    
    context(@"when swiping left", ^{
        it(@"should swipe left using the point", ^{
            //context
            CGPoint point = CGPointMake(10, 10);
            __block id swipeMock = OCMClassMock([UISwipeGestureRecognizer class]);
            OCMStub([swipeMock locationInView:sut.view]).andReturn(point);

            //because
            [sut swipedLeft:swipeMock];
            
            //expect
            OCMVerify([swipeMock locationInView:sut.view]);
            OCMVerify([boardViewModelMock swipeLeftFromPoint:point]);
            
            //cleanup
            [swipeMock stopMocking];
        });
    });
    
    context(@"when swiping right", ^{
        it(@"should swipe right using the point", ^{
            //context
            CGPoint point = CGPointMake(10, 10);
            __block id swipeMock = OCMClassMock([UISwipeGestureRecognizer class]);
            OCMStub([swipeMock locationInView:sut.view]).andReturn(point);
            
            //because
            [sut swipedRight:swipeMock];
            
            //expect
            OCMVerify([swipeMock locationInView:sut.view]);
            OCMVerify([boardViewModelMock swipeRightFromPoint:point]);
            
            //cleanup
            [swipeMock stopMocking];
        });
    });
    
    afterEach(^{
        [boardViewModelMock stopMocking];
    });
});

SpecEnd

//TODO: run VDA only once test,  can't figure it out. StrictMocks technically work but due to KVO it fails on every map / bind as well, really no seemingly good way to write it