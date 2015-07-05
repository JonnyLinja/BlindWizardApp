#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "EnemyViewModel.h"

SpecBegin(EnemyViewModel)

describe(@"EnemyViewModel", ^{
    __block EnemyViewModel *sut;
    
    beforeEach(^{
        sut = [[EnemyViewModel alloc] init];
    });
    
    //TODO: color
    context(@"when type is set", ^{
        it(@"should set the color", ^{

        });
    });
    
    context(@"when running a create animation", ^{
        it(@"should set animation type to create", ^{
            //because
            [sut runCreateAnimation];
            
            //expect
            expect(sut.animationType).to.equal(CreateAnimation);
        });
    });
    
    context(@"when running a destroy animation", ^{
        it(@"should set animation type to destroy", ^{
            //because
            [sut runDestroyAnimation];
            
            //expect
            expect(sut.animationType).to.equal(DestroyAndRemoveAnimation);
        });
    });

    context(@"when running a move animation", ^{
        it(@"should set animation type to move AND set movePoint", ^{
            //context
            CGPoint movePoint = CGPointMake(13, 37);
            
            //because
            [sut animateMoveToCGPoint:movePoint];
            
            //expect
            expect(sut.animationType).to.equal(MoveAnimation);
            expect(sut.movePoint).to.equal(movePoint);
        });
    });
    
    context(@"when running a move and snap animation", ^{
        it(@"should set animation type to move and snap AND set movePoint AND set snapPoint", ^{
            //context
            CGPoint movePoint = CGPointMake(13, 37);
            CGPoint snapPoint = CGPointMake(20, 12);
            
            //because
            [sut animateMoveToCGPoint:movePoint thenSnapToCGPoint:snapPoint];
            
            //expect
            expect(sut.animationType).to.equal(MoveAndSnapAnimation);
            expect(sut.movePoint).to.equal(movePoint);
            expect(sut.snapPoint).to.equal(snapPoint);
        });
    });
    
    context(@"when running a move and remove animation", ^{
        it(@"should set animation type to move and remove AND set movePoint", ^{
            //context
            CGPoint movePoint = CGPointMake(13, 37);
            
            //because
            [sut animateMoveAndRemoveToCGPoint:movePoint];
            
            //expect
            expect(sut.animationType).to.equal(MoveAndRemoveAnimation);
            expect(sut.movePoint).to.equal(movePoint);
        });
    });
});

SpecEnd

//TODO: danger
//TODO: stop danger
