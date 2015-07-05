#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "EnemyView.h"
#import "EnemyViewModel.h"

SpecBegin(EnemyView)

describe(@"EnemyView", ^{
    __block EnemyView *sut;
    __block id viewModelMock;
    
    beforeEach(^{
        sut = [[EnemyView alloc] init];
        viewModelMock = OCMClassMock([EnemyViewModel class]);
    });
    
    context(@"when loaded", ^{
        it(@"should display a colored bordered rectangle", ^{
            //context
            UIColor *color = [UIColor blackColor];
            OCMStub([viewModelMock color]).andReturn(color);
            
            //because
            sut.viewModel = viewModelMock;
            
            //expect
            expect(sut.layer.borderWidth).to.beGreaterThan(1);
            expect(sut.layer.borderColor).to.equal(color.CGColor);
            expect(sut.backgroundColor).to.equal([UIColor clearColor]);
        });
    });
    
    context(@"aniimations", ^{
        beforeEach(^{
            sut.viewModel = viewModelMock;
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
                waitUntil(^(DoneCallback done) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        expect(sut.backgroundColor).to.equal(origColor);
                        done();
                    });
                });
            });
        });
    });
    
    afterEach(^{
        [viewModelMock stopMocking];
    });
});

SpecEnd