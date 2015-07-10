#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>
#import "NSObject+MTKTest.h"

#import "LeaderboardViewModel.h"
#import "TopScores.h"

SpecBegin(LeaderboardViewModel)

describe(@"LeaderboardViewModel", ^{
    context(@"when getting the list of top scores", ^{
        it(@"should return a concantenated string of the scores", ^{
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
            expect(string).to.equal(@"3\n\n2\n\n1");
        });
    });
});

SpecEnd