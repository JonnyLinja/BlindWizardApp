#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GameBoard.h"

SpecBegin(GameBoard)

describe(@"GameBoard", ^{
    __block GameBoard *sut;
    
    beforeEach(^{
        sut = [[GameBoard alloc] initWithRows:5 columns:10];
    });
    
    context(@"when loaded", ^{
        it(@"should be active", ^{
            expect(sut.isActive).to.equal(YES);
        });
        
        it(@"should create an array with the appropriate number of items", ^{
            expect(sut.data.count).to.equal(50);
        });
        
        it(@"should have a non nil nextwavedata", ^{
            expect(sut.nextWaveData).toNot.beNil();
        });
    });
    
    context(@"when passed a row and column", ^{
        it(@"should calculate the index", ^{
            //because
            NSInteger index = [sut indexFromRow:3 column:8];
            
            //expect
            expect(index).to.equal(38);
        });
    });
});

SpecEnd