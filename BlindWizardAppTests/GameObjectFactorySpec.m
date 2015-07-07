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
        it(@"should create an enemy with the type in the appropriate position and config", ^{
            //context
            NSInteger row = 2;
            NSInteger column = 3;
            NSInteger type = 1;
            CGPoint point = CGPointMake(2, 3);
            CGFloat elementWidth = 10;
            CGFloat elementHeight = 12;
            UIView *view = [UIView new];
            sut.view = view;
            OCMStub([gridCalculatorMock calculatePointForRow:row column:column]).andReturn(point);
            OCMStub([gridCalculatorMock elementWidth]).andReturn(elementWidth);
            OCMStub([gridCalculatorMock elementHeight]).andReturn(elementHeight);
            
            //because
            EnemyViewModel *evm = [sut createEnemyWithType:type atRow:row column:column];
            EnemyView *ev = [view.subviews objectAtIndex:0];

            //expect
            expect(evm.enemyType).to.equal(type);
            expect(evm.configuration).toNot.beNil(); //no easy tests for actual file
            expect(ev.frame).to.equal(CGRectMake(point.x, point.y, elementWidth, elementHeight));
            expect(ev).toNot.beNil();
            expect(ev.viewModel).to.equal(evm);
        });
    });
    
    afterEach(^{
        [gridCalculatorMock stopMocking];
    });
});

SpecEnd