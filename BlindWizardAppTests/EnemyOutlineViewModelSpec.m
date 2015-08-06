#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "EnemyOutlineViewModel.h"
#import <UIKit/UIKit.h>

SpecBegin(EnemyOutlineViewModel)

describe(@"EnemyOutlineViewModel", ^{
    __block EnemyOutlineViewModel *sut;

    beforeEach(^{
        sut = [[EnemyOutlineViewModel alloc] initWithType:2 animationDurations:nil configuration:@{@"Color" : @"#FFFFFF"}];
    });
    
    context(@"when type is set", ^{
        it(@"should set the color", ^{
            expect(sut.color).to.equal([UIColor colorWithRed:1 green:1 blue:1 alpha:1]);
        });
    });
    
    context(@"when running a create animation", ^{
        it(@"should set animation type to create", ^{
            //because
            [sut runCreateAnimation];
            
            //expect
            expect(sut.animationType).to.equal(CreateOutlineAnimation);
        });
    });
    
    context(@"when running a destroy animation", ^{
        it(@"should set animation type to destroy and remove", ^{
            //because
            [sut runDestroyAnimation];
            
            //expect
            expect(sut.animationType).to.equal(DestroyAndRemoveOutlineAnimation);
        });
    });
});

SpecEnd