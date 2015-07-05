#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GridCalculator.h"

@interface GridCalculator (Test)
@property (nonatomic, assign) NSInteger numRows;
@property (nonatomic, assign) NSInteger numColumns;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat horizontalPadding;
@end

SpecBegin(GridCalculator)

describe(@"GridCalculator", ^{
    __block GridCalculator *sut;
    
    beforeEach(^{
        sut = [[GridCalculator alloc] init];
    });
    
    context(@"when calculating num rows and cols for size", ^{
        it(@"should save size, calculate & save verticalPadding, and set numRows & numColumns", ^{
            //context
            CGSize size = CGSizeMake(327, 604);
            sut.squareWidth = 30;
            sut.squareHeight = 40;
            
            //because
            [sut calculateNumberOfRowsAndColumnsForSize:size];
            
            //expect
            expect(sut.numRows).to.equal(15);
            expect(sut.numColumns).to.equal(10);
            expect(sut.size).to.equal(size);
            expect(sut.verticalPadding).to.equal(4);
            expect(sut.horizontalPadding).to.equal(3);
        });
    });
    
    context(@"after calculate rows and cols", ^{
        beforeEach(^{
            sut.squareWidth = 30;
            sut.squareHeight = 40;
            [sut calculateNumberOfRowsAndColumnsForSize:CGSizeMake(329, 604)];
        });
        
        context(@"when calculating row for y pos", ^{
            it(@"return a row based on square height and size height and verticalPadding", ^{
                //because
                NSInteger row = [sut calculateRowForYPos:83];
                
                //expect
                expect(row).to.equal(13);
            });
        });
        
        context(@"when calculating point for row and column", ^{
            it(@"return a cgpoint origin of that grid position", ^{
                //context
                CGPoint finalPoint = CGPointMake(133, 444);
                
                //because
                CGPoint point = [sut calculatePointForRow:3 column:4];
                
                //expect
                expect(point).to.equal(finalPoint);
            });
        });
    });
});

SpecEnd