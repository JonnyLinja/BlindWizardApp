#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "BoardViewModel.h"
#import "Game.h"
#import "GameConstants.h"
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
                OCMVerify([gameMock commandSwipeLeftOnRow:row]);
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
                OCMVerify([gameMock commandSwipeRightOnRow:row]);
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
                NSNotification *notification = [NSNotification notificationWithName:GameUpdateCreateEnemy object:sut.game userInfo:userInfo];
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
                NSNotification *notification = [NSNotification notificationWithName:GameUpdateShiftEnemyLeft object:sut.game userInfo:userInfo];
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
                NSNotification *notification = [NSNotification notificationWithName:GameUpdateShiftEnemyRight object:sut.game userInfo:userInfo];
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
                NSNotification *notification = [NSNotification notificationWithName:GameUpdateMoveEnemyToRowHead object:sut.game userInfo:userInfo];
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
                NSNotification *notification = [NSNotification notificationWithName:GameUpdateMoveEnemyToRowTail object:sut.game userInfo:userInfo];
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
                //context
                NSInteger fromRow = 3;
                NSInteger toRow = 0;
                NSInteger column = 3;
                CGPoint toPoint = CGPointZero;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"fromRow" : @(fromRow), @"toRow" : @(toRow), @"column" : @(column)};
                NSNotification *notification = [NSNotification notificationWithName:GameUpdateDropEnemyDown object:sut.game userInfo:userInfo];
                OCMStub([gridCalculatorMock calculatePointForRow:toRow column:column]).andReturn(toPoint);
                OCMStub([gridStorageMock objectForRow:fromRow column:column]).andReturn(modelMock);
                
                //because
                [sut drop:notification];
                
                //expect
                OCMVerify([gridCalculatorMock calculatePointForRow:toRow column:column]);
                OCMVerify([gridStorageMock objectForRow:fromRow column:column]);
                OCMVerify([modelMock animateMoveToCGPoint:toPoint]);
                OCMVerify([gridStorageMock promiseSetObject:modelMock forRow:toRow column:column]);

                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there are enemies marked as dangerously close", ^{
            it(@"should run a danger animation for those enemies", ^{
                //context
                NSInteger row = 2;
                NSInteger column = 2;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(column)};
                NSNotification *notification = [NSNotification notificationWithName:GameUpdateMarkEnemyAsDangerous object:sut.game userInfo:userInfo];
                OCMStub([gridStorageMock objectForRow:row column:column]).andReturn(modelMock);
                
                //because
                [sut danger:notification];
                
                //expect
                OCMVerify([gridStorageMock objectForRow:row column:column]);
                OCMVerify([modelMock runDangerAnimation]);
                
                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there are enemies marked as pacified", ^{
            it(@"should stop danger animation for those enemies", ^{
                //context
                NSInteger row = 2;
                NSInteger column = 2;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(column)};
                NSNotification *notification = [NSNotification notificationWithName:GameUpdateMarkEnemyAsPacified object:sut.game userInfo:userInfo];
                OCMStub([gridStorageMock objectForRow:row column:column]).andReturn(modelMock);
                
                //because
                [sut pacify:notification];
                
                //expect
                OCMVerify([gridStorageMock objectForRow:row column:column]);
                OCMVerify([modelMock stopDangerAnimation]);
                
                //cleanup
                [modelMock stopMocking];
            });
        });
        
        //TODO: Explosions! For now, skipping it in favor of barebones
        context(@"when there is an enemy to be destroyed", ^{
            it(@"should destroy the enemy, animate it with a sprite, and remove it from the stores", ^{
                //context
                NSInteger row = 2;
                NSInteger column = 2;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                //id explosionMock = OCMClassMock([Explosion class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(column)};
                NSNotification *notification = [NSNotification notificationWithName:GameUpdateDestroyEnemy object:sut.game userInfo:userInfo];
                OCMStub([gridStorageMock objectForRow:row column:column]).andReturn(modelMock);
                //OCMStub([gameFactoryMock createExplosionAtRow:row column:column]).andReturn(explosionMock);
                
                //because
                [sut destroy:notification];
                
                //expect
                OCMVerify([gridStorageMock objectForRow:row column:column]);
                OCMVerify([modelMock runDestroyAnimation]);
                OCMVerify([gridStorageMock promiseRemoveObjectForRow:row column:column]);
                
                //cleanup
                [modelMock stopMocking];
                //[explosionMock stopMocking];
            });
        });
        
        context(@"when a game action completes", ^{
           it(@"should update the grid storage", ^{
               //because
               [sut handleGameActionComplete];
               
               //expect
               OCMVerify([gridStorageMock fulfillPromises]);
           });
        });
        
        afterEach(^{
            [gameFactoryMock stopMocking];
            [gridStorageMock stopMocking];
        });
    });
    
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