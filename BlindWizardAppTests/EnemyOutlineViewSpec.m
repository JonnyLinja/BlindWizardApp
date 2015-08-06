#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "EnemyOutlineView.h"
#import "EnemyOutlineViewModel.h"

SpecBegin(EnemyOutlineView)

describe(@"EnemyOutlineView", ^{
    __block id viewModelMock;
    
    beforeEach(^{
        viewModelMock = OCMClassMock([EnemyOutlineViewModel class]);
    });
    
    //TODO: is it possible to test drive draw code?
    pending(@"when loaded", ^{
        it(@"should displayed a colored dotted rectangle", ^{
        });
    });
    
    context(@"animations", ^{
    });
    
    afterEach(^{
        [viewModelMock stopMocking];
    });
});

SpecEnd