#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameObjectFactory.h"
#import "GridCalculator.h"
#import "EnemyViewModel.h"
#import "EnemyView.h"

SpecBegin(GameObjectFactory)

//went with classicist style tests, mini integration
//wasn't sure how to do this with pure mocking as it isn't dependencies
//it's tightly coupled to the objects it creates

describe(@"GameObjectFactory", ^{
    __block GameObjectFactory *sut;
    __block id gridCalculatorMock;
    
    beforeEach(^{
        sut = [[GameObjectFactory alloc] init];
        gridCalculatorMock = OCMClassMock([GridCalculator class]);
        sut.gridCalculator = gridCalculatorMock;
    });
    
    context(@"when creating an enemy", ^{
        it(@"should create an enemy with the type in the appropriate position", ^{
            //context
            NSInteger row = 2;
            NSInteger column = 3;
            NSInteger type = 1;
            CGPoint point = CGPointMake(2, 3);
            CGFloat squareWidth = 10;
            CGFloat squareHeight = 12;
            UIView *view = [UIView new];
            sut.view = view;
            OCMStub([gridCalculatorMock calculatePointForRow:row column:column]).andReturn(point);
            OCMStub([gridCalculatorMock squareWidth]).andReturn(squareWidth);
            OCMStub([gridCalculatorMock squareHeight]).andReturn(squareHeight);
            
            //because
            EnemyViewModel *evm = [sut createEnemyWithType:type atRow:row column:column];
            EnemyView *ev = [view.subviews objectAtIndex:0];

            //expect
            expect(evm.enemyType).to.equal(type);
            expect(ev.frame).to.equal(CGRectMake(point.x, point.y, squareWidth, squareHeight));
            expect(ev).toNot.beNil();
            expect(ev.viewModel).to.equal(evm);
        });
    });
    
    afterEach(^{
        [gridCalculatorMock stopMocking];
    });
});

SpecEnd