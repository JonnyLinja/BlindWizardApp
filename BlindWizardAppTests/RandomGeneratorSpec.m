#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "RandomGenerator.h"

SpecBegin(RandomGenerator)

describe(@"RandomGenerator", ^{
    //TODO: can technically have tests to confirm maximum is > minimum
    //OR can use NSRange
    
    //TODO: unsure how to actually test this as it's...RANDOM
    context(@"when generating a random number", ^{
        it(@"should return a number between the minimum and the maximum", ^{
            //context
            NSInteger minimum = 1;
            NSInteger maximum = 5;
            RandomGenerator *sut = [[RandomGenerator alloc] initWithMinimum:minimum maximum:maximum];
            
            //because
            NSInteger number = [sut generate];
            
            //expect
            expect(number).to.beGreaterThanOrEqualTo(minimum);
            expect(number).to.beLessThanOrEqualTo(maximum);
        });
    });
});

SpecEnd