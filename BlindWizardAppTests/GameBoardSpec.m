#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameBoard.h"

SpecBegin(GameBoard)

describe(@"GameBoard", ^{
    __block GameBoard *sut;
    
    beforeEach(^{
        sut = [[GameBoard alloc] init];
    });
    
    context(@"when passed a row and column", ^{
        it(@"should calculate the index", ^{
            //context
            sut.numColumns = 7;
            
            //because
            NSInteger index = [sut indexFromRow:4 column:9];
            
            //expect
            expect(index).to.equal(37);
        });
    });
});

SpecEnd