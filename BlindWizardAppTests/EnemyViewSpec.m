#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "EnemyView.h"
#import "EnemyViewModel.h"

@interface EnemyView()
@property (nonatomic, weak, readonly) UIView *bg;
@end

SpecBegin(EnemyView)

describe(@"EnemyView", ^{
    __block id viewModelMock;
    
    beforeEach(^{
        viewModelMock = OCMClassMock([EnemyViewModel class]);
    });
    
    //note trying to only test minimum
    context(@"when loaded", ^{
        it(@"should display a colored smiley", ^{
            //context
            UIColor *color = [UIColor magentaColor];
            OCMStub([viewModelMock color]).andReturn(color);
            
            //because
            EnemyView *sut = [[EnemyView alloc] initWithViewModel:viewModelMock];
            
            //expect
            expect(sut.layer.anchorPoint).to.equal(CGPointMake(0.5, 0.5));
            expect(sut.layer.borderColor).to.equal(color.CGColor);
            expect(sut.textColor).to.equal(color);
            expect(sut.bg.backgroundColor).to.equal(color);
        });
    });
    
    context(@"animations", ^{
        __block EnemyView *sut;

        beforeEach(^{
            sut = [[EnemyView alloc] initWithViewModel:viewModelMock];
        });
        
        context(@"when face changes", ^{
            it(@"should update the text", ^{
                //context
                NSString *face = @"foobar";
                OCMStub([viewModelMock face]).andReturn(face);
                
                //because
                [sut notifyKeyPath:@"viewModel.face" setTo:face];
                
                //expect
                expect(sut.text).to.equal(face);
            });
        });
        
        context(@"when animation becomes create", ^{
            it(@"should animate fade in", ^{
                //context
                sut.alpha = 0;
                OCMStub([viewModelMock animationType]).andReturn(CreateAnimation);
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(CreateAnimation)];
                
                //expect
                expect(sut.alpha).to.equal(1);
            });
        });
        
        context(@"when animation becomes move", ^{
            it(@"should animate move to the point", ^{
                //context
                CGFloat duration = 0.1;
                CGPoint movePoint = CGPointMake(13, 37);
                OCMStub([viewModelMock animationType]).andReturn(MoveAnimation);
                OCMStub([viewModelMock movePoint]).andReturn(movePoint);
                OCMStub([viewModelMock moveDuration]).andReturn(duration);
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(MoveAnimation)];
                
                //expect
                expect(sut.frame.origin).to.equal(movePoint);
            });
            
            it(@"should run neutral animation after delay", ^{
                //context
                CGFloat duration = 0.1;
                OCMStub([viewModelMock animationType]).andReturn(MoveAnimation);
                OCMStub([viewModelMock moveDuration]).andReturn(duration);
                OCMExpect([viewModelMock runNeutralAnimation]);
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(MoveAnimation)];
                
                //expect
                OCMVerifyAllWithDelay(viewModelMock, duration);
            });
        });
        
        context(@"when animation becomes snap and move", ^{
            it(@"should snap to a point and animate move to another the point", ^{
                //context
                CGFloat duration = 0.1;
                CGPoint snapPoint = CGPointMake(20, 12);
                CGPoint movePoint = CGPointMake(13, 37);
                OCMStub([viewModelMock animationType]).andReturn(SnapAndMoveAnimation);
                OCMStub([viewModelMock movePoint]).andReturn(movePoint);
                OCMStub([viewModelMock snapPoint]).andReturn(snapPoint);
                OCMStub([viewModelMock moveDuration]).andReturn(duration);
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(SnapAndMoveAnimation)];
                
                //TODO: figure out how to properly test this, the frame isn't changing over time so not sure how
                //expect
                //expect(sut.frame.origin).to.equal(snapPoint);
                expect(sut.frame.origin).after(duration).to.equal(movePoint);
            });
            
            it(@"should run neutral animation after delay", ^{
                //context
                CGFloat duration = 0.1;
                OCMStub([viewModelMock animationType]).andReturn(SnapAndMoveAnimation);
                OCMStub([viewModelMock moveDuration]).andReturn(duration);
                OCMExpect([viewModelMock runNeutralAnimation]);
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(SnapAndMoveAnimation)];
                
                //expect
                OCMVerifyAllWithDelay(viewModelMock, duration);
            });
        });
        
        context(@"when animation becomes move and remove", ^{
            it(@"should animate move to the point, and remove from superview on completion", ^{
                //context
                UIView *superView = [[UIView alloc] init];
                [superView addSubview:sut];
                CGFloat duration = 0.1;
                CGPoint movePoint = CGPointMake(13, 37);
                OCMStub([viewModelMock animationType]).andReturn(MoveAndRemoveAnimation);
                OCMStub([viewModelMock movePoint]).andReturn(movePoint);
                OCMStub([viewModelMock moveDuration]).andReturn(duration);
                
                //because
                [sut notifyKeyPath:@"viewModel.animationType" setTo:@(MoveAndRemoveAnimation)];
                
                //expect
                expect(sut.frame.origin).to.equal(movePoint);
                expect(sut.superview).after(duration).to.beNil();
            });
        });
        
        context(@"when animation becomes destroy and remove", ^{
            it(@"should shrink the view, move it to back, and remove from superview on completion", ^{
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