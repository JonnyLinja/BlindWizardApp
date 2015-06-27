#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "BoardViewModel.h"
#import "Game.h"
#import "GridCalculator.h"
#import "GameFactory.h"
#import "ObjectPosition.h"
#import "EnemyViewModel.h"

//TODO: THERE SHOULD ALSO BE A JIGGLE COMMAND
//MAYBE CAN DO THAT ON THE ACTUAL VIEWS THOUGH

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
    
    context(@"notification handling", ^{
        __block id gameFactoryMock;
        
        beforeEach(^{
            gameFactoryMock = OCMClassMock([GameFactory class]);
            sut.gameFactory = gameFactoryMock;
        });
        
        context(@"when there are enemies to be created", ^{
            it(@"should create the enemies, animate them, and store them", ^{
                //context
                ObjectPosition *pos1 = [[ObjectPosition alloc] initWithRow:5 andColumn:0];
                ObjectPosition *pos2 = [[ObjectPosition alloc] initWithRow:5 andColumn:1];
                id model1Mock = OCMClassMock([EnemyViewModel class]);
                id model2Mock = OCMClassMock([EnemyViewModel class]);
                OCMStub([gameFactoryMock createEnemyAtPosition:pos1]).andReturn(model1Mock);
                OCMStub([gameFactoryMock createEnemyAtPosition:pos2]).andReturn(model2Mock);
                NSDictionary *userInfo = @{@"indices" : @[pos1, pos2]};
                NSNotification *notification = [NSNotification notificationWithName:[Game CreateNotificationName] object:sut.game userInfo:userInfo];

                //because
                [sut create:notification];
                
                //expect
                OCMVerify([gameFactoryMock createEnemyAtPosition:pos1]);
                OCMVerify([gameFactoryMock createEnemyAtPosition:pos2]);
                OCMVerify([model1Mock runCreateAnimation]);
                OCMVerify([model2Mock runCreateAnimation]);
                expect([sut.enemies objectForKey:pos1]).to.equal(model1Mock);
                expect([sut.enemies objectForKey:pos2]).to.equal(model2Mock);

                //cleanup
                [model1Mock stopMocking];
                [model2Mock stopMocking];
            });
        });
        
        context(@"when there are enemies to be moved", ^{
            it(@"should move and animate the enemies", ^{
                
            });
        });
        
        context(@"when there are enemies marked as dangerously close", ^{
            it(@"should run a danger animation for those enemies, and stop the danger animation for the others", ^{
                
            });
        });
        
        context(@"when there are enemies to be destroyed", ^{
            it(@"should destroy the enemies and animate it", ^{
                
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
    });
});

SpecEnd