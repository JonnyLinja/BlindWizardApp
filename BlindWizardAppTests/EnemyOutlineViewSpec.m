#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "EnemyOutlineView.h"
#import "EnemyOutlineViewModel.h"

SpecBegin(EnemyOutlineView)

describe(@"EnemyOutlineView", ^{
    __block id viewModelMock;
    __block EnemyOutlineView *sut;

    beforeEach(^{
        viewModelMock = OCMClassMock([EnemyOutlineViewModel class]);
        sut = [[EnemyOutlineView alloc] initWithViewModel:viewModelMock];

    });
    
    pending(@"when creating", ^{
        it(@"should animate fade in", ^{
            
        });
    });
    
    context(@"when removing", ^{
        it(@"should remove the view", ^{
            //context
            UIView *superView = [[UIView alloc] init];
            [superView addSubview:sut];
            OCMStub([viewModelMock animationType]).andReturn(DestroyAndRemoveOutlineAnimation);
            
            //because
            [sut notifyKeyPath:@"viewModel.animationType" setTo:@(DestroyAndRemoveOutlineAnimation)];
            
            //expect
            expect(sut.superview).to.beNil();
        });
    });
    
    afterEach(^{
        [viewModelMock stopMocking];
    });
});

SpecEnd