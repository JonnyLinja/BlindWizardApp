#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "EnemyViewModel.h"
#import <UIKit/UIKit.h>

SpecBegin(EnemyViewModel)

describe(@"EnemyViewModel", ^{
    __block EnemyViewModel *sut;
    
    beforeEach(^{
        sut = [[EnemyViewModel alloc] initWithType:2 moveDuration:0 configuration:@{@"Color" : @"#FFFFFF"}];
    });
    
    context(@"when type is set", ^{
        it(@"should set the color", ^{
            expect(sut.color).to.equal([UIColor colorWithRed:1 green:1 blue:1 alpha:1]);
        });
    });
    
    context(@"when running neutral animation ", ^{
        it(@"should set the face", ^{
            //because
            [sut runNeutralAnimation];
            
            //expect
            expect(sut.face).to.equal(@"'-'");
        });
    });
    
    context(@"when running a create animation", ^{
        it(@"should set animation type to create", ^{
            //because
            [sut runCreateAnimation];
            
            //expect
            expect(sut.animationType).to.equal(CreateAnimation);
        });
        
        it(@"should set the face", ^{
            //because
            [sut runCreateAnimation];
            
            //expect
            expect(sut.face).to.equal(@"'-'");
        });
    });
    
    context(@"when running a destroy animation", ^{
        it(@"should set animation type to destroy and set the face", ^{
            //because
            [sut runDestroyAnimation];
            
            //expect
            expect(sut.animationType).to.equal(DestroyAndRemoveAnimation);
        });
        
        it(@"should set the face", ^{
            //because
            [sut runDestroyAnimation];
            
            //expect
            expect(sut.face).to.equal(@"*෴*");
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
        
        it(@"should set the face", ^{
            //because
            [sut animateMoveToCGPoint:CGPointZero];
            
            //expect
            expect(sut.face).to.equal(@"ᵔ.ᵔ");
        });
        
        it(@"should reset the animation type", ^{
            //because
            [sut runNeutralAnimation];
            
            //expect
            expect(sut.animationType).after(0.1).to.equal(NoAnimation);
        });
    });
    
    context(@"when running a snap and move animation", ^{
        it(@"should set animation type to snap and move AND set movePoint AND set snapPoint", ^{
            //context
            CGPoint movePoint = CGPointMake(13, 37);
            CGPoint snapPoint = CGPointMake(20, 12);
            
            //because
            [sut snapToCGPoint:snapPoint thenAnimateMoveToCGPoint:movePoint];
            
            //expect
            expect(sut.animationType).to.equal(SnapAndMoveAnimation);
            expect(sut.movePoint).to.equal(movePoint);
            expect(sut.snapPoint).to.equal(snapPoint);
        });
        
        it(@"should set the face", ^{
            //because
            [sut snapToCGPoint:CGPointZero thenAnimateMoveToCGPoint:CGPointZero];
            
            //expect
            expect(sut.face).to.equal(@"ᵔ.ᵔ");
        });
        
        it(@"should reset the animation type", ^{
            //because
            [sut runNeutralAnimation];
            
            //expect
            expect(sut.animationType).after(0.1).to.equal(NoAnimation);
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
        
        it(@"should set the face", ^{
            //because
            [sut animateMoveAndRemoveToCGPoint:CGPointZero];
            
            //expect
            expect(sut.face).to.equal(@"ᵔ.ᵔ");
        });
    });
});

SpecEnd

//TODO: danger
//TODO: stop danger
