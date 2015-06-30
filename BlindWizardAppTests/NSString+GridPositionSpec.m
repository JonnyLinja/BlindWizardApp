#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "NSString+GridPosition.h"

//testing this is a little weird, not really BDD
//but done because of problems using an actual object as a NSDictionary key
//even after implementing NSCopying and isEqual, actual object had strange behavior

SpecBegin(NSString)

describe(@"NSString+GridPosition", ^{
    context(@"when passed two different numbers", ^{
        it(@"should return different strings", ^{
            //context
            NSString *n1 = [NSString stringFromRow:10 column:10];
            NSString *n2 = [NSString stringFromRow:101 column:0];
            
            //expect
            expect(n1).toNot.equal(n2);
        });
    });
    
    context(@"when passed two same numbers", ^{
        it(@"should return the same strings", ^{
            //context
            NSString *n1 = [NSString stringFromRow:10 column:10];
            NSString *n2 = [NSString stringFromRow:10 column:10];
            
            //expect
            expect(n1).to.equal(n2);
        });
    });
});

SpecEnd