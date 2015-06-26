#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "BoardViewModel.h"
#import "Game.h"
#import "GridCalculator.h"

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
        __block id notificationMock;
        
        beforeAll(^{
            notificationMock = OCMPartialMock([NSNotificationCenter defaultCenter]);
        });
        
        it(@"should listen for create notifications", ^{
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game CreateNotificationName] object:sut.game]);
        });
        
        it(@"should listen for move notifications", ^{
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game MoveNotificationName] object:sut.game]);
        });
        
        it(@"should listen for destroy notifications", ^{
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game DestroyNotificationName] object:sut.game]);
        });
        
        afterAll(^{
            [notificationMock stopMocking];
        });
    });
    
    context(@"swiping", ^{
        __block id gridCalculatorMock;
        
        beforeEach(^{
            gridCalculatorMock = OCMClassMock([GridCalculator class]);
            sut.gridCalculator = gridCalculatorMock;
        });
        
        context(@"when swiping left", ^{
            it(@"should swipe the row to the left", ^{
                //context
                CGFloat yPos = 10;
                NSInteger row = 3;
                OCMStub([gridCalculatorMock calculateRowForYPos:yPos]).andReturn(row);
                
                //because
                [sut swipeLeftFromPoint:CGPointMake(10, yPos)];
                
                //expect
                OCMVerify([gridCalculatorMock calculateRowForYPos:yPos]);
                OCMVerify([gameMock swipeLeftOnRow:row]);
            });
        });
        
        context(@"when swiping right", ^{
            it(@"should swipe the row to the right", ^{
                //context
                CGFloat yPos = 10;
                NSInteger row = 3;
                OCMStub([gridCalculatorMock calculateRowForYPos:yPos]).andReturn(row);
                
                //because
                [sut swipeRightFromPoint:CGPointMake(10, yPos)];
                
                //expect
                OCMVerify([gridCalculatorMock calculateRowForYPos:yPos]);
                OCMVerify([gameMock swipeRightOnRow:row]);
            });
        });
        
        afterEach(^{
            [gridCalculatorMock stopMocking];
        });
    });
    
    context(@"when there are objects to be created", ^{
        it(@"should create and animate the objects", ^{
            
        });
    });

    context(@"when there are objects to be moved", ^{
        it(@"should move and animate the objects", ^{
            
        });
    });
    
    context(@"when there are objects to be destroyed", ^{
        it(@"should destroy and animate the objects", ^{
            
        });
    });
    
    afterEach(^{
        [gameMock stopMocking];
    });
});

SpecEnd