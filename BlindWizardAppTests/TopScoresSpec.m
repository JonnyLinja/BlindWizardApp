#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "TopScores.h"

@interface TopScores (Test)
@property (nonatomic, strong) NSArray *scores;
@end

SpecBegin(TopScores)

describe(@"TopScores", ^{
    context(@"when initialized", ^{
        it(@"should load scores from store into array", ^{
            //context
            id storeMock = OCMPartialMock([NSUserDefaults standardUserDefaults]);
            NSArray *array = @[@3, @2, @1];
            OCMStub([storeMock objectForKey:@"scores"]).andReturn(array);
            
            //because
            TopScores *sut = [[TopScores alloc] init];
            
            //expect
            expect(sut.scores).to.equal(array);
            
            //cleanup
            [storeMock stopMocking];
        });
    });
    
    context(@"when adding a score greater than 0 with less than 10 saved scores", ^{
        it(@"should add the new score into the sorted array and update the store", ^{
            //context
            id storeMock = OCMPartialMock([NSUserDefaults standardUserDefaults]);
            NSArray *startData = @[@10, @9, @8, @7, @6, @5, @4, @3, @2];
            NSArray *endData = @[@10, @9, @8, @7, @6, @5, @4, @3, @2, @1];
            OCMStub([storeMock objectForKey:@"scores"]).andReturn(startData);
            TopScores *sut = [[TopScores alloc] init];
            
            //because
            [sut addScore:1];
            
            //expect
            expect(sut.scores).to.equal(endData);
            OCMVerify([storeMock setObject:endData forKey:@"scores"]);
            OCMVerify([storeMock synchronize]);
            
            //cleanup
            [storeMock stopMocking];
        });
    });
    
    context(@"when adding a score that is high enough to qualify in the top 10 AND is greater than 0", ^{
        it(@"should remove the lowest score, insert the new score into the sorted array, and update the store", ^{
            //context
            id storeMock = OCMPartialMock([NSUserDefaults standardUserDefaults]);
            NSArray *startData = @[@10, @9, @8, @7, @6, @5, @4, @3, @2, @1];
            NSArray *endData = @[@10, @9, @8, @7, @6, @5, @4, @3, @3, @2];
            OCMStub([storeMock objectForKey:@"scores"]).andReturn(startData);
            TopScores *sut = [[TopScores alloc] init];
            
            //because
            [sut addScore:3];
            
            //expect
            expect(sut.scores).to.equal(endData);
            OCMVerify([storeMock setObject:endData forKey:@"scores"]);
            OCMVerify([storeMock synchronize]);
            
            //cleanup
            [storeMock stopMocking];
        });
    });
});

SpecEnd