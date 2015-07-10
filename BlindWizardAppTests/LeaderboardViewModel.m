#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "LeaderboardViewModel.h"
#import "TopScores.h"

SpecBegin(LeaderboardViewModel)

describe(@"LeaderboardViewModel", ^{
    context(@"when getting an empty list of scores", ^{
        it(@"should return a string of 10 0s", ^{
            //context
            LeaderboardViewModel *sut = [[LeaderboardViewModel alloc] init];

            //because
            [sut notifyKeyPath:@"topScores.scores" setTo:[NSArray new]];
            NSString *string = [sut listOfTopScores];
            
            //expect
            expect(string).to.equal(@"0\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0");
        });
    });
    context(@"when getting the list of top scores", ^{
        it(@"should return a concantenated string of 10 scores, adding 0s if needed", ^{
            //context
            NSArray *scores = @[@3, @2, @1];
            LeaderboardViewModel *sut = [[LeaderboardViewModel alloc] init];
            id scoreMock = OCMClassMock([TopScores class]);
            sut.topScores = scoreMock;
            OCMStub([scoreMock scores]).andReturn(scores);
            
            //because
            [sut notifyKeyPath:@"topScores.scores" setTo:scores];
            NSString *string = [sut listOfTopScores];
            
            //expect
            expect(string).to.equal(@"3\n\n2\n\n1\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0\n\n0");
            
            //cleanup
            [scoreMock stopMocking];
        });
    });
});

SpecEnd