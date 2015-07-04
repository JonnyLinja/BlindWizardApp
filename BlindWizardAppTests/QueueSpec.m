#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "Queue.h"

@interface Queue (Test)
@property (nonatomic, strong) NSMutableArray *array;
@end

SpecBegin(Queue)

describe(@"Queue", ^{
    __block Queue *sut;
    
    beforeEach(^{
        sut = [[Queue alloc] init];
    });
    
    
    context(@"when there is at least one item in the array", ^{
        it(@"should set hasObject to YES", ^{
            //because
            [sut add:@1];
            
            //expect
            expect(sut.hasObject).to.beTruthy();
        });
    });
    
    context(@"when there are no items in the array", ^{
        it(@"should set hasObject to YES", ^{
            //context
            [sut add:@1];
            
            //because
            [sut pop];
            
            //expect
            expect(sut.hasObject).to.beFalsy();
        });
    });
    
    context(@"when pushing a non nil object", ^{
        it(@"should add the object to the end of the array", ^{
            //context
            sut.array = [@[@1, @2] mutableCopy];
            
            //because
            [sut push:@3];
            
            //expect
            expect(sut.array).to.equal([@[@1, @2, @3] mutableCopy]);
        });
    });
    
    context(@"when adding a non nil object", ^{
        it(@"should add the object to the beginning of the array", ^{
            //context
            sut.array = [@[@1, @2] mutableCopy];
            
            //because
            [sut add:@3];
            
            //expect
            expect(sut.array).to.equal([@[@3, @1, @2] mutableCopy]);
        });
    });

    context(@"when popping an object off an array with at least 1", ^{
        it(@"should remove and return the last item in the array", ^{
            //context
            [sut push:@1];
            [sut push:@2];
            [sut push:@3];
            
            //because
            NSNumber *n = [sut pop];
            
            //expect
            expect(sut.array).to.equal([@[@1, @2] mutableCopy]);
            expect(n).to.equal(@3);
        });
    });
});

SpecEnd