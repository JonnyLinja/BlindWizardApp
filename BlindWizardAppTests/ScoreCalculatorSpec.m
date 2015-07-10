#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "ScoreCalculator.h"

SpecBegin(ScoreCalculator)

describe(@"ScoreCalculator", ^{
    context(@"when passed the number of destroyed enemies", ^{
        it(@"should return a score", ^{
            //context
            ScoreCalculator *sut = [[ScoreCalculator alloc] init];
            
            //because
            NSInteger result = [sut calculateScoreFromNumberOfEnemiesDestroyed:4];
            
            //expect
            expect(result).to.equal(16);
        });
    });
});

SpecEnd