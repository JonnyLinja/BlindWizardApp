#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "DropEnemiesDownGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

SpecBegin(DropEnemiesDownGameAction)

describe(@"DropEnemiesDownGameAction", ^{
    __block DropEnemiesDownGameAction *sut;
    __block id factoryMock;
    
    beforeEach(^{
        sut = [[DropEnemiesDownGameAction alloc] init];
        sut.gameBoard = [[GameBoard alloc] init];
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut.factory = factoryMock;
    });
    
    context(@"when executing", ^{
        it(@"should drop everything down so there's no 0s at the bottom of the column and notify changes for actual objects", ^{
            //context
            NSInteger column = 0;
            NSMutableArray *startData = [@[@0, @1, @3, @0, @1, @0, @0, @0, @2, @0] mutableCopy];
            NSMutableArray *endData = [@[@3, @1, @1, @0, @2, @0, @0, @0, @0, @0] mutableCopy];
            sut.gameBoard.numRows = 5;
            sut.gameBoard.numColumns = 2;
            sut.gameBoard.data = startData;
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateDropEnemyDown object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateDropEnemyDown
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@(column));
                expect([userInfo objectForKey:@"fromRow"]).to.equal(@1);
                expect([userInfo objectForKey:@"toRow"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDropEnemyDown
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@(column));
                expect([userInfo objectForKey:@"fromRow"]).to.equal(@2);
                expect([userInfo objectForKey:@"toRow"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDropEnemyDown
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@(column));
                expect([userInfo objectForKey:@"fromRow"]).to.equal(@4);
                expect([userInfo objectForKey:@"toRow"]).to.equal(@2);
                return YES;
            }]];
            
            //because
            [sut execute];
            
            //expect
            expect(startData).to.equal(endData);
            OCMVerifyAll(notificationMock);
            
            //cleanup
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
    
    context(@"when at least one column has a 0 under a 1+", ^{
        it(@"should be valid", ^{
            //context
            sut.gameBoard.data = [@[@0, @0, @1, @0] mutableCopy];
            sut.gameBoard.numRows = 2;
            sut.gameBoard.numColumns = 2;
            
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });
    
    context(@"when there are no columns with a 0 under a 1+", ^{
        it(@"should be invalid", ^{
            //context
            sut.gameBoard.data = [@[@1, @0, @1, @0] mutableCopy];
            sut.gameBoard.numRows = 2;
            sut.gameBoard.numColumns = 2;

            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beFalsy();
        });
    });
    
    context(@"when generating next game action", ^{
        it(@"should create a destroy game action", ^{
            //context
            OCMExpect([factoryMock createDestroyEnemyGroupsGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            
            //because
            [sut generateNextGameActions];
            
            //expect
            OCMVerifyAll(factoryMock);
        });
    });
});

SpecEnd