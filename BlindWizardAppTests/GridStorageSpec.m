#import <Specta/Specta.h>
#import "Expecta.h"
#import <OCMock/OCMock.h>

#import "GridStorage.h"
#import "GridStorageKeyGenerator.h"

SpecBegin(GridStorage)

describe(@"GridStorage", ^{
    __block GridStorage *sut;
    __block id gridStorageKeyGeneratorMock;
    
    beforeEach(^{
        sut = [[GridStorage alloc] init];
        gridStorageKeyGeneratorMock = OCMClassMock([GridStorageKeyGenerator class]);
        sut.keyGenerator = gridStorageKeyGeneratorMock;
    });
    
    context(@"when retrieving an object at a row and column", ^{
        it(@"should return the object", ^{
            //context
            NSString *key = @"1:2";
            NSInteger row = 1;
            NSInteger column = 2;
            NSObject *obj = [[NSObject alloc] init];
            id dictionaryMock = OCMPartialMock(sut.objects);
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]).andReturn(key);
            OCMStub([dictionaryMock objectForKey:key]).andReturn(obj);
            
            //because
            id returnedObject = [sut objectForRow:row column:column];
            
            //expect
            OCMVerify([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]);
            expect(returnedObject).to.equal(obj);
            
            //cleanup
            [dictionaryMock stopMocking];
        });
    });
    
    context(@"when promising to set an object at a row and column", ^{
        it(@"should add the object to a pending store for the key and add the key to a pending removal store", ^{
            //context
            NSString *key = @"1:2";
            NSInteger row = 1;
            NSInteger column = 2;
            NSObject *obj = [[NSObject alloc] init];
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]).andReturn(key);

            //because
            [sut promiseSetObject:obj forRow:row column:column];
            
            //expect
            OCMVerify([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]);
            expect([sut.objectsToAdd objectForKey:key]).to.equal(obj);
            expect(sut.keysToRemove).to.contain(key);
        });
    });
    
    context(@"when promising to remove an object at a row and column", ^{
        it(@"should add the key to a pending removal store", ^{
            //context
            NSString *key = @"1:2";
            NSInteger row = 1;
            NSInteger column = 2;
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]).andReturn(key);
            
            //because
            [sut promiseRemoveObjectForRow:row column:column];
            
            //expect
            OCMVerify([gridStorageKeyGeneratorMock stringKeyForRow:row column:column]);
            expect(sut.keysToRemove).to.contain(key);
        });
    });

    context(@"when fulfilling promises", ^{
        it(@"should remove all objects w/ pending removal store keys, add objects from the pending store, and reset both pending stores", ^{
            //context
            NSObject *obj1 = [NSObject new];
            NSObject *obj2 = [NSObject new];
            NSObject *obj3 = [NSObject new];
            NSString *key1 = @"1:1";
            NSString *key2 = @"1:2";
            NSString *key3 = @"1:3";
            NSString *key4 = @"1:4";
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:1 column:1]).andReturn(key1);
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:1 column:2]).andReturn(key2);
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:1 column:3]).andReturn(key3);
            OCMStub([gridStorageKeyGeneratorMock stringKeyForRow:1 column:4]).andReturn(key4);
            [sut promiseSetObject:obj1 forRow:1 column:2];
            [sut promiseSetObject:obj2 forRow:1 column:3];
            [sut promiseSetObject:obj3 forRow:1 column:1];

            //because
            [sut fulfillPromises];
            
            //expect - skipping OCMVerify to make my life easier, testing more classicist style here
            expect([sut.objects objectForKey:key1]).to.equal(obj3);
            expect([sut.objects objectForKey:key2]).to.equal(obj1);
            expect([sut.objects objectForKey:key3]).to.equal(obj2);
            expect([sut.objects objectForKey:key4]).to.beNil();
            expect(sut.objectsToAdd).to.beEmpty();
            expect(sut.keysToRemove).to.beEmpty();
        });
    });
    
    afterEach(^{
        [gridStorageKeyGeneratorMock stopMocking];
    });
});

SpecEnd