#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "BoardViewModel.h"
#import "Game.h"
#import "GridCalculator.h"
#import "GameFactory.h"
#import "EnemyViewModel.h"
#import "GridStorage.h"

SpecBegin(BoardViewModel)

describe(@"BoardViewModel", ^{
    __block BoardViewModel *sut;
    __block id gameMock;
    __block id gridCalculatorMock;
    
    beforeEach(^{
        sut = [[BoardViewModel alloc] init];
        gameMock = OCMClassMock([Game class]);
        sut.game = gameMock;
        gridCalculatorMock = OCMClassMock([GridCalculator class]);
        sut.gridCalculator = gridCalculatorMock;
    });
    
    context(@"when initialized", ^{
        __block id notificationMock;
        
        beforeAll(^{
            notificationMock = OCMPartialMock([NSNotificationCenter defaultCenter]);
        });
        
        it(@"should listen for create notifications", ^{
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game CreateNotificationName] object:sut.game]);
        });
        
        it(@"should listen for shift left notifications", ^{
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game ShiftLeftNotificationName] object:sut.game]);
        });
        
        it(@"should listen for shift right notifications", ^{
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game ShiftRightNotificationName] object:sut.game]);
        });
        
        it(@"should listen for the move to beginning of row notifications", ^{
        });
        
        it(@"should listen for the move to end of row notifications", ^{
        });
        
        it(@"should listen for drop notifications", ^{
        });
        
        it(@"should listen for danger notifications", ^{
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game DangerNotificationName] object:sut.game]);
        });
        
        it(@"should listen for destroy notifications", ^{
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game DestroyNotificationName] object:sut.game]);
        });
        
        afterAll(^{
            [notificationMock stopMocking];
        });
    });
    
    context(@"swiping", ^{
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
    });
    
    context(@"notification handling", ^{
        __block id gameFactoryMock;
        __block id gridStorageMock;
        
        beforeEach(^{
            gameFactoryMock = OCMClassMock([GameFactory class]);
            sut.gameFactory = gameFactoryMock;
            gridStorageMock = OCMClassMock([GridStorage class]);
            sut.gridStorage = gridStorageMock;
        });
        
        context(@"when there is an enemy to be created", ^{
            it(@"should create the enemy, animate it, and store it", ^{
                //context
                NSInteger row = 5;
                NSInteger column = 0;
                NSInteger type = 1;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(column), @"type" : @(type)};
                NSNotification *notification = [NSNotification notificationWithName:[Game CreateNotificationName] object:sut.game userInfo:userInfo];
                OCMStub([gameFactoryMock createEnemyWithType:type atRow:row column:column]).andReturn(modelMock);

                //because
                [sut create:notification];
                
                //expect
                OCMVerify([gameFactoryMock createEnemyWithType:type atRow:row column:column]);
                OCMVerify([modelMock runCreateAnimation]);
                OCMVerify([gridStorageMock promiseSetObject:modelMock forRow:row column:column]);

                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there is an enemy to be shifted left", ^{
            it(@"should move and animate the enemy to the left, then set its position in the store", ^{
                //context
                NSInteger row = 5;
                NSInteger fromColumn = 2;
                NSInteger toColumn = fromColumn-1;
                CGPoint toPoint = CGPointZero;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(fromColumn)};
                NSNotification *notification = [NSNotification notificationWithName:[Game ShiftLeftNotificationName] object:sut.game userInfo:userInfo];
                OCMStub([gridCalculatorMock calculatePointForRow:row column:toColumn]).andReturn(toPoint);
                OCMStub([gridStorageMock objectForRow:row column:fromColumn]).andReturn(modelMock);

                //because
                [sut shiftLeft:notification];
                
                //expect
                OCMVerify([gridCalculatorMock calculatePointForRow:row column:toColumn]);
                OCMVerify([gridStorageMock objectForRow:row column:fromColumn]);
                OCMVerify([modelMock animateMoveToCGPoint:toPoint]);
                OCMVerify([gridStorageMock promiseSetObject:modelMock forRow:row column:toColumn]);
                
                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there is an enemy to be shifted right", ^{
            it(@"should move and animate the enemy to the right, then set its position in the store", ^{
                //context
                NSInteger row = 5;
                NSInteger fromColumn = 2;
                NSInteger toColumn = fromColumn+1;
                CGPoint toPoint = CGPointZero;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(fromColumn)};
                NSNotification *notification = [NSNotification notificationWithName:[Game ShiftRightNotificationName] object:sut.game userInfo:userInfo];
                OCMStub([gridCalculatorMock calculatePointForRow:row column:toColumn]).andReturn(toPoint);
                OCMStub([gridStorageMock objectForRow:row column:fromColumn]).andReturn(modelMock);

                //because
                [sut shiftRight:notification];
                
                //expect
                OCMVerify([gridCalculatorMock calculatePointForRow:row column:toColumn]);
                OCMVerify([gridStorageMock objectForRow:row column:fromColumn]);
                OCMVerify([modelMock animateMoveToCGPoint:toPoint]);
                OCMVerify([gridStorageMock promiseSetObject:modelMock forRow:row column:toColumn]);
                
                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there is an enemy to be set to the beginning of the row", ^{
            //TODO: this is complicated, may want to expand on it
            it(@"should animate move the enemy off screen to the right, then place the enemy at the beginning of the row", ^{
            });
            it(@"should create an animate a sprite from off screen to the left, and animate it to the beginning of the row, then remove it", ^{
            });
        });
        
        context(@"when there is an enemy to be set to the end of the row", ^{
            //TODO: this is complicated, may want to expand on it
            it(@"should move and animate the enemy off screen to the left, then place the enemy at the end of the row", ^{
            });
            it(@"should create an animate a sprite from off screen to the right, and animate it to the end of the row, then remove it", ^{
            });
        });
        
        context(@"when is an enemy to be dropped to the bottom of the column", ^{
            it(@"should move and animate the enemy to the new position", ^{
                
            });
        });
        
        //TODO: consider the userinfo
        //is this a, it just passes a column and i have to find it? but requires more search code so not sure i like...as it's a dictionary
        //is this a, array of what to shakey shakey, this might be the best way, leaning this way as can do set comparison and no searching
        //is this a, individual one to shake? it's more aligned with everything else but doens't help me "stop" existing dangerous ones, would need a "stop" almost eww
        pending(@"when there are enemies marked as dangerously close", ^{
            it(@"should run a danger animation for those enemies, and stop the danger animation for the others", ^{
                
            });
        });
        
        context(@"when there is an enemy to be destroyed", ^{
            it(@"should destroy the enemy, animate it, and remove it from the stores", ^{
                
            });
        });
        
        afterEach(^{
            [gameFactoryMock stopMocking];
        });
    });
    
    //TODO: listening for end of stages in order to save the store itself
    
    //TODO:
    pending(@"when animations are run", ^{
        it(@"should pause the game until they are complete", ^{
            
        });
    });
    
    afterEach(^{
        [gameMock stopMocking];
        [gridCalculatorMock stopMocking];
    });
});

SpecEnd