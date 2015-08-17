#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "GameBoard+Test.h"

#import "DropEnemiesDownGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"

@interface DropEnemiesDownGameAction ()
@property (nonatomic, strong, readonly) GameBoard *gameBoard; //inject
@end

SpecBegin(DropEnemiesDownGameAction)

describe(@"DropEnemiesDownGameAction", ^{
    __block DropEnemiesDownGameAction *sut;
    __block id factoryMock;
    __block CGFloat duration;
    
    beforeEach(^{
        duration = 5;
        GameBoard *board = [[GameBoard alloc] init];
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        sut = [[DropEnemiesDownGameAction alloc] initWithGameBoard:board factory:factoryMock duration:duration];
    });
    
    context(@"when executing", ^{
        it(@"should drop everything > 0 down so there's no 0s at the bottom of the column and notify changes for actual objects", ^{
            //context
            NSInteger column = 0;
            NSMutableArray *startData = [@[@-1, @1, @0, @-4, @3, @0, @1, @0, @-2, @0, @2, @-3] mutableCopy];
            NSMutableArray *endData = [@[@3, @1, @1, @-4, @2, @0, @0, @0, @-2, @0, @0, @-3] mutableCopy];
            sut.gameBoard.numRows = 6;
            sut.gameBoard.numColumns = 2;
            sut.gameBoard.data = startData;
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateDropEnemyDown object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateDropEnemyDown
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@(column));
                expect([userInfo objectForKey:@"fromRow"]).to.equal(@2);
                expect([userInfo objectForKey:@"toRow"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDropEnemyDown
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@(column));
                expect([userInfo objectForKey:@"fromRow"]).to.equal(@3);
                expect([userInfo objectForKey:@"toRow"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDropEnemyDown
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@(column));
                expect([userInfo objectForKey:@"fromRow"]).to.equal(@5);
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
    
    context(@"when checking duration", ^{
        it(@"should return 0", ^{
            expect(sut.duration).to.equal(0);
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
    
    context(@"when at least one column has a <=0 under a 1+", ^{
        it(@"should be valid", ^{
            //context
            sut.gameBoard.data = [@[@-2, @0, @1, @0] mutableCopy];
            sut.gameBoard.numRows = 2;
            sut.gameBoard.numColumns = 2;
            
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });
    
    context(@"when there are no columns with a <=0 under a 1+", ^{
        it(@"should be invalid", ^{
            //context
            sut.gameBoard.data = [@[@1, @0, @1, @-1] mutableCopy];
            sut.gameBoard.numRows = 2;
            sut.gameBoard.numColumns = 2;

            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beFalsy();
        });
    });
    
    context(@"when generating next game action", ^{
        it(@"should create a check dangerous and a destroy game action", ^{
            //context
            OCMExpect([factoryMock repositionEnemyOutlinesGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            OCMExpect([factoryMock delayGameActionWithDuration:@(duration)]).andReturn(sut);
            OCMExpect([factoryMock checkDangerousGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            OCMExpect([factoryMock destroyEnemyGroupsGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            
            //because
            [sut generateNextGameActions];
            
            //expect
            OCMVerifyAll(factoryMock);
        });
    });
});

SpecEnd