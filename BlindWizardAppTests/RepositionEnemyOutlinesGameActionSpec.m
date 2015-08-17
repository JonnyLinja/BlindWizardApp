#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "GameBoard+Test.h"

#import "RepositionEnemyOutlinesGameAction.h"

#import "GameBoard.h"
#import "GameConstants.h"

@interface RepositionEnemyOutlinesGameAction ()
@property (nonatomic, strong, readonly) GameBoard *gameBoard; //inject
@end

SpecBegin(RepositionEnemyOutlinesGameAction)

describe(@"RepositionEnemyOutlinesGameAction", ^{
    __block RepositionEnemyOutlinesGameAction *sut;
    
    beforeEach(^{
        GameBoard *board = [[GameBoard alloc] init];
        sut = [[RepositionEnemyOutlinesGameAction alloc] initWithGameBoard:board];
    });
    
    context(@"when executing", ^{
        it(@"should move/create negative values to above the top most enemy and notify of any changes", ^{
            //context
            NSMutableArray *startData = [@[@1, @1, @0, @0, @2, @0, @1, @0, @-3, @-2, @0, @0] mutableCopy];
            NSMutableArray *endData = [@[@1, @1, @0, @-1, @2, @-2, @1, @0, @-3, @0, @-2, @0] mutableCopy];
            sut.gameBoard.nextWaveData = [@[@-3, @-2, @-2, @-1] mutableCopy];
            sut.gameBoard.numRows = 3;
            sut.gameBoard.numColumns = 4;
            sut.gameBoard.data = startData;
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateRepositionEnemyOutline object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateRepositionEnemyOutline
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateRepositionEnemyOutline
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@2);
                expect([userInfo objectForKey:@"row"]).to.equal(@2);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateRepositionEnemyOutline
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@3);
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
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
    
    context(@"when checking is Valid", ^{
        it(@"should return YES", ^{
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });
    
    context(@"when generating next game action", ^{
        it(@"should return nil", ^{
            //because
            id value = [sut generateNextGameActions];
            
            //expect
            expect(value).to.beNil();
        });
    });
});

SpecEnd