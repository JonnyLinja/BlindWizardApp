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
        sut.viewModel = viewModelMock;
    });
    
    context(@"when animation becomes create", ^{
        it(@"should animate fade in", ^{
            //context
            sut.alpha = 0;
            OCMStub([viewModelMock animationType]).andReturn(CreateAnimation);
            
            //because
            [sut notifyKeyPath:@"viewModel.animationType" setTo:@(CreateAnimation)];
            
            //expect
            expect(sut.layer.opacity).to.equal(1);
        });
    });
    
    afterEach(^{
        [viewModelMock stopMocking];
    });
});

SpecEnd