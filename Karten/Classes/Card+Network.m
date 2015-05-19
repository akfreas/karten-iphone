#import "Card+Network.h"
#import "CouchManager.h"
#import "Database.h"
#import "Stack.h"

@implementation KTCard (Network)
- (void)addCardToStackOnServer:(Stack *)stack error:(NSError *__autoreleasing *)error
{
    NSDictionary *cardDocument = @{@"term": self.term,
                                   @"definition": self.definition,
                                   @"created_at" : [CBLJSON JSONObjectWithDate:[NSDate date]]};
    CBLDocument *newCardDocument = [[[CouchManager databaseForStack:stack] couchDatabase] createDocument];
    if ([newCardDocument putProperties:cardDocument error:error]) {
        return;
    }
}

- (void)updateCardOnCouch:(NSError * __autoreleasing *)error
{
    NSDictionary *cardChanges = @{@"term" : self.term,
                                   @"definition" : self.definition,
                                   };
    CBLDocument *existingDocument = [[[CouchManager databaseForStack:self.stack] couchDatabase] existingDocumentWithID:self.couchID];
    [existingDocument update:^BOOL(CBLUnsavedRevision *revision) {
        [revision.properties setValuesForKeysWithDictionary:cardChanges];
        return YES;
    } error:error];
}

@end
