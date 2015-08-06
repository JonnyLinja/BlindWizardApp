#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "BoardViewModel.h"
#import "Game.h"
#import "GameConstants.h"
#import "GridCalculator.h"
#import "GameObjectFactory.h"
#import "EnemyViewModel.h"
#import "EnemyOutlineViewModel.h"
#import "GridStorage.h"

@interface BoardViewModel (Test)
@property (nonatomic, strong) NSMutableDictionary *outlines;
@end

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
    
    context(@"when game starts", ^{
        it(@"should clear the grid storage", ^{
            //context
            id gridStorageMock = OCMClassMock([GridStorage class]);
            sut.gridStorage = gridStorageMock;

            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@YES];
            
            //expect
            OCMVerify([gridStorageMock removeAllObjects]);
            
            //cleanup
            [gridStorageMock stopMocking];
        });
        
        it(@"should set started to yes", ^{
            //because
            [sut notifyKeyPath:@"game.gameInProgress" setTo:@YES];
            
            //expect
            expect(sut.isActive).to.beTruthy();
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
            gameFactoryMock = OCMClassMock([GameObjectFactory class]);
            sut.factory = gameFactoryMock;
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
                OCMStub([gameFactoryMock createEnemyWithType:type atRow:row column:column]).andReturn(modelMock);

                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateCreateEnemy object:nil userInfo:userInfo];
                
                //expect
                OCMVerify([gameFactoryMock createEnemyWithType:type atRow:row column:column]);
                OCMVerify([modelMock runCreateAnimation]);
                OCMVerify([gridStorageMock promiseSetObject:modelMock forRow:row column:column]);

                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there is an outline to be created", ^{
            it(@"should remove the previous outline, animate it, create the outline, animate it, and store it", ^{
                //context
                NSInteger row = 5;
                NSInteger column = 2;
                NSInteger type = 1;
                id oldModelMock = OCMClassMock([EnemyOutlineViewModel class]);
                [sut.outlines setObject:oldModelMock forKey:@(column)];
                id modelMock = OCMClassMock([EnemyOutlineViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(column), @"type" : @(type)};
                OCMStub([gameFactoryMock createEnemyOutlineWithType:type atRow:row column:column]).andReturn(modelMock);
                
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateCreateEnemyOutline object:nil userInfo:userInfo];
                
                //expect
                OCMVerify([oldModelMock runDestroyAnimation]);
                OCMVerify([gameFactoryMock createEnemyOutlineWithType:type atRow:row column:column]);
                OCMVerify([modelMock runCreateAnimation]);
                expect([sut.outlines objectForKey:@(column)]).to.equal(modelMock);
                
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
                OCMStub([gridCalculatorMock calculatePointForRow:row column:toColumn]).andReturn(toPoint);
                OCMStub([gridStorageMock objectForRow:row column:fromColumn]).andReturn(modelMock);

                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateShiftEnemyLeft object:nil userInfo:userInfo];
                
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
                OCMStub([gridCalculatorMock calculatePointForRow:row column:toColumn]).andReturn(toPoint);
                OCMStub([gridStorageMock objectForRow:row column:fromColumn]).andReturn(modelMock);

                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateShiftEnemyRight object:nil userInfo:userInfo];
                
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
                NSInteger offscreenRightColumn = fromColumn+1;
                NSInteger beginColumn = 0;
                NSInteger offscreenLeftColumn = beginColumn-1;
                CGPoint offscreenRightPoint = CGPointMake(20, 20);
                CGPoint movePoint = CGPointMake(10, 10);
                CGPoint snapPoint = CGPointZero;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                id tempMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(fromColumn)};
                OCMStub([modelMock enemyType]).andReturn(type);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:offscreenLeftColumn]).andReturn(snapPoint);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:offscreenRightColumn]).andReturn(offscreenRightPoint);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:beginColumn]).andReturn(movePoint);
                OCMStub([gridStorageMock objectForRow:row column:fromColumn]).andReturn(modelMock);
                OCMStub([gameFactoryMock createEnemyWithType:type atRow:row column:fromColumn]).andReturn(tempMock);
                
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateMoveEnemyToRowHead object:nil userInfo:userInfo];
                
                //expect - in theory the 3 verifies are sufficient for this test
                //OCMVerify([gridStorageMock objectForRow:row column:fromColumn]);
                //OCMVerify([gridCalculatorMock calculatePointForRow:row column:offscreenLeftColumn]);
                //OCMVerify([gridCalculatorMock calculatePointForRow:row column:offscreenRightColumn]);
                //OCMVerify([gridCalculatorMock calculatePointForRow:row column:beginColumn]);
                OCMVerify([modelMock snapToCGPoint:snapPoint thenAnimateMoveToCGPoint:movePoint]);
                OCMVerify([gridStorageMock promiseSetObject:modelMock forRow:row column:beginColumn]);
                //OCMVerify([modelMock enemyType]);
                //OCMVerify([gameFactoryMock createEnemyWithType:type atRow:row column:fromColumn]);
                OCMVerify([tempMock animateMoveAndRemoveToCGPoint:offscreenRightPoint]);

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
                NSInteger offscreenLeftColumn = fromColumn-1;
                NSInteger endColumn = 4;
                NSInteger offscreenRightColumn = endColumn+1;
                CGPoint offscreenLeftPoint = CGPointMake(20, 20);
                CGPoint movePoint = CGPointZero;
                CGPoint snapPoint = CGPointMake(10, 10);
                id modelMock = OCMClassMock([EnemyViewModel class]);
                id tempMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(fromColumn)};
                OCMStub([modelMock enemyType]).andReturn(type);
                OCMStub([gridCalculatorMock numColumns]).andReturn(endColumn+1);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:offscreenRightColumn]).andReturn(snapPoint);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:offscreenLeftColumn]).andReturn(offscreenLeftPoint);
                OCMStub([gridCalculatorMock calculatePointForRow:row column:endColumn]).andReturn(movePoint);
                OCMStub([gridStorageMock objectForRow:row column:fromColumn]).andReturn(modelMock);
                OCMStub([gameFactoryMock createEnemyWithType:type atRow:row column:fromColumn]).andReturn(tempMock);
                
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateMoveEnemyToRowTail object:nil userInfo:userInfo];
                
                //expect - in theory the 3 verifies are sufficient for this test
                //OCMVerify([gridCalculatorMock numColumns]);
                //OCMVerify([gridStorageMock objectForRow:row column:fromColumn]);
                //OCMVerify([gridCalculatorMock calculatePointForRow:row column:toColumn]);
                //OCMVerify([gridCalculatorMock calculatePointForRow:row column:endColumn]);
                OCMVerify([modelMock snapToCGPoint:snapPoint thenAnimateMoveToCGPoint:movePoint]);
                OCMVerify([gridStorageMock promiseSetObject:modelMock forRow:row column:endColumn]);
                //OCMVerify([modelMock enemyType]);
                //OCMVerify([gameFactoryMock createEnemyWithType:type atRow:row column:offscreenColumn]);
                OCMVerify([tempMock animateMoveAndRemoveToCGPoint:offscreenLeftPoint]);
                
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
                OCMStub([gridCalculatorMock calculatePointForRow:toRow column:column]).andReturn(toPoint);
                OCMStub([gridStorageMock objectForRow:fromRow column:column]).andReturn(modelMock);
                
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateDropEnemyDown object:nil userInfo:userInfo];
                
                //expect
                OCMVerify([gridCalculatorMock calculatePointForRow:toRow column:column]);
                OCMVerify([gridStorageMock objectForRow:fromRow column:column]);
                OCMVerify([modelMock animateDropToCGPoint:toPoint]);
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
                OCMStub([gridStorageMock objectForRow:row column:column]).andReturn(modelMock);
                
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateMarkEnemyAsDangerous object:nil userInfo:userInfo];
                
                //expect
                OCMVerify([gridStorageMock objectForRow:row column:column]);
                OCMVerify([modelMock runDangerAnimation]);
                
                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there are enemies marked as harmless", ^{
            it(@"should stop danger animation for those enemies", ^{
                //context
                NSInteger row = 2;
                NSInteger column = 2;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(column)};
                OCMStub([gridStorageMock objectForRow:row column:column]).andReturn(modelMock);
                
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateMarkEnemyAsHarmless object:nil userInfo:userInfo];
                
                //expect
                OCMVerify([gridStorageMock objectForRow:row column:column]);
                OCMVerify([modelMock stopDangerAnimation]);
                
                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there is an enemy to be destroyed", ^{
            it(@"should destroy the enemy, animate it with a sprite, and remove it from the stores", ^{
                //context
                NSInteger row = 2;
                NSInteger column = 2;
                NSInteger score = 7;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(column), @"score" : @(score)};
                OCMStub([gridStorageMock objectForRow:row column:column]).andReturn(modelMock);
                
                //because
                [[NSNotificationCenter defaultCenter] postNotificationName:GameUpdateDestroyEnemy object:nil userInfo:userInfo];
                
                //expect
                OCMVerify([gridStorageMock objectForRow:row column:column]);
                OCMVerify([modelMock runDestroyAnimationWithScore:score]);
                OCMVerify([gridStorageMock promiseRemoveObjectForRow:row column:column]);
                
                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when a game action completes", ^{
           it(@"should update the grid storage", ^{
               //because
               [[NSNotificationCenter defaultCenter] postNotificationName:GameActionComplete object:nil];
               
               //expect
               OCMVerify([gridStorageMock fulfillPromises]);
           });
        });
        
        afterEach(^{
            [gameFactoryMock stopMocking];
            [gridStorageMock stopMocking];
        });
    });
    
    afterEach(^{
        [gameMock stopMocking];
        [gridCalculatorMock stopMocking];
        sut = nil; //TODO: remove hack fix here as lingering sut was interfering with another test, not sure why __block isn't enough as thought the sut would die after the block ends?
    });
});

SpecEnd