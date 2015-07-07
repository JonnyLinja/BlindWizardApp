#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameObjectFactory.h"
#import "GridCalculator.h"
#import "EnemyViewModel.h"
#import "EnemyView.h"

@interface EnemyView (Testing)
@property (nonatomic, strong, readonly) EnemyViewModel *viewModel;
@end

SpecBegin(GameObjectFactory)

//went with classicist style tests, mini integration
//wasn't sure how to do this with pure mocking as it isn't dependencies
//it's tightly coupled to the objects it creates

describe(@"GameObjectFactory", ^{
    context(@"when creating an enemy", ^{
        it(@"should create an enemy with the type in the appropriate position and config", ^{
            //context - dependencies
            UIView *view = [UIView new];
            id gridCalculatorMock = OCMClassMock([GridCalculator class]);
            id factoryMock = OCMProtocolMock(@protocol(GameObjectDependencyFactory));
            GameObjectFactory *sut = [[GameObjectFactory alloc] initWithView:view calculator:gridCalculatorMock dependencyFactory:factoryMock];
            
            //context - vars
            NSInteger row = 2;
            NSInteger column = 3;
            NSInteger type = 1;
            CGPoint point = CGPointMake(2, 3);
            CGFloat elementWidth = 10;
            CGFloat elementHeight = 12;
            
            //context - grid calculator
            OCMStub([gridCalculatorMock calculatePointForRow:row column:column]).andReturn(point);
            OCMStub([gridCalculatorMock elementWidth]).andReturn(elementWidth);
            OCMStub([gridCalculatorMock elementHeight]).andReturn(elementHeight);
            
            //context - created objects
            id enemyViewModelMock = OCMClassMock([EnemyViewModel class]);
            EnemyView *enemyView = [[EnemyView alloc] initWithViewModel:enemyViewModelMock];
            OCMStub([factoryMock enemyViewModelWithType:type configuration:[OCMArg any]]).andReturn(enemyViewModelMock);
            OCMStub([factoryMock enemyViewWithViewModel:enemyViewModelMock]).andReturn(enemyView);

            //because
            EnemyViewModel *evm = [sut createEnemyWithType:type atRow:row column:column];
            EnemyView *ev = [view.subviews objectAtIndex:0];

            //expect
            OCMVerify([factoryMock enemyViewModelWithType:type configuration:[OCMArg any]]);
            OCMVerify([factoryMock enemyViewWithViewModel:enemyViewModelMock]);
            expect(ev.frame).to.equal(CGRectMake(point.x, point.y, elementWidth, elementHeight));
            expect(ev).to.equal(enemyView);
            expect(evm).to.equal(enemyViewModelMock);
            
            //cleanup
            [gridCalculatorMock stopMocking];
            [factoryMock stopMocking];
            [enemyViewModelMock stopMocking];
        });
    });
});

SpecEnd