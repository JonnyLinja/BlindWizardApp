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
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game MoveToRowHeadNotificationName] object:sut.game]);
        });
        
        it(@"should listen for the move to end of row notifications", ^{
            OCMVerify([notificationMock addObserver:sut selector:[OCMArg anySelector] name:[Game MoveToRowTailNotificationName] object:sut.game]);
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
            it(@"should animate move the enemy to the left and store it", ^{
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
            it(@"should animate move the enemy to the right and store it", ^{
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
            it(@"should animate move the enemy to the right, along with a duplicate from offscreen to the left, and store the enemy", ^{
                //context
                NSInteger type = 1;
                NSInteger row = 5;
                NSInteger fromColumn = 4;
                NSInteger toColumn = fromColumn+1;
                NSInteger beginColumn = 0;
                NSInteger offscreenColumn = beginColumn-1;
                CGPoint toPoint = CGPointMake(10, 10);
                CGPoint snapPoint = CGPointZero;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                id tempMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(fromColumn)};
                NSNotification *notification = [NSNotification notificationWithName:[Game MoveToRowHeadNotificationName] object:sut.game userInfo:userInfo];
                OCMStub([modelMock enemyType]).andReturn(type);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:toColumn]).andReturn(toPoint);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:beginColumn]).andReturn(snapPoint);
                OCMStub([gridStorageMock objectForRow:row column:fromColumn]).andReturn(modelMock);
                OCMStub([gameFactoryMock createEnemyWithType:type atRow:row column:offscreenColumn]).andReturn(tempMock);
                
                //because
                [sut moveToRowHead:notification];
                
                //expect
                OCMVerify([gridStorageMock objectForRow:row column:fromColumn]);
                OCMVerify([gridCalculatorMock calculatePointForRow:row column:toColumn]);
                OCMVerify([gridCalculatorMock calculatePointForRow:row column:beginColumn]);
                OCMVerify([modelMock animateMoveToCGPoint:toPoint thenSnapToCGPoint:snapPoint]);
                OCMVerify([gridStorageMock promiseSetObject:modelMock forRow:row column:beginColumn]);
                OCMVerify([modelMock enemyType]);
                OCMVerify([gameFactoryMock createEnemyWithType:type atRow:row column:offscreenColumn]);
                OCMVerify([tempMock animateMoveToCGPoint:snapPoint removeAfter:YES]);

                //cleanup
                [modelMock stopMocking];
                [tempMock stopMocking];
            });
        });
        
        context(@"when there is an enemy to be set to the end of the row", ^{
            it(@"should animate move the enemy to the left, along with a duplicate from offscreen to the right, and store the enemy", ^{
                //context
                NSInteger type = 1;
                NSInteger row = 5;
                NSInteger fromColumn = 0;
                NSInteger toColumn = fromColumn-1;
                NSInteger endColumn = 4;
                NSInteger offscreenColumn = endColumn+1;
                CGPoint toPoint = CGPointZero;
                CGPoint snapPoint = CGPointMake(10, 10);
                id modelMock = OCMClassMock([EnemyViewModel class]);
                id tempMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(fromColumn)};
                NSNotification *notification = [NSNotification notificationWithName:[Game MoveToRowTailNotificationName] object:sut.game userInfo:userInfo];
                OCMStub([modelMock enemyType]).andReturn(type);
                OCMStub([gridCalculatorMock numColumns]).andReturn(endColumn+1);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:toColumn]).andReturn(toPoint);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:endColumn]).andReturn(snapPoint);
                OCMStub([gridStorageMock objectForRow:row column:fromColumn]).andReturn(modelMock);
                OCMStub([gameFactoryMock createEnemyWithType:type atRow:row column:offscreenColumn]).andReturn(tempMock);
                
                //because
                [sut moveToRowTail:notification];
                
                //expect
                OCMVerify([gridCalculatorMock numColumns]);
                OCMVerify([gridStorageMock objectForRow:row column:fromColumn]);
                OCMVerify([gridCalculatorMock calculatePointForRow:row column:toColumn]);
                OCMVerify([gridCalculatorMock calculatePointForRow:row column:endColumn]);
                OCMVerify([modelMock animateMoveToCGPoint:toPoint thenSnapToCGPoint:snapPoint]);
                OCMVerify([gridStorageMock promiseSetObject:modelMock forRow:row column:endColumn]);
                OCMVerify([modelMock enemyType]);
                OCMVerify([gameFactoryMock createEnemyWithType:type atRow:row column:offscreenColumn]);
                OCMVerify([tempMock animateMoveToCGPoint:snapPoint removeAfter:YES]);
                
                //cleanup
                [modelMock stopMocking];
                [tempMock stopMocking];
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
        //perhaps stop shaking is fine too, out of danger and singles removes responsibility from the BoardVM
        //consider that just cuz new ones shake doesn't mean old ones should necessarily stop
        //so stop should be separate
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