#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameObjectFactory.h"
#import "GameObjectDependencyFactory.h"
#import "GridCalculator.h"
#import "EnemyViewModel.h"
#import "EnemyView.h"
#import "EnemyOutlineViewModel.h"
#import "EnemyOutlineView.h"

@interface EnemyView (Test)
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
            GameObjectFactory *sut = [[GameObjectFactory alloc] initWithView:view calculator:gridCalculatorMock dependencyFactory:factoryMock config:nil];
            
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
            id enemyViewModelMock2 = OCMClassMock([EnemyViewModel class]);
            EnemyView *enemyView = [[EnemyView alloc] initWithViewModel:enemyViewModelMock];
            EnemyView *enemyView2 = [[EnemyView alloc] initWithViewModel:enemyViewModelMock2];
            OCMStub([factoryMock enemyViewModelWithType:@(type) configuration:[OCMArg any]]).andReturn(enemyViewModelMock);
            OCMStub([factoryMock enemyViewWithViewModel:enemyViewModelMock]).andReturn(enemyView);
            OCMStub([factoryMock enemyViewModelWithType:@(type+1) configuration:[OCMArg any]]).andReturn(enemyViewModelMock2);
            OCMStub([factoryMock enemyViewWithViewModel:enemyViewModelMock2]).andReturn(enemyView2);

            //because
            EnemyViewModel *evm = [sut createEnemyWithType:type atRow:row column:column];
            EnemyView *ev = [view.subviews objectAtIndex:0];
            [sut createEnemyWithType:type+1 atRow:row column:column+1];
            EnemyView *ev2 = [view.subviews objectAtIndex:1];

            //expect
            OCMVerify([factoryMock enemyViewModelWithType:@(type) configuration:[OCMArg any]]);
            OCMVerify([factoryMock enemyViewWithViewModel:enemyViewModelMock]);
            expect(ev.frame).to.equal(CGRectMake(point.x, point.y, elementWidth, elementHeight));
            expect(ev).to.equal(enemyView);
            expect(evm).to.equal(enemyViewModelMock);
            expect(ev.accessibilityIdentifier).to.equal(@"Enemy0");
            expect(ev2.accessibilityIdentifier).to.equal(@"Enemy1");
            
            //cleanup
            [gridCalculatorMock stopMocking];
            [factoryMock stopMocking];
            [enemyViewModelMock stopMocking];
        });
    });
    
    context(@"when creating an enemy outline", ^{
        it(@"should create an enemy outline with the type in the appropriate position and config", ^{
            //context - dependencies
            UIView *view = [UIView new];
            id gridCalculatorMock = OCMClassMock([GridCalculator class]);
            id factoryMock = OCMProtocolMock(@protocol(GameObjectDependencyFactory));
            GameObjectFactory *sut = [[GameObjectFactory alloc] initWithView:view calculator:gridCalculatorMock dependencyFactory:factoryMock config:nil];
            
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
            id enemyOutlineViewModelMock = OCMClassMock([EnemyOutlineViewModel class]);
            id enemyOutlineViewModelMock2 = OCMClassMock([EnemyOutlineViewModel class]);
            EnemyOutlineView *enemyOutlineView = [[EnemyOutlineView alloc] initWithViewModel:enemyOutlineViewModelMock];
            EnemyOutlineView *enemyOutlineView2 = [[EnemyOutlineView alloc] initWithViewModel:enemyOutlineViewModelMock2];
            OCMStub([factoryMock enemyOutlineViewModelWithType:@(type) configuration:[OCMArg any]]).andReturn(enemyOutlineViewModelMock);
            OCMStub([factoryMock enemyOutlineViewWithViewModel:enemyOutlineViewModelMock]).andReturn(enemyOutlineView);
            OCMStub([factoryMock enemyOutlineViewModelWithType:@(type+1) configuration:[OCMArg any]]).andReturn(enemyOutlineViewModelMock2);
            OCMStub([factoryMock enemyOutlineViewWithViewModel:enemyOutlineViewModelMock2]).andReturn(enemyOutlineView2);
            
            //because
            EnemyOutlineViewModel *evm = [sut createEnemyOutlineWithType:type atRow:row column:column];
            EnemyOutlineView *ev = [view.subviews objectAtIndex:0];
            [sut createEnemyOutlineWithType:type+1 atRow:row column:column+1];
            EnemyOutlineView *ev2 = [view.subviews objectAtIndex:1];
            
            //expect
            OCMVerify([factoryMock enemyOutlineViewModelWithType:@(type) configuration:[OCMArg any]]);
            OCMVerify([factoryMock enemyOutlineViewWithViewModel:enemyOutlineViewModelMock]);
            expect(ev.frame).to.equal(CGRectMake(point.x, point.y, elementWidth, elementHeight));
            expect(ev).to.equal(enemyOutlineView);
            expect(evm).to.equal(enemyOutlineViewModelMock);
            expect(ev.accessibilityIdentifier).to.equal(@"EnemyOutline0");
            expect(ev2.accessibilityIdentifier).to.equal(@"EnemyOutline1");
            
            //cleanup
            [gridCalculatorMock stopMocking];
            [factoryMock stopMocking];
            [enemyOutlineViewModelMock stopMocking];
        });
    });
});

SpecEnd