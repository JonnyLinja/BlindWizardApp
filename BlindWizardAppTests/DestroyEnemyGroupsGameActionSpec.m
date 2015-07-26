#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "GameBoard+Test.h"

#import "DestroyEnemyGroupsGameAction.h"
#import "GameBoard.h"
#import "GameConstants.h"
#import "GameDependencyFactory.h"
#import "ScoreCalculator.h"

@interface DestroyEnemyGroupsGameAction ()
@property (nonatomic, strong, readonly) GameBoard *gameBoard; //inject
@end

SpecBegin(DestroyEnemyGroupsGameAction)

describe(@"DestroyEnemyGroupsGameAction", ^{
    __block DestroyEnemyGroupsGameAction *sut;
    __block id factoryMock;
    __block id calculatorMock;
    
    beforeEach(^{
        GameBoard *board = [[GameBoard alloc] init];
        factoryMock = OCMProtocolMock(@protocol(GameDependencyFactory));
        calculatorMock = OCMClassMock([ScoreCalculator class]);
        sut = [[DestroyEnemyGroupsGameAction alloc] initWithGameBoard:board factory:factoryMock scoreCalculator:calculatorMock];
    });
    
    context(@"when executing", ^{
        it(@"should destroy all objects of similar type that are in rows or columns of 3+", ^{
            //context
            NSMutableArray *startData = [@[@1, @0, @2, @0, @0, @1, @2, @2, @3, @0, @1, @3, @3, @3, @3, @2, @2, @2, @3, @0, @1, @1, @0, @3, @1, @-1, @-1, @-1, @-1, @-1] mutableCopy];
            NSMutableArray *endData = [@[@0, @0, @2, @0, @0, @0, @2, @2, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0, @0, @1, @-1, @-1, @-1, @-1, @-1] mutableCopy];
            sut.gameBoard.numRows = 6;
            sut.gameBoard.numColumns = 5;
            sut.gameBoard.data = startData;
            NSInteger scorePerEnemy = 13;
            OCMStub([calculatorMock calculateScorePerEnemyAfterDestroying:13]).andReturn(scorePerEnemy);
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateDestroyEnemy object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@4);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@3);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));

                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateDestroyEnemy
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"row"]).to.equal(@4);
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                expect([userInfo objectForKey:@"score"]).to.equal(@(scorePerEnemy));
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
        
        it(@"should update the score", ^{
            //context
            NSMutableArray *startData = [@[@1, @0, @2, @0, @0, @1, @2, @2, @3, @0, @1, @3, @3, @3, @3, @2, @2, @2, @3, @0, @1, @1, @0, @3, @1] mutableCopy];
            sut.gameBoard.numRows = 5;
            sut.gameBoard.numColumns = 5;
            sut.gameBoard.data = startData;
            sut.gameBoard.score = 10;
            OCMStub([calculatorMock calculateTotalScoreFromNumberOfEnemiesDestroyed:13]).andReturn(169);
            
            //because
            [sut execute];
            
            //expect
            expect(sut.gameBoard.score).to.equal(179);
        });
    });
    
    context(@"when at least 3 enemies of the same type in a row", ^{
        it(@"should be valid", ^{
            //context
            sut.gameBoard.data = [@[@0, @0, @0, @0, @0, @0, @1, @1, @2, @3, @3, @3] mutableCopy];
            sut.gameBoard.numRows = 4;
            sut.gameBoard.numColumns = 3;
            
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });
    
    context(@"when at least 3 enemies of the same type in a column", ^{
        it(@"should be valid", ^{
            //context
            sut.gameBoard.data = [@[@0, @0, @0, @0, @1, @3, @0, @1, @3, @0, @2, @3] mutableCopy];
            sut.gameBoard.numRows = 4;
            sut.gameBoard.numColumns = 3;
            
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });
    
    context(@"when at at most 2 enemies of the same type in a row or column", ^{
        it(@"should be invalid", ^{
            //context
            sut.gameBoard.data = [@[@-1, @-1, @-1, @0, @0, @0, @0, @0, @0, @1, @1, @2, @0, @1, @1, @2, @0, @2, @2, @1] mutableCopy];
            sut.gameBoard.numRows = 5;
            sut.gameBoard.numColumns = 4;
            
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beFalsy();
        });
    });
    
    context(@"when generating next game action", ^{
        it(@"should create a drop game action", ^{
            //context
            OCMExpect([factoryMock dropEnemiesDownGameActionWithBoard:sut.gameBoard]).andReturn(sut);
            
            //because
            [sut generateNextGameActions];
            
            //expect
            OCMVerifyAll(factoryMock);
        });
    });
    
    afterEach(^{
        [calculatorMock stopMocking];
    });
});

SpecEnd
