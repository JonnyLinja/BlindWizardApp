#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "GameBoard+Test.h"

#import "CheckDangerousGameAction.h"
#import "GameConstants.h"

@interface CheckDangerousGameAction ()
@property (nonatomic, strong, readonly) GameBoard *gameBoard; //inject
@end

SpecBegin(CheckDangerousGameAction)

describe(@"CheckDangerousGameAction", ^{
    __block CheckDangerousGameAction *sut;
    
    beforeEach(^{
        GameBoard *board = [[GameBoard alloc] initWithRows:3 columns:2];
        board.isActive = YES;
        sut = [[CheckDangerousGameAction alloc] initWithGameBoard:board];
    });
    context(@"when executing", ^{
        it(@"should mark dangerous enemies that are near the top, and mark other enemies as harmless", ^{
            //context
            sut.gameBoard.data = [@[@1, @2, @3, @-1, @-2, @0] mutableCopy];
            sut.gameBoard.numRows = 3;
            sut.gameBoard.numColumns = 2;
            id notificationMock = OCMObserverMock();
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateMarkEnemyAsDangerous object:sut];
            [[NSNotificationCenter defaultCenter] addMockObserver:notificationMock name:GameUpdateMarkEnemyAsHarmless object:sut];
            [[notificationMock expect] notificationWithName:GameUpdateMarkEnemyAsHarmless
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateMarkEnemyAsDangerous
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@0);
                expect([userInfo objectForKey:@"row"]).to.equal(@1);
                return YES;
            }]];
            [[notificationMock expect] notificationWithName:GameUpdateMarkEnemyAsHarmless
                                                     object:sut
                                                   userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                expect([userInfo objectForKey:@"column"]).to.equal(@1);
                expect([userInfo objectForKey:@"row"]).to.equal(@0);
                return YES;
            }]];

            //because
            [sut execute];
            
            //expect
            OCMVerifyAll(notificationMock);
            
            //cleanup
            [[NSNotificationCenter defaultCenter] removeObserver:notificationMock];
        });
    });
    
    context(@"when checking isValid", ^{
        it(@"should return YES", ^{
            //because
            BOOL valid = [sut isValid];
            
            //expect
            expect(valid).to.beTruthy();
        });
    });

    context(@"when generating next game action", ^{
        it(@"should return NIL", ^{
            //because
            id value = [sut generateNextGameActions];
            
            //expect
            expect(value).to.beNil();
        });
    });
});

SpecEnd