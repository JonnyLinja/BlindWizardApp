#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameFactory.h"
#import "GridCalculator.h"
#import "EnemyViewModel.h"
#import "EnemyView.h"

SpecBegin(GameFactory)

//TODO: Figure out how to TDD factories

/*
describe(@"GameFactory", ^{
    __block GameFactory *sut;
    __block id gridCalculatorMock;
    __block id viewMock;
    __block id enemyViewModelMock;
    __block id enemyViewMock;
    
    beforeEach(^{
        sut = [[GameFactory alloc] init];
        gridCalculatorMock = OCMClassMock([GridCalculator class]);
        viewMock = OCMClassMock([UIView class]);
        enemyViewModelMock = OCMClassMock([EnemyViewModel class]);
        enemyViewMock = OCMClassMock([EnemyView class]);
    });
    
    context(@"when creating an enemy", ^{
        it(@"should create an enemy with the type in the appropriate position", ^{
            //context
            NSInteger row = 2;
            NSInteger column = 3;
            CGPoint point = CGPointZero;
            CGFloat squareWidth = 10;
            CGFloat squareHeight = 12;
            CGRect frame = CGRectMake(point.x, point.y, squareWidth, squareHeight);
            
            //because
            id enemyViewModelMock = OCMPartialMock([sut createEnemyWithType:1 atRow:row column:column]);
            
            //expect
            OCMVerify([enemyViewMock setViewModel:enemyViewModelMock]);
            OCMVerify([gridCalculatorMock calculatePointForRow:row column:column]);
            OCMVerify([gridCalculatorMock squareWidth]);
            OCMVerify([gridCalculatorMock squareHeight]);
            OCMVerify([enemyViewModelMock setFrame:frame]);
            expect(enemyViewMock.superview).to.equal(sut.view);
            
            //cleanup
            [enemyViewMock stopMocking];
        });
    });
    
    afterEach(^{
        [gridCalculatorMock stopMocking];
    });
});
*/
SpecEnd