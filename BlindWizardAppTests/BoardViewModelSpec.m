#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "BoardViewModel.h"
#import "Game.h"
#import "GridCalculator.h"
#import "GameFactory.h"
#import "EnemyViewModel.h"
#import "NSString+GridPosition.h"

//TODO: THERE SHOULD ALSO BE A JIGGLE COMMAND
//MAYBE CAN DO THAT ON THE ACTUAL VIEWS THOUGH

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
        });
        
        it(@"should listen for shift right notifications", ^{
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
        
        beforeEach(^{
            gameFactoryMock = OCMClassMock([GameFactory class]);
            sut.gameFactory = gameFactoryMock;
        });
        
        context(@"when there is an enemy to be created", ^{
            it(@"should create the enemy, animate it, and store it", ^{
                //context
                NSInteger row = 5;
                NSInteger column = 0;
                NSString *position = [NSString stringFromRow:row column:column];
                id modelMock = OCMClassMock([EnemyViewModel class]);
                OCMStub([gameFactoryMock createEnemyAtRow:row column:column]).andReturn(modelMock);
                NSDictionary *userInfo = @{@"row" : @(row), @"column" : @(column)};
                NSNotification *notification = [NSNotification notificationWithName:[Game CreateNotificationName] object:sut.game userInfo:userInfo];

                //because
                [sut create:notification];
                
                //expect
                OCMVerify([gameFactoryMock createEnemyAtRow:row column:column]);
                OCMVerify([modelMock runCreateAnimation]);
                expect([sut.enemies objectForKey:position]).to.equal(modelMock);

                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there is an enemy to be shifted left", ^{
            it(@"should move and animate the enemy to the left, then set its position in the store", ^{
                //context
                NSInteger fromRow = 5;
                NSInteger toRow = 5;
                NSInteger fromColumn = 2;
                NSInteger toColumn = 1;
                NSString *origPos = [NSString stringFromRow:fromRow column:fromColumn];
                NSString *newPos = [NSString stringFromRow:toRow column:toColumn];
                CGPoint toPoint = CGPointZero;
                id modelMock = OCMClassMock([EnemyViewModel class]);
                OCMStub([gridCalculatorMock calculatePointForRow:toRow column:toColumn]).andReturn(toPoint);
                [sut.enemies setObject:modelMock forKey:origPos];
                NSDictionary *userInfo = @{@"row" : @(fromRow), @"column" : @(fromColumn)};
                NSNotification *notification = [NSNotification notificationWithName:[Game ShiftLeftNotificationName] object:sut.game userInfo:userInfo];
                
                //because
                [sut shiftLeft:notification];
                
                //expect
                OCMVerify([gridCalculatorMock calculatePointForRow:toRow column:toColumn]);
                OCMVerify([modelMock animateMoveToCGPoint:toPoint]);
                expect([sut.enemies objectForKey:origPos]).to.beNil();
                expect([sut.enemies objectForKey:newPos]).to.equal(modelMock);
                
                //cleanup
                [modelMock stopMocking];
            });
        });
        
        context(@"when there is an enemy to be shifted right", ^{
            it(@"should move and animate the enemy to the right, then set its position in the store", ^{
            });
        });
        
        context(@"when there is an enemy to be set to the beginning of the row", ^{
            //TODO: this is complicated, may want to expand on it
            it(@"should move and animate the enemy off screen to the right, then place the enemy at the beginning of the row", ^{
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