#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "RandomGenerator.h"

SpecBegin(RandomGenerator)

describe(@"RandomGenerator", ^{
    __block RandomGenerator *sut;
    
    beforeEach(^{
        sut = [[RandomGenerator alloc] init];
    });
    
    //TODO: can technically have tests to confirm maximum is > minimum
    //OR can use NSRange
    
    //TODO: unsure how to actually test this as it's...RANDOM
    context(@"when generating a random number", ^{
        it(@"should return a number between the minimum and the maximum", ^{
            //context
            NSInteger minimum = 1;
            NSInteger maximum = 5;
            sut.minimum = minimum;
            sut.maximum = maximum;
            
            //because
            NSInteger number = [sut generate];
            
            //expect
            expect(number).to.beGreaterThanOrEqualTo(minimum);
            expect(number).to.beLessThanOrEqualTo(maximum);
        });
    });
});

SpecEnd