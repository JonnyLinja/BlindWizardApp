#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "EnemyView.h"
#import "EnemyViewModel.h"

SpecBegin(EnemyView)

describe(@"EnemyView", ^{
    __block id viewModelMock;
    
    beforeEach(^{
        viewModelMock = OCMClassMock([EnemyViewModel class]);
    });
    
    context(@"when loaded", ^{
        it(@"should display a colored bordered rectangle", ^{
            //context
            UIColor *color = [UIColor blackColor];
            OCMStub([viewModelMock color]).andReturn(color);
            
            //because
            EnemyView *sut = [[EnemyView alloc] initWithViewModel:viewModelMock];
            
            //expect
            expect(sut.layer.borderWidth).to.beGreaterThan(1);
            expect(sut.layer.borderColor).to.equal(color.CGColor);
            expect(sut.layer.anchorPoint).to.equal(CGPointMake(0.5, 0.5));
            expect(sut.backgroundColor).to.equal([UIColor clearColor]);
        });
    });
    
    context(@"animations", ^{
        __block EnemyView *sut;

        beforeEach(^{
            sut = [[EnemyView alloc] initWithViewModel:viewModelMock];
        });
        
        context(@"when animation becomes create", ^{
            it(@"should animate fade in and reset the animation type", ^{
                //context
                sut.alpha = 0;
                OCMStub([viewModelMock animationType]).andReturn(CreateAnimation);
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(CreateAnimation)];
                
                //expect
                expect(sut.alpha).to.equal(1);
                OCMVerify([viewModelMock setAnimationType:NoAnimation]);
            });
        });
        
        context(@"when animation becomes move", ^{
            it(@"should animate move to the point, set the bg color, and reset the animation type", ^{
                //context
                UIColor *origColor = [UIColor clearColor];
                UIColor *animateColor = [UIColor blackColor];
                CGFloat duration = 0.1;
                CGPoint movePoint = CGPointMake(13, 37);
                OCMStub([viewModelMock animationType]).andReturn(MoveAnimation);
                OCMStub([viewModelMock movePoint]).andReturn(movePoint);
                OCMStub([viewModelMock moveDuration]).andReturn(duration);
                OCMStub([viewModelMock color]).andReturn(animateColor);
                sut.backgroundColor = origColor;
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(MoveAnimation)];
                
                //expect
                expect(sut.frame.origin).to.equal(movePoint);
                expect(sut.backgroundColor).to.equal(animateColor);
                expect(sut.backgroundColor).after(duration).to.equal(origColor);
                OCMVerify([viewModelMock setAnimationType:NoAnimation]);
            });
        });
        
        context(@"when animation becomes snap and move", ^{
            it(@"should snap to a point, animate move to another the point, set the bg color, and reset the animation type", ^{
                //context
                UIColor *origColor = [UIColor clearColor];
                UIColor *animateColor = [UIColor blackColor];
                CGFloat duration = 0.1;
                CGPoint snapPoint = CGPointMake(20, 12);
                CGPoint movePoint = CGPointMake(13, 37);
                OCMStub([viewModelMock animationType]).andReturn(SnapAndMoveAnimation);
                OCMStub([viewModelMock movePoint]).andReturn(movePoint);
                OCMStub([viewModelMock snapPoint]).andReturn(snapPoint);
                OCMStub([viewModelMock moveDuration]).andReturn(duration);
                OCMStub([viewModelMock color]).andReturn(animateColor);
                sut.backgroundColor = origColor;
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(SnapAndMoveAnimation)];
                
                //TODO: figure out how to properly test this, the frame isn't changing over time so not sure how
                //expect
                //expect(sut.frame.origin).to.equal(snapPoint);
                expect(sut.backgroundColor).to.equal(animateColor);
                expect(sut.backgroundColor).after(duration).to.equal(origColor);
                expect(sut.frame.origin).after(duration).to.equal(movePoint);
                OCMVerify([viewModelMock setAnimationType:NoAnimation]);
            });
        });
        
        context(@"when animation becomes move and remove", ^{
            it(@"should animate move to the point, set the bg color, remove from superview on completion, and reset the animation type", ^{
                //context
                UIView *superView = [[UIView alloc] init];
                [superView addSubview:sut];
                UIColor *origColor = [UIColor clearColor];
                UIColor *animateColor = [UIColor blackColor];
                CGFloat duration = 0.1;
                CGPoint movePoint = CGPointMake(13, 37);
                OCMStub([viewModelMock animationType]).andReturn(MoveAndRemoveAnimation);
                OCMStub([viewModelMock movePoint]).andReturn(movePoint);
                OCMStub([viewModelMock moveDuration]).andReturn(duration);
                OCMStub([viewModelMock color]).andReturn(animateColor);
                sut.backgroundColor = origColor;
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(MoveAndRemoveAnimation)];
                
                //expect
                expect(sut.frame.origin).to.equal(movePoint);
                expect(sut.backgroundColor).to.equal(animateColor);
                expect(sut.backgroundColor).after(duration).to.equal(origColor);
                expect(sut.superview).after(duration).to.beNil();
                OCMVerify([viewModelMock setAnimationType:NoAnimation]);
            });
        });
        
        context(@"when animation becomes destroy and remove", ^{
            it(@"should shrink the view, move it to back remove from superview on completion, and reset the animation type", ^{
                //context
                CGFloat duration = 0.1; //hardcoded check for dispatch after
                UIView *superView = [[UIView alloc] init];
                [superView addSubview:sut];
                CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
                id superViewMock = OCMPartialMock(superView);
                OCMStub([viewModelMock animationType]).andReturn(DestroyAndRemoveAnimation);
                sut.transform = transform;
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(DestroyAndRemoveAnimation)];
                
                //expect
                OCMVerify([superViewMock sendSubviewToBack:sut]);
                expect(CGAffineTransformEqualToTransform(sut.transform, transform)).to.beFalsy();
                expect(sut.superview).after(duration).to.beNil();
                OCMVerify([viewModelMock setAnimationType:NoAnimation]);
                
                //cleanup
                [superViewMock stopMocking];
            });
        });
    });
    
    afterEach(^{
        [viewModelMock stopMocking];
    });
});

SpecEnd