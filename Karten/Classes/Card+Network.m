#import "Card+Network.h"
#import "CouchManager.h"
#import "Database.h"
#import "Stack.h"

@implementation Card (Network)
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
@end
