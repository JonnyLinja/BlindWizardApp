#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "ScoreCalculator.h"

SpecBegin(ScoreCalculator)

describe(@"ScoreCalculator", ^{
    context(@"when calculating the score per each enemy", ^{
        it(@"should return the count", ^{
            //context
            ScoreCalculator *sut = [[ScoreCalculator alloc] init];
            
            //because
            NSInteger result = [sut calculateScorePerEnemyAfterDestroying:4];
            
            //expect
            expect(result).to.equal(4);
        });
    });
    
    context(@"when calculating the total score", ^{
        it(@"should return the count squared", ^{
            //context
            ScoreCalculator *sut = [[ScoreCalculator alloc] init];
            
            //because
            NSInteger result = [sut calculateTotalScoreFromNumberOfEnemiesDestroyed:4];
            
            //expect
            expect(result).to.equal(16);
        });
    });
});

SpecEnd