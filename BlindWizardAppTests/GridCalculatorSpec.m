#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GridCalculator.h"

@interface GridCalculator (Test)
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@end

SpecBegin(GridCalculator)

describe(@"GridCalculator", ^{
    __block GridCalculator *sut;
    
    beforeEach(^{
        sut = [[GridCalculator alloc] init];
    });
    
    context(@"when calculating num rows and cols for size", ^{
        it(@"should set numRows and numColumns based on the size and the square width and height", ^{
            //context
            CGSize size = CGSizeMake(300, 600);
            sut.squareWidth = 30;
            sut.squareHeight = 30;
            
            //because
            [sut calculateNumberOfRowsAndColumnsForSize:size];
            
            //expect
            expect(sut.numRows).to.equal(10);
            expect(sut.numColumns).to.equal(20);
        });
    });
    
    context(@"when calculating row for y pos", ^{
        it(@"return a row based on square height", ^{
            //context
            sut.squareHeight = 30;
            
            //because
            NSInteger row = [sut calculateRowForYPos:65];
            
            //expect
            expect(row).to.equal(2);
        });
    });
    
    context(@"when calculating point for row and column", ^{
        it(@"return a cgpoint origin of that grid position", ^{
            
        });
    });
});

SpecEnd