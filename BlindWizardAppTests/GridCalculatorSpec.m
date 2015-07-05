#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GridCalculator.h"

@interface GridCalculator (Test)
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, assign) CGSize size;
@end

SpecBegin(GridCalculator)

describe(@"GridCalculator", ^{
    __block GridCalculator *sut;
    
    beforeEach(^{
        sut = [[GridCalculator alloc] init];
    });
    
    context(@"when calculating num rows and cols for size", ^{
        it(@"should save size and set numRows / numColumns based on the size + the square width / height", ^{
            //context
            CGSize size = CGSizeMake(303, 604);
            sut.squareWidth = 30;
            sut.squareHeight = 40;
            
            //because
            [sut calculateNumberOfRowsAndColumnsForSize:size];
            
            //expect
            expect(sut.numRows).to.equal(10);
            expect(sut.numColumns).to.equal(15);
            expect(sut.size).to.equal(size);
        });
    });
    
    //TODO: fix it, because origin is diff
    pending(@"when calculating row for y pos", ^{
        it(@"return a row based on square height", ^{
            //context
            sut.squareHeight = 40;
            
            //because
            NSInteger row = [sut calculateRowForYPos:85];
            
            //expect
            expect(row).to.equal(2);
        });
    });
    
    //TODO: this is a lot harder as needs to be perfectly bottom aligned AND spread out horizontally to hit end screen
    pending(@"when calculating point for row and column", ^{
        it(@"return a cgpoint origin of that grid position", ^{
            //context
            sut.numRows = 10;
            sut.numColumns = 15;
            sut.squareWidth = 30;
            sut.squareHeight = 40;
            CGPoint finalPoint = CGPointMake(90, 160);
            
            //because
            CGPoint point = [sut calculatePointForRow:3 column:4];
            
            //expect
            expect(point).to.equal(finalPoint);
        });
    });
});

SpecEnd