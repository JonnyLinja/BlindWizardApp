#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GridStorageKeyGenerator.h"

//lacks a true because, more classicist

SpecBegin(GridStorageKeyGenerator)

describe(@"GridStorageKeyGenerator", ^{
    __block GridStorageKeyGenerator *sut;
    
    beforeEach(^{
        sut = [[GridStorageKeyGenerator alloc] init];
    });
    
    context(@"when passed two different numbers", ^{
        it(@"should return different strings", ^{
            NSString *key1 = [sut stringKeyForRow:10 column:10];
            NSString *key2 = [sut stringKeyForRow:101 column:0];
            expect(key1).toNot.equal(key2);
        });
    });
    
    context(@"when passed two same numbers", ^{
        it(@"should return the same strings", ^{
            NSString *key1 = [sut stringKeyForRow:10 column:10];
            NSString *key2 = [sut stringKeyForRow:10 column:10];
            expect(key1).to.equal(key2);
        });
    });
});

SpecEnd